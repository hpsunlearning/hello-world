argv <- commandArgs(T)
if(length(argv) == 0){stop("Best.classification.R [input][distance] [cluster_method]
input: profile.
distance: eg : JSD Hellinger Bray Euclidean.
cluster_method: hclust pam.")
}
library(vegan)
library(fpc) 
library(cluster) 
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

#####################
####Hellinger distance function####
hld <- function(x){
	x <- sweep(x,2,apply(x,2,sum),"/")
	x <- sqrt(x)
	dis <- dist(t(x))
	dis
}

dat <- read.table(argv[1])
ds <- dim(dat)
dat <- dat[rowSums(dat)!=0,]
b <- sweep(dat,2,apply(dat,2,sum),"/")
distance <- as.vector(argv[2])
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
####JSD distance####
cluster_method <- as.vector(argv[3])
dM <- dist
hc = hclust(as.dist(dist),method="ward")

if(ds[2]<=20){
index <- matrix(0,9,(ds[2]-1))
}else{
index <- matrix(0,9,20)
}
for(i in 2:ncol(index)){
	if(cluster_method=="hclust"){
	coff1 <- cluster.stats(d=dM, clustering=cutree(hc,i), silhouette=T)
	}
	if(cluster_method == "pam"){
	coff1 <- cluster.stats(d=dM, clustering=pam(dM,i,diss=TRUE,cluster.only=TRUE), silhouette=T)
	}
	index[2,i] = coff1$average.between     ###average distance between clusters.
	index[3,i] = coff1$average.within      ###average distance within clusters.
	index[4,i] = coff1$n.within            ###number of distances within clusters.
	index[5,i] = coff1$within.cluster.ss   ###a generalisation of the within clusters sum of squares.
	index[6,i] = coff1$avg.silwidth        ###average silhouette width
	index[7,i] = coff1$dunn                ###minimum separation / maximum diameter.
	index[8,i] = coff1$wb.ratio            ###average.within/average.between.
	index[9,i] = coff1$ch                  ###Calinski and Harabasz index.
}
index <- index[-1,]
index[,ncol(index)] = apply(index,1,function(x){which.max(x)})
rownames(index) = c("average.between","average.within","n.within","within.cluster.ss",
				"avg.silwidth","dunn","wb.ratio","ch")
colnames(index) = c(1:((ncol(index)-1)),"Best.classification.number")
write.table(index,paste(distance,"_",cluster_method,"_Index.txt",sep=""),quote=F,sep="\t")
pdf(paste(distance,"_",cluster_method,"_best_classification.plot.pdf",sep=""))
par(mfcol=c(3,3))
num <- 1:(ncol(index)-1)
for(i in 1:8){
	plot(num,index[i,1:(ncol(index)-1)],type="h",xlab="Cluster.numbers",ylab=rownames(index)[i])
	abline(v=index[i,ncol(index)],lwd=3,col="pink")
	}
dev.off()



