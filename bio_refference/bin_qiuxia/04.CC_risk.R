library(randomForest)
library(Cairo)

argv <- commandArgs(T)
dat <- read.table(argv[1],header=T)
num <- as.numeric(argv[2])
lab <- read.table(argv[3],row.names=1)
outdir <- argv[4]
rownames(lab) <- gsub("-",".",rownames(lab))
colnames(dat)<-gsub("X","",colnames(dat))

train <- dat[,-num]
lab<-lab[pmatch(colnames(train),rownames(lab)),,drop=F]
rf <- randomForest(t(train),lab[,1],prod = TRUE) 
risk <- predict (rf,t(dat))
risk <- 1-risk
write.table(as.data.frame(risk),paste(outdir,"/","CC.risk.txt",sep=""),quote=F,sep="\t")

d<-sort(risk[-num],decreasing = T)
outfile <- paste(outdir,"/","CC.risk.pdf",sep="")
CairoPDF(outfile,family = "Times New Roman")
par(mar=c(3.1,5.1,2.1,2.1))
plot(seq(1,length(d)),d,col=ifelse(lab[pmatch(names(d),rownames(lab)),]==0,hsv(alpha=0.9,s=0.5,v=0.85,h=0),hsv(alpha=0.9,s=0.5,v=0.85,h=1/3)),pch=20,xlab="",ylab="",ylim=c(0,1),cex=0.8,axes=F)
box()
abline(h=0.5,col=hsv(alpha=0.8,s=0,v=0.5),lty=4)
#mtext(c(0,0.25,0.75,1),side=2,at=c(0,0.25,0.75,1),las=1,line=0.5)
#mtext(0.5,side=2,at=0.5,col=hsv(alpha=0.8,s=0,v=0.3),las=1,line=0.5)
axis(2,labels=c(0,0.25,0.75,1),at=c(0,0.25,0.75,1),las=1)
axis(2,labels=0.5,at=0.5,col=hsv(alpha=0.8,s=0,v=0.3),las=1)
mtext("The Risk Of CRC",side =2,at=0.5,line=3.2,cex=1.3)
mtext("Reference Population",side=1,line=1,cex=1.3)
for (i in 1:num){
	points(sum(risk[-num]>=risk[i]),risk[i],col=hsv(alpha=0.9,s=0.5,v=0.85,h=2/3),pch=19,cex=1.5)
#	abline(h=risk[i],col=hsv(alpha=0.8,s=0,v=0.5),lty=4)
#	text(sum(risk[-num]>=risk[i])+10,risk[i]+0.035,round(risk[i],5),col=hsv(alpha=0.9,s=0.5,v=0.85,h=2/3),cex=1.2,lwd=1.5)
}
legend("topright",c("case","control","sample"),col=c(hsv(alpha=0.9,s=0.5,v=0.85,h=0),hsv(alpha=0.9,s=0.5,v=0.85,h=1/3),hsv(alpha=0.9,s=0.5,v=0.85,h=2/3)),pch=c(20,20,19))
dev.off()
