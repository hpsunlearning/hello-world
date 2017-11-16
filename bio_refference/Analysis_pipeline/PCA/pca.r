argv <- commandArgs(T)
if(length(argv) == 0){stop("pca.r [input] [prefix]
input: profile.
prefix: prefix.")
}

dat <- read.table(argv[1],head = T)
dat <- as.matrix(dat)
rs <- rowSums(dat)
dat <- dat[rs!=0,]
cn <- colnames(dat)
cn <- gsub("X","",cn)
colnames(dat) <- cn
dim(dat)
prefix <- as.vector(argv[2])
###### PCA ######
library(ade4)
dat <- sweep(dat,2,apply(dat,2,sum),"/")
dat <- sqrt(dat)
#pca <- dudi.pca(t(dat),scale = F, scannf = F,nf = dim(dat)[2] - 1)
pca <- dudi.pca(t(dat),scale = F, scannf = F,nf = ncol(dat))
attach(pca)
write.table(eig,paste(prefix,"_eig.txt",sep=""),quote = F,sep="\t")
write.table(c1,paste(prefix,"_c1.txt",sep=""),quote = F,sep="\t")
write.table(li,paste(prefix,"_li.txt",sep=""),quote = F,sep="\t")

