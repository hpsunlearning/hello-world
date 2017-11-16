library(Cairo)
argv <- commandArgs(T)
d <- read.table(argv[1],row.names=1,sep="\t")
outdir <- argv[2]
dat <- d["Coprococcus eutactus",]/d["Ruminococcus",]
range <- quantile(dat[1,-1],probs=c(0.1,0.9))
pos<-sum(dat[1,-1]<dat[1,1])/(ncol(dat)-1)

stat <-c(dat[1,1],paste(range[1],"~",range[2],sep=""))
stat <- as.data.frame(t(stat))
colnames(stat) <- c("Sample Abun","Range")
rownames(stat) <- "Coprococcus eutactus/Ruminococcus"
write.table(stat,paste(outdir,"/","ratio.Coprococcus_Ruminococcus.stat",sep=""),quote=F,col.names=NA)

CairoPDF(paste(outdir,"/","ratio.Coprococcus_Ruminococcus",".pdf",sep=""),width=1.875*3,height=0.278*3)
#png(file="ratio.Firmicutes_Bacteroidetes.png",width=187.5,height=27.8)
par(mar=c(0,0,0,0))

plot(0,0,ylim=c(0,0.7),xlim=c(0,1),type="n",axes=FALSE,xlab="",ylab="")
for (j in seq(0,0.2,length=600)){segments(j,0.2,j,0.45,col=hsv(alpha=0.7,s=0.5,v=0.85,h=1/12+j/0.8),lwd=1.5)}
for (j in seq(0.2,0.8,length=1000)){segments(j,0.2,j,0.45,col=hsv(alpha=0.7,s=0.5,v=0.85,h=1/3),lwd=1.5)}
for (j in seq(0.8,1,length=600)){segments(j,0.2,j,0.45,col=hsv(alpha=0.7,s=0.5,v=0.85,h=1/3+(j-0.8)/0.6),lwd=1.5)}

polygon(c(pos-1/60,pos-1/60,pos,pos+1/60,pos+1/60),c(0.55,0.45,0.3,0.45,0.55),col=hsv(alpha=0.9,s=0.26,v=0.45,h=0.46),border=0)
text(c(0.1,0.2,0.4,0.6,0.8,0.9),rep(0.08,6),labels =c("10%","20%","40%","60%","80%","90%"),adj=0.5,col=hsv(h=0,s=0,v=0),cex=1)
lines(c(0.13,0.17),c(0.1,0.1),lty=3,col=hsv(h=0,s=0,v=0.3))
lines(c(0.23,0.37),c(0.1,0.1),lty=3,col=hsv(h=0,s=0,v=0.3))
lines(c(0.43,0.57),c(0.1,0.1),lty=3,col=hsv(h=0,s=0,v=0.3))
lines(c(0.63,0.77),c(0.1,0.1),lty=3,col=hsv(h=0,s=0,v=0.3))
lines(c(0.83,0.87),c(0.1,0.1),lty=3,col=hsv(h=0,s=0,v=0.3))
dev.off()
