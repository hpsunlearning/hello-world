argv <- commandArgs(T)
if(length(argv) == 0){stop("pcoa.r [input] [prefix]
input: profile.
prefix: prefix.")
}

###read.table distance matrix
dat <- read.table(argv[1],head = T)
dat <- as.dist(dat)
prefix <- as.vector(argv[2])
###### PCOA ######
library(ade4)
pcoa <- dudi.pco(t(dat),scannf = F,nf = 3)
attach(pcoa)
write.table(eig,paste(prefix,"_eig.txt",sep=""),quote = F,sep="\t")
write.table(c1,paste(prefix,"_c1.txt",sep=""),quote = F,sep="\t")
write.table(li,paste(prefix,"_li.txt",sep=""),quote = F,sep="\t")


