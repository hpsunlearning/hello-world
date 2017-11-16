argv <- commandArgs(T)
if(length(argv)!=3) {
	stop("require input: train_data label model")
}

library(ggplot2)
library(pROC)
library(caret)
library(Cairo)

logistic_test <- function(train, test, label, fit,...){
	model = glm(formula=fit, data=train, family = "binomial")
	train$prob = model$fitted.values
	modelroc = roc(train[label][,1],train$prob)
	modelres = coords(modelroc,"best",ret=c("threshold","accuracy"))
	if (class(modelres) == "matrix"){
		modelres = modelres[,which.min(abs(modelres[1,]-0.5))]
	}
	train_accuracy = modelres["accuracy"]
	test$prob = predict(model,type = "response", newdata = test)
	test$pred = ifelse(test$prob > modelres["threshold"],1,0)
	test_accuracy = sum(test[label][,1] == test$pred) / nrow(test)
	res = c(train_accuracy, test_accuracy)
}

k_fold_cv <- function(train,label,k=10,fit){
	folds = createFolds(train[label][,1],k)
	res = matrix(0,k,2)
	for(i in 1:length(folds)){
		train_i = train[-folds[[i]],]
		test_i = train[folds[[i]],]
		res[i,] = logistic_test(train_i,test_i,label,fit)
	}
	colnames(res) = c("train_accuracy","test_accuracy")
	colMeans(res)
}

logistic_all <- function(train, label, fit,...){
	model = glm(formula=fit, data=train, family = "binomial")
	train$prob = model$fitted.values
	modelroc = roc(train[label][,1],train$prob)
	modelauc = modelroc$auc[1]
	modelres = coords(modelroc,"best",ret=c("threshold","sensitivity","specificity","accuracy","precision","recal","tn","tp","fn","fp"))
	if (class(modelres) == "matrix"){
		modelres = modelres[,which.min(abs(modelres[1,]-0.5))]
	}
	youden = modelres["sensitivity"] + modelres["specificity"] - 1
	f_measure = 2/(1/modelres["precision"] + 1/modelres["recall"])
	A = modelres["tp"]
	B = modelres["fp"]
	C = modelres["fn"]
	D = modelres["tn"]
	N = modelres["tp"] + modelres["tn"] + modelres["fp"] + modelres["fn"]
	p0 = modelres["accuracy"]
	pe = ((A+B)*(A+C)+(B+D)*(C+D))/(N*N)
	K = (p0-pe)/(1-pe)
	modelres = modelres[-c(7,8,9,10)]
	
	outfile = paste(fit,".png",sep="")
	CairoPNG(outfile,width=500,height=500)
	par(mar=c(0,0,0,0))
	plot(modelroc,print.auc=TRUE,auc.polygon=TRUE,grid=c(0.1,0.2),grid.col=c("green","red"),max.auc.polygon=TRUE,auc.polygon.col="skyblue",print.thres=TRUE)
	dev.off()	
	
	train$pred = ifelse(train$prob > modelres["threshold"],1,0)
	fn = rownames(train)[intersect(which(train[label]==1), which(train$pred==0))]#假阴性
	fp = rownames(train)[intersect(which(train[label]==0), which(train$pred==1))]#假阳性
	fn = paste(fn,collapse = ";")
	fp = paste(fp,collapse = ";")
	res = as.matrix(c(modelauc, modelres, f_measure, youden, K))
	res = as.data.frame(t(res))
	res = cbind(res,fn,fp)
	colnames(res) = c("AUC","threshold","sensitivity","specificity","accuracy","precision","recal","F1","Youden_index","Kappa","fn_sample","fp_sample")
	res
}

logistic_compare <- function(train, label, fit1, fit2...){
	model1 = glm(formula=fit1, data=train, family = "binomial")
	train$prob1 = model1$fitted.values
	modelroc1 = roc(train[label][,1],train$prob1)
	model2 = glm(formula=fit2, data=train, family = "binomial")
	train$prob2 = model2$fitted.values
	modelroc2 = roc(train[label][,1],train$prob2)
	compareroc = roc.test(modelroc1,modelroc2)
	ci1 = ci.auc(modelroc1)
	ci2 = ci.auc(modelroc1)

	
	
	
	
	
	
#	res = c(compareroc$estimate[1],ci1[1],ci1[3],compareroc$estimate[2],ci2[1],ci2[3],compareroc$p.value)
	names(res) = c("AUC1","ci1-min","ci1-max","AUC2","ci2-min","ci2-max","p_value")
	res
}

train = read.table(argv[1],sep="\t",header=T)
label = argv[2]
model = read.table(argv[3])
prefix1 = strsplit(argv[1],split="\\.")[[1]][1]
prefix2 = strsplit(argv[3],split="\\.")[[1]][1]

res =  data.frame(
				model=character(),
				AUC=double(),
				threshold=double(),
				sensitivity=double(),
				specificity=double(),
				accuracy=double(),
				precision=double(),
				recal=double(),
				F1=double(),
				Youden_index=double(),
				Kappa=double(),
				train=double(),
				test=double(),
				fn_sample=character(),
				fp_sample=character(),
                stringsAsFactors=FALSE
				)

for (i in 1:nrow(model)) {
	fit = as.character(model[i,1])
	temp1 = logistic_all(train = train, label = label, fit = fit)
	temp2 = k_fold_cv(train = train, label = label, k=nrow(train), fit = fit)
	temp2 = t(as.matrix(temp2))
	temp3 = cbind(fit,temp1[,c(1:10)],temp2,temp1[,c(11,12)])
	res = rbind(res,temp3)
}

write.table(res, file = paste(prefix1,"_",prefix2,"test.xls",sep=""), append = F, quote = F, sep = "\t", row.names = F, col.names = T)
write.table(res[,12], file = paste(prefix1,"_",prefix2,"fn.xls",sep=""), append = F, quote = F, sep = "\t", row.names = F, col.names = F)
write.table(res[,13], file = paste(prefix1,"_",prefix2,"fp.xls",sep=""), append = F, quote = F, sep = "\t", row.names = F, col.names = F)


