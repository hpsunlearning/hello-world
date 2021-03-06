file <- commandArgs(T)
pdf("diversity.pdf",width=20,height=10,bg="#4682B4")
data<-read.table(file[1])
quan<-quantile(data[2:199,3],c(0.05,0.95))
par(bg="#AAAAAA",fg="#FFFFFF")
m<-density(data[2:199,3],from=quan[1],to=quan[2])
m1<-density(data[2:199,3])
m2<-data[2:199,3]
plot(m1,main="POSITION IN THE CROWD",ylab="NUMBER OF PEOPLE",mgp=c(2,1,0),xaxs="i",yaxs="i",cex=2,cex.main=2,cex.axis=1.5,cex.lab=1.5,xlab="",ylim=c(0,1),yaxt="n",col.axis="white",col.sub="white",col.main="white",col.lab="white")
for(i in seq(255,0,-1)){polygon(c(9,(i+459)/51,(i+459)/51,0),c(0,0,1,1),col=rgb(0.008,0.3,(1-i/255)*0.35+0.25,0.6),border=NA)}
polygon(c(min(m1$x),m1$x,max(m1$x)),c(0,m1$y,0),col="#9AC0CD",border="NA")##"colour the picture"
lines(c(m$x[1],m$x[1]),c(0,m$y[1]),col="#EE0000",lwd=4,lty=2)
lines(c(m$x[512],m$x[512]),c(0,m$y[512]),col="#EE0000",lwd=4,lty=2)
#abline(v=data[1,3]-0.4,col="#8B008B",lty=2,lwd=5)
abline(v=data[1,3],col="#8B008B",lty=2,lwd=5)
abline(h=0.2,col="#6E7B8B")
abline(h=0.4,col="#6E7B8B")
abline(h=0.6,col="#6E7B8B")
abline(h=0.8,col="#6E7B8B")
text(m$x[1]-0.03,m$y[1]+0.05,"5%",cex=2)
text(m$x[512]+0.1,m$y[512]+0.02,"95%",cex=2)
arrows(m$x[1]+0.45,m$y[1]/2,m$x[1],m$y[1]/2,col="#454545",cex=1.8)
arrows(m$x[512]-0.45,m$y[1]/2,m$x[512],m$y[1]/2,col="#454545",cex=1.8)
text((m$x[512]-m$x[1])/2+m$x[1],m$y[1]/2,paste("reference range(",round(m$x[1],2),"~",round(m$x[512],2),")",sep=""),cex=2,col="#454545")
#text(data[1,3]-1.1,0.85,paste(round(100*mean(data[1,3]-0.4>m2)),"%",sep=""),cex=2.5)
text(data[1,3]-1.1,0.85,paste(round(100*mean(data[1,3]>m2)),"%",sep=""),cex=2.5)
#text(data[1,3]-0.95,0.85,paste("The value of your microbiome diversity is ",round(data[1,3]-0.4,digits=2),"\nand is higher than ",round(100*mean((data[1,3]-0.4)>m2)),"% of the population",sep=""),adj=0,cex=2)
text(data[1,3]-0.95,0.85,paste("The value of your microbiome diversity is ",round(data[1,3],digits=2),"\nand is higher than ",round(100*mean((data[1,3])>m2)),"% of the population",sep=""),adj=0,cex=2)
