library(ade4)
library(Cairo)
argv <- commandArgs(T)
dat <- read.table(argv[1])
#num <- as.numeric(argv[2])
outdir <- argv[2]
#new <- dat[,1:num,drop=F]
#if(length(new) == nrow(dat)) {names(new) = rownames(dat)}
#if(length(new) != nrow(dat)) {rownames(new) <- rownames(dat)}
#new <- data.frame(new)

#dat <- dat[,-c(1:num)]
dat <- as.matrix(dat)
dat <- dat[rowSums(dat)!=0,]
b <- sweep(dat,2,apply(dat,2,sum),"/")
tt <- kmeans(t(sqrt(b)),3)
tt <- as.numeric(tt$cluster)
##data.a <- dat[,-c(1:num)]
data.a <- dat
####Standardization####
data1 <- sweep(data.a,2,apply(data.a,2,sum),"/")
data1 <- data1[rowSums(data1)!=0,]
data <- t(sqrt(data1))
##IBD <- factor(tt[-c(1:num)])
IBD <- factor(tt)
pca <- prcomp(data)
#p <- predict(pca,t(new))
#rownames(p) = gsub("X","",rownames(p))

#for(k in 1:nrow(p)){
#	CairoPDF(paste(outdir,"/",rownames(p)[k],".ent.pdf",sep=""),bg=rgb(red=238,green=236,blue=225,max = 255))
#	par(mar=c(4,4,4,4),bg=rgb(red=238,green=236,blue=225,max = 255)) 
#	s.class(pca$x[,1:2],IBD,cellipse=1,axesell=F,clabel=F,cpoint=F,col=levels(IBD),addaxes=F,csta=0,grid=F)
#	 for (i in seq(0,1,length.out=1000))
#	{
#		 s.class(pca$x[,1:2],IBD,cellipse=i,axesell=F,clabel=F,cpoint=F,grid=F,col=c(hsv(h=0.66,v=0.89,s=i/2),hsv(h=0.92,v=0.8,s=i/2),hsv(h=0.42,v=0.79,s=i/2)),addaxes=F,csta=0,add.plot=T)
#	}
#	d1 <- (par("usr")[2]-par("usr")[1])/20
#	d2 <- (par("usr")[4]-par("usr")[3])/10
#	arrows(par("usr")[1]+d1,par("usr")[3]+d2,par("usr")[1]+d1,par("usr")[4]-d2,xpd=T,lwd=2,col=hsv(h=0.58,s=0.41,v=0.76))
#	arrows(par("usr")[1]+d1,par("usr")[3]+d2,par("usr")[2]-d1,par("usr")[3]+d2,xpd=T,lwd=2,col=hsv(h=0.58,s=0.41,v=0.76))
#
#	points(p[k,1],p[k,2],pch=19,cex=2,col="darkred",xpd=T)
	bb <- head(pca$rotation[order(sqrt((pca$rotation[,1])^2+ (pca$rotation[,2])^2),decreasing=T),])[1:3,]
#	cutoff <- (abs(min(pca$rotation[,1]))/abs(min(pca$rotation[,1])))/3
#        for(i in 1:dim(bb)[1]){
#        text(bb[i,1]*cutoff,bb[i,2]*cutoff,labels=paste(rownames(bb)[i],"",sep="-"),font=2,cex=1.1,col=hsv(h=0,v=0.1,s=0),xpd=T)
#        }	
#	dev.off()
#}

bt<-apply(bb[,1:2],1,function(x){sqrt(x[1]^2+x[2]^2)})
at<-t(dat[names(bt),])
ct<-at*rep(bt,each=nrow(at))
t1<-apply(ct[IBD==1,],2,function(x){mean(x)})
t2<-apply(ct[IBD==2,],2,function(x){mean(x)})
t3<-apply(ct[IBD==3,],2,function(x){mean(x)})
ty<-data.frame(type1=t1,type2=t2,type3=t3)
typename<-apply(ty,1,function(x)which.max(x))
sampletype<-sapply( factor(tt),function(x){names(typename)[typename==x]})
out<-data.frame(row.names=colnames(b),type=sampletype)

#cluster<-function(sam,refmean){
#        distance<-apply(refmean,1,function(x){(sam[1]-x[1])^2+(sam[2]-x[2])^2})
#        return (names(which.min(distance)))
#}
#
#refmean<-matrix(c(mean(pca$x[IBD==1,1]),mean(pca$x[IBD==1,2]),mean(pca$x[IBD==2,1]),mean(pca$x[IBD==2,2]),mean(pca$x[IBD==3,1]),mean(pca$x[IBD==3,2])),3,2)
#refmean<-as.data.frame(refmean)
#rownames(refmean)<-names(sort(typename))
#type<-apply(p[1:num,1:2,drop=F],1,function(x){cluster(x,refmean)})
#out<-rbind(as.data.frame(type),out)
##cood<-rbind(p[1:num,1:3,drop=F],predict(pca,t(data.a))[,1:3])
cood<-predict(pca,t(data.a))[,1:3]
out<-cbind(out,cood)
outfile <- paste(outdir,"/","enterotype.out",sep="")
write.table(out,outfile,quote=F,row.names=T,col.names=T)


######################################################
