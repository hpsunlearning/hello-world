argv <- commandArgs(T)
if(length(argv) == 0){stop("auc.ci.plot.r [input]
input: p outcome.
output:ROC.plot.
")}

library(pROC)
dat <- read.table(argv[1])
outcome = dat$V3
p = dat$V2
roc1 <- roc(outcome,
            p, 
		percent=TRUE,
            # arguments for auc
            #partial.auc=c(100, 90),
		 partial.auc.correct=TRUE,
            #partial.auc.focus="sens",
            # arguments for ci
            ci=TRUE, boot.n=100, ci.alpha=0.9, stratified=FALSE,
            # arguments for plot
            plot=F, auc.polygon=TRUE, max.auc.polygon=TRUE, grid=TRUE,
            #print.auc=F ,show.thres=TRUE
		)

pdf("ROC.CI.pdf")
plot(roc1,col=2)
roc1 <- roc(outcome, p,
	ci=TRUE, boot.n=100, ci.alpha=0.9, stratified=FALSE,
            plot=TRUE, add=TRUE, percent=roc1$percent,col=2)

sens.ci <- ci.se(roc1, specificities=seq(0, 100, 5))
plot(sens.ci, type="shape", col=rgb(0,1,0,alpha=0.2))
plot(sens.ci, type="bars")
plot(roc1,col=2,add=T)

legend("bottomright",c(paste("AUC=",round(roc1$ci[2],2),"%"),paste("95% CI:",round(roc1$ci[1],2),"%-",round(roc1$ci[3],2),"%")))
dev.off()




