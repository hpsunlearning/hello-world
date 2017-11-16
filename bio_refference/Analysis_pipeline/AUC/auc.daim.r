argv <- commandArgs(T)
if(length(argv) == 0){stop("auc.daim.r [input]
input: p outcome.
output:ROC.plot.
")}

library("Daim")
dat <- read.table(argv[1])
AA=data.frame(p=dat[,2],outcome=dat[,3])
M <- roc(AA[,1], AA[,2] ,"case")
pdf("ROC.daim.pdf")
plot(M)
dev.off()


