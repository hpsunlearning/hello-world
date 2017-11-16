argv <- commandArgs(T)
if(length(argv)==0){stop("Rscript /home/xiehailiang/us/usr/bin/Rscript DMM.figure.R [input1] [output]
input1 : Genus counts profile.
input2 : It must be fit.rda.
")}
###library packages
################################################################################
library(DirichletMultinomial)
library(lattice)
library(xtable)
library(parallel)
library(vegan)
library(MASS)

count <- (as.matrix(read.table(argv[1])))
count <- count[rowSums(count)!=0,]
load(argv[2])
lplc <- sapply(fit, laplace)
##Model Fit figure.
pdf("Model.Fit.pdf")
plot(lplc, type="b", xlab="Number of Dirichlet Components", ylab="Model Fit")
dev.off()
best <- fit[[which.min(lplc)]]
coll = mixture(best)
col = apply(coll,1,which.max)
##Sample group.
write.table(col,"Sample.group.txt",quote=F,sep="\t",col.names=F)
num1 <- max(as.numeric(col))
p0 <- fitted(fit[[1]], scale=TRUE)
p2 <- fitted(best, scale=TRUE)
colnames(p2) <- paste("m", 1:num1, sep="")
diff <- rowSums(abs(p2 - as.vector(p0)))
o <- order(diff, decreasing=TRUE)
cdiff <- cumsum(diff[o]) / sum(diff)
df <- head(cbind(Mean=p0[o], p2[o,], diff=diff[o], cdiff), 10)
##Top ten most importance genus.
write.table(df,"difference_in_fit.txt",quote=F,sep="\t")

swiss.x <- as.matrix(count)
swiss.x <- sweep(swiss.x,2,apply(swiss.x,2,sum),"/")
swiss.mds <- metaMDS(t(swiss.x))
###NMDS plot.
pdf("NMDS.plot.pdf")
plot(swiss.mds$points, col = col+1,pch=19)
dev.off()
### Top five most importance genus.
num2 = 5
diff_in_fit = paste(format(sum(df[1:num2,4])*100,digit=4),"%",sep="")
write.table(diff_in_fit,"Percentage_of_difference.txt",quote=F,sep="\t",col.names=F,row.names="diff_in_fit")
bac <- rownames(df)[1:num2]
dat <- swiss.x[pmatch(bac,rownames(swiss.x)),]
pdf(paste("Top.",num2,".importance.genus.pdf",sep=""),17,5)
par(mfcol=c(1,num2))
for(i in 1:num2){
	boxplot(dat[i,]~factor(col),col=2:8,main=rownames(dat)[i],ylab = "Relative abundance",cex.lab = 1.5,ylim=c(0,1))
}
dev.off()




