argv <- commandArgs(T)
if(length(argv) == 0){stop("intersect.R  [input] [input2] [prefix]
input: meta profile
input1: metabolites profile
prefix: prefix.")}

dat<-read.table(argv[1])
res<-read.table(argv[2])
prefix<-argv[3]
if(length(res$V2)==0){
dat1=dat[,c(1,pmatch(res$V2,colnames(dat)))]
write.table(prefix,paste(prefix,".rfcv.txt",sep=""),sep="\t",quote=F,row.names=F,col.names=F)
}
if(length(res$V2)>0){
if(!is.na(pmatch('dat...n2',res[,2]))){
write.table(prefix,paste(prefix,".rfcv.txt",sep=""),sep="\t",quote=F,row.names=F,col.names=F)
}
if(is.na(pmatch('dat...n2',res[,2]))){
dat1=dat[,c(1,pmatch(res$V2,colnames(dat)))]
set.seed(0)
library(doMC)
registerDoMC(cores = 10)
library(caret)
res0=c()
for(i in 1:10){
               model <- train(y ~ ., data = dat1, method = "rf",ntree = 200,trControl = trainControl( method = 'cv', number = 10))
        res0=c(res0,model$results[pmatch(model$bestTune,model$results$mtry),3])
    }
res1<-c()
for(i in 1:999){
                id=sample(1:nrow(dat1),nrow(dat1),replace=F)
                dat2=cbind(y=dat1[id,1],dat1[,-1])
                model1 <- train(y ~ ., data = dat2, method = "rf",ntree = 200,trControl = trainControl( method = 'cv', number = 10))
                res1=c(res1, model1$results[pmatch(model1$bestTune,model1$results$mtry),3])
    }

c(prefix,round(median(res0),6),
mean( res1>median(res0)))
write.table(t(c(prefix,round(median(res0),6),mean( res1>median(res0)))),paste(prefix,".rfcv.txt",sep=""),sep="\t",quote=F,row.names=F,col.names=F)
}}
