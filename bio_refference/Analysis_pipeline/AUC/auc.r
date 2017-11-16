argv <- commandArgs(T)
if(length(argv) == 0){stop("auc.r [input] [config]
input: profile.
config: sample information.
AUC: resluts.")
}
library(pROC)
dat <- read.table(argv[1])
dat <- dat[rowSums(dat)!=0,]
dat <- sweep(dat,2,apply(dat,2,sum),"/")
auc = rep(0,nrow(dat))
for(i in 1:nrow(dat)){
outcome = read.table(argv[2])
outcome = as.factor(outcome$V2)
roc1 <- roc(outcome, as.numeric(dat[i,]),
			ci=TRUE, boot.n=100, ci.alpha=0.9, stratified=FALSE,
            	plot=F, percent=T,col=2)
			auc[i] = as.numeric(format(as.numeric(roc1$auc)/100,digits=2))
}
write.table(auc,"AUC_for_each.txt",quote=F,sep="\t",row.names=rownames(dat),col.names=F)

