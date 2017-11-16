argv <- commandArgs(T)
if(length(argv) == 0){stop("Rscript Enterotypes.R [input] [distance][cluster_method] [Best_cluster_number][Contribution_larger_Genus_number] [Species_composition.fig.size] [Species_composition.Genus.numbers]
input: profile.
distance: eg : JSD Hellinger Bray Euclidean.
cluster_method: hclust pam.
Best_cluster_number: eg: 2 3 4 ...
Contribution_larger_Genus_number: eg: 3 4 5 ...
Species_composition.fig.size : 10.1
Species_composition.Genus.numbers: 30
")
}
library(fpc)
library(ade4)
# G: matrix of gene abundances

####JSD distance function####
kld <- function(x,y){
	x <- x+0.000000001
	y <- y+0.000000001
	kld <- sum(x*log(x/y))
	kld
}
jsd <- function(x){
	ds <- dim(x)
	jsd <- matrix(0,ds[2],ds[2])
	for(i in 1:ds[2]){
		for(j in 1:ds[2]){
			m <- (x[,i]+x[,j])/2
			jsd[i,j] <- kld(x[,i],m)/2+kld(x[,j],m)/2
			diag(jsd) <- 0
		}
	}
		d <- sqrt(jsd)
		d
}
####Hellinger distance function####
hld <- function(x){
        x <- sweep(x,2,apply(x,2,sum),"/")
        x <- sqrt(x)
        dis <- dist(t(x))
        dis
}

dat <- read.table(argv[1],head=T)
dat <- as.matrix(dat)
distance <- as.vector(argv[2])
cluster_method <- as.vector(argv[3])
Best_cluster_number <- as.numeric(argv[4])
ds <- dim(dat)
if(Best_cluster_number > ds[2]){
	cat("error\n")
}
Contribution_larger_Genus_number <- as.numeric(argv[5])
Species_composition.fig.size <- as.numeric(argv[6])
Species_composition.Genus.numbers <- as.numeric(argv[7])
dat <- dat[rowSums(dat)!=0,]
b <- sweep(dat,2,apply(dat,2,sum),"/")
if(distance=="JSD"){
        dist <- jsd(b)
}
if(distance=="Hellinger"){
        dist <- hld(b)
}
if(distance=="Bray"){
        dist <- vegdist(t(b),method="bray")
}
if(distance=="Euclidean"){
        dist <- vegdist(t(b),emthod="euclidean")
}
#####################
if(cluster_method=="hclust"){
	hc <- hclust(as.dist(dist),"ward")
	tt <- cutree(hc,Best_cluster_number)
}
if(cluster_method=="pam"){
	tt <- pam(dist,Best_cluster_number,diss=TRUE,cluster.only=TRUE)
}
	names(tt) <- colnames(dat)
	tt <- as.data.frame(tt)
	rownames(tt) = gsub("X","",rownames(tt))
	write.table(tt,paste(distance,"_",cluster_method,"_",Best_cluster_number,"_Enterotypes.txt",sep=""),sep="\t",quote=F,col.names="Enterotypes")
tt <- tt[ ,1]
data.a <- dat
####Standardization####
data1 <- sweep(data.a,2,apply(data.a,2,sum),"/")
data1 <- data1[rowSums(data1)!=0,]
data <- t(sqrt(data1))
IBD <- factor(tt)
data.dudi <- dudi.pca(data,center = TRUE,scale=F,scan=F,nf=2)
eig <- (data.dudi$eig/sum(data.dudi$eig))
write.table(eig,"eig.contribution.txt",sep="\t",quote=F,row.names=paste("PC",1:length(eig),sep=""),col.names=F)
pdf(paste(distance,"_",cluster_method,"_",Best_cluster_number,"_Enterotype.pdf",sep=""))
s.class(data.dudi$li,IBD,cpoint = 1,col=2:8,
       cellipse = 1.2,axesell = T,addaxes = T,grid=F,pch=46)
bb <- head(data.dudi$c1[order(sqrt((data.dudi$c1[,1])^2+ (data.dudi$c1[,2])^2),decreasing=T),])[1:Contribution_larger_Genus_number,]

cutoff <- (abs(min(data.dudi$c1[,1]))/abs(min(data.dudi$li[,1])))/10
for(i in 1:dim(bb)[1]){
	text(bb[i,1]*cutoff,bb[i,2]*cutoff,labels=rownames(bb)[i],font=2,cex=1.1)
	}
dev.off()
data <- dat[pmatch(rownames(bb),rownames(dat)),]

for(i in 1:nrow(data)){
	pdf(paste(distance,"_",cluster_method,"_",Best_cluster_number,"_",rownames(data)[i],".pdf",sep=""))
	boxplot(as.numeric(data[i,])~factor(tt),col=2:8,main=rownames(data)[i],xlab="Enterotypes",ylab="Abundance")
	dev.off()
}
me <-  apply(dat,1,median)
r <- order(me,decreasing = T)
datt <- log(dat[r,]+0.0000000001)
datt <- datt[1:Species_composition.Genus.numbers,]
pdf(paste("Species_composition.top.",Species_composition.Genus.numbers,".pdf",sep=""))
par(mar=c(5.1,Species_composition.fig.size,4.1,4.1))
boxplot(t(datt[Species_composition.Genus.numbers:1,]),horizontal=T,las=2,cex=0.5,xlab="Log Abundance")
dev.off()

