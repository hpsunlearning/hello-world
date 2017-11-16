argv <- commandArgs(T)
if(length(argv) == 0){stop("Rscript loocv.fig.r [input] [profile]
input: mix.
profile: profile. ")
}
aa <- read.table(argv[1])
data = read.table(argv[2])
pdf("loocv.fig.pdf")
plot(1:(ncol(data)-5),aa[1:(ncol(data)-5),2],xlab="Number of markers",ylab="Error rate",pch=19,cex=0.5)
bb <- glm(1:(ncol(data)-5)~aa[1:(ncol(data)-5),2])
abline(v=which.min(aa[1:(ncol(data)-5),2]),col=2)
cars.spl <- smooth.spline(1:(ncol(data)-5), aa[1:(ncol(data)-5),2])
lines(cars.spl,col=2,lty=2)
dev.off()

