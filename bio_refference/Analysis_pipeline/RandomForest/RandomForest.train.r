argv <- commandArgs(T)
if(length(argv) == 0){stop("RandomForest.train.r [input] [config]
 input: profile.
 config: config two col with no header col1 sample col2 class
   ")
 }
library(randomForest)
set.seed(1234)
dat=read.table(argv[1])
config=read.table(argv[2])
outcome<-factor(config[pmatch(colnames(dat),config[,1]),2])
train <- as.data.frame(t(dat))
train$outcome = outcome

rfcv1 <- function (trainx, trainy, cv.fold = 5, scale = "log", step = 0.5, 
    mtry = function(p) max(1, floor(sqrt(p))), recursive = FALSE, 
    ...) 
{

    classRF <- is.factor(trainy)
    n <- nrow(trainx)
    p <- ncol(trainx)
    if (scale == "log") {
        k <- floor(log(p, base = 1/step))
        n.var <- round(p * step^(0:(k - 1)))
        same <- diff(n.var) == 0
        if (any(same)) 
            n.var <- n.var[-which(same)]
        if (!1 %in% n.var) 
            n.var <- c(n.var, 1)
    }
    else {
        n.var <- seq(from = p, to = 1, by = step)
    }
    k <- length(n.var)
    cv.pred <- vector(k, mode = "list")
    for (i in 1:k) cv.pred[[i]] <- rep(0,length(trainy))
    if (classRF) {
        f <- trainy
    }
    else {
        f <- factor(rep(1:5, length = length(trainy))[order(order(trainy))])
    }
    nlvl <- table(f)
    idx <- numeric(n)
    for (i in 1:length(nlvl)) {
        idx[which(f == levels(f)[i])] <- sample(rep(1:cv.fold, 
            length = nlvl[i]))
    }
    res=list()
	for (i in 1:cv.fold) {
        all.rf <- randomForest(trainx[idx != i, , drop = FALSE], 
            trainy[idx != i],importance = TRUE)
	 aa = predict(all.rf,trainx[idx == i, , drop = FALSE],type="prob")
        cv.pred[[1]][idx == i] <- as.numeric(aa[,2])
        impvar <- (1:p)[order(all.rf$importance[, 3], decreasing = TRUE)]
		res[[i]]=impvar
        for (j in 2:k) {
            imp.idx <- impvar[1:n.var[j]]
            sub.rf <- randomForest(trainx[idx != i, imp.idx, 
                drop = FALSE], trainy[idx != i] 
            )
		bb <- predict(sub.rf,trainx[idx ==i,imp.idx, drop = FALSE],type="prob")
            cv.pred[[j]][idx == i] <- as.numeric(bb[,2])
            if (recursive) {
                impvar <- (1:length(imp.idx))[order(sub.rf$importance[, 
                  3], decreasing = TRUE)]
            }
            NULL
        }
        NULL
    }
    if (classRF) {
        error.cv <- sapply(cv.pred, function(x)  mean(factor(ifelse(x>0.5,1,0))!=trainy))
    }
    else {
        error.cv <- sapply(cv.pred, function(x) mean((trainy - 
            x)^2))
    }
    names(error.cv) <- names(cv.pred) <- n.var
    list(n.var = n.var, error.cv = error.cv, predicted = cv.pred,res=res)
}


cv_model<-function(pro=pro,n=5,cv.fold=10,step=0.8){
set.seed(1234)
result <- replicate(n, rfcv1(train[,-ncol(train)], train$outcome, cv.fold=10,step=0.8), simplify=FALSE)
error.cv <- sapply(result, "[[", "error.cv")
error.cv.cbm<-cbind(rowMeans(error.cv), error.cv)
cutoff<-min (error.cv.cbm[,1])+sd(error.cv.cbm[,1])
leng<-length(names(which(error.cv.cbm[,1]<cutoff)))
if (leng==1){min<-as.numeric(rownames(error.cv.cbm)[which(error.cv.cbm[,1]<cutoff)])
  }else {
num<-error.cv.cbm[error.cv.cbm[,1]<cutoff,]
num_p<-dim(error.cv.cbm[error.cv.cbm[,1]<cutoff,])[1]
min<-as.numeric(rownames(num))[num_p]
ifelse(min==1,min<-as.numeric(rownames(num))[num_p-1],min<-min)
}
pdf("Number_of_variables.pdf")
matplot(result[[1]]$n.var, cbind(rowMeans(error.cv), error.cv), type="l",
        lwd=c(2, rep(1, ncol(error.cv))), col=1, lty=1, log="x",
        xlab="Number of variables", ylab="CV Error")
abline(v=min,col=3)
dev.off()
num_location<-which(rownames(error.cv.cbm)==min)
result_pre<-NULL
for(i in 1:5){
result_pre<-cbind(result_pre,result[[i]]$predicted[[num_location]])
}
result_pre_mean<-apply(result_pre,1,mean)
k=1
b <- matrix(0,ncol=dim(pro)[2]-1,nrow=n*cv.fold)
for(i in 1:n){
for(j in 1:cv.fold){
	b[k,]<-result[[i]]$res[[j]]
	k=k+1
	}
}

mlg.list<-b[,1:min]
list<-c()
k=1
for(i in 1:min){
	for(j in 1:n*cv.fold){
	list[k]<-mlg.list[j,i]
	k=k+1	
}
}
mlg.sort<-as.matrix(table(list))
mlg.sort<-mlg.sort[rev(order(mlg.sort[,1])),]
pick<- as.numeric(names(head(mlg.sort,min)))
train_56=train[,pick]
XX=colnames(train_56)
write.table(XX,"marker.pick.txt",quote=F,sep="\t",col.names=F,row.names=F)
train_56$outcome = train$outcome
set.seed(1234)
train56.rf <- randomForest(train_56[,-ncol(train_56)],train_56$outcome,importance = TRUE)
train.pre <- predict(train56.rf,type="prob")
list(resulting_prob=result_pre_mean,pick_id=XX,pick_prob=train.pre,pick_predict=train56.rf$predicted)
}


train_model<-cv_model(pro=train)

pdf("marker.roc.pdf")
library("Daim")
MM<-roc(train_model$pick_prob[,2],outcome,"1")
plot(MM)
dev.off()
