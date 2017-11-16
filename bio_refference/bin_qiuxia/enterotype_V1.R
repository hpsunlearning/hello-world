library(ade4)
library(Cairo)
argv <- commandArgs(T)
dat <- read.table(argv[1])
num <- as.numeric(argv[2])
new <- dat[,1:num,drop=F]
if(length(new) == nrow(dat)) {names(new) = rownames(dat)}
if(length(new) != nrow(dat)) {rownames(new) <- rownames(dat)}
new <- data.frame(new)

dat <- dat[,-c(1:num)]
dat <- as.matrix(dat)
dat <- dat[rowSums(dat)!=0,]
b <- sweep(dat,2,apply(dat,2,sum),"/")
tt <- kmeans(t(sqrt(b)),3)
tt <- as.numeric(tt$cluster)
data.a <- dat
####Standardization####
data1 <- sweep(data.a,2,apply(data.a,2,sum),"/")
data1 <- data1[rowSums(data1)!=0,]
data <- t(sqrt(data1))
IBD <- factor(tt)
pca <- prcomp(data)
p <- predict(pca,t(new))
rownames(p) = gsub("X","",rownames(p))

#e <- apply(p[,1:2],1,function(x){a=sqrt((x[1]-mean(pca$x[which(IBD==1),1]))^2+(x[2]-mean(pca$x[which(IBD==1),2]))^2)
#        b=sqrt((x[1]-mean(pca$x[which(IBD==2),1]))^2+(x[2]-mean(pca$x[which(IBD==2),2]))^2)
#        c=sqrt((x[1]-mean(pca$x[which(IBD==3),1]))^2+(x[2]-mean(pca$x[which(IBD==3),2]))^2)
#        d=c(a,b,c)})
#rownames(e) <-  rownames(head(pca$rotation[order(sqrt((pca$rotation[,1])^2+ (pca$rotation[,2])^2),decreasing=T),])[1:3,])
#ee <- apply(e,2,function(x){rownames(e)[which.min(x)]})
#write.table(ee,"enterotype.pro",quote=F,sep="\t",col.names = F)

#for(k in 1:nrow(p)){
#	pdf(paste(rownames(p)[k],".ent.pdf",sep=""))
#	s.class(pca$x[,1:2],IBD,cpoint = 1,col=2:8,cellipse = 1.2,axesell = T,addaxes = T,grid=F,pch=46,xlim=c(-1,1))
#	points(pca$x[,1],pca$x[,2],cex=0.7,pch=19,col=tt+1)
#	bb <- head(pca$rotation[order(sqrt((pca$rotation[,1])^2+ (pca$rotation[,2])^2),decreasing=T),])[1:4,]
#	cutoff <- (abs(min(pca$rotation[,1]))/abs(min(pca$rotation[,1])))/2
#	for(i in 1:dim(bb)[1]){
#       text(bb[i,1]*cutoff,bb[i,2]*cutoff,labels=rownames(bb)[i],font=2,cex=1.1)
#      }
#	points(p[k,1],p[k,2],cex=1.5,pch=19,col=1)
#	dev.off()
#}

for(k in 1:nrow(p)){
	CairoPDF(paste(rownames(p)[k],".ent.pdf",sep=""),bg=rgb(red=238,green=236,blue=225,max = 255))
	par(mar=c(4,4,4,4),bg=rgb(red=238,green=236,blue=225,max = 255)) 
	s.class(pca$x[,1:2],IBD,cellipse=1,axesell=T,clabel=F,cpoint=T,col=levels(IBD),addaxes=T,csta=0,grid=T)
#    for (i in seq(0,1,length.out=1000))
#	{
#		 s.class(pca$x[,1:2],IBD,cellipse=i,axesell=F,clabel=F,cpoint=F,grid=F,col=c(hsv(h=0.66,v=0.89,s=i/2),hsv(h=0.92,v=0.8,s=i/2),hsv(h=0.42,v=0.79,s=i/2)),addaxes=F,csta=0,add.plot=T)
#	}
	d1 <- (par("usr")[2]-par("usr")[1])/20
	d2 <- (par("usr")[4]-par("usr")[3])/10
	arrows(par("usr")[1]+d1,par("usr")[3]+d2,par("usr")[1]+d1,par("usr")[4]-d2,xpd=T,lwd=2,col=hsv(h=0.58,s=0.41,v=0.76))
	arrows(par("usr")[1]+d1,par("usr")[3]+d2,par("usr")[2]-d1,par("usr")[3]+d2,xpd=T,lwd=2,col=hsv(h=0.58,s=0.41,v=0.76))

	points(p[k,1],p[k,2],pch="★",cex=2,col="darkred",xpd=T)
	bb <- head(pca$rotation[order(sqrt((pca$rotation[,1])^2+ (pca$rotation[,2])^2),decreasing=T),])[1:3,]
	cutoff <- (abs(min(pca$rotation[,1]))/abs(min(pca$rotation[,1])))/3
        for(i in 1:dim(bb)[1]){
        text(bb[i,1]*cutoff,bb[i,2]*cutoff,labels=paste(rownames(bb)[i],"肠型",sep="-"),font=2,cex=1.1,col=hsv(h=0,v=0.1,s=0),xpd=T)
        }
#	e <-  rownames(head(pca$rotation[order(sqrt((pca$rotation[,1])^2+ (pca$rotation[,2])^2),decreasing=T),])[1:3,])
#	e <- paste(e,"肠型",sep="-")
#	text(mean(pca$x[IBD==1,1]), mean(pca$x[IBD==1,2])+d2*1.2,labels=e[1],xpd=T,col=hsv(h=0.66,v=0.89,s=1),xpd=T)
#	text(mean(pca$x[IBD==2,1]), mean(pca$x[IBD==2,2])+d2*1.2,labels=e[3],xpd=T,col=hsv(h=0.92,v=0.8,s=1),xpd=T)
#	text(mean(pca$x[IBD==3,1]), mean(pca$x[IBD==3,2])+d2*1.2,labels=e[2],xpd=T,col=hsv(h=0.42,v=0.79,s=1),xpd=T)
	dev.off()
}
