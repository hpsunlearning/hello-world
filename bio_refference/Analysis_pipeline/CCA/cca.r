argv <- commandArgs(T)
if(length(argv) == 0){stop("cca.r [input] [phenotype] [na.cut.off]
input: profile.
phenotypes: phe.
na.cut.off: NA cutoff numbers.
")
 }

library(vegan)
motu<-t(read.table(argv[1]))
phe<-read.table(argv[2])
num = as.numeric(argv[3])
phe<-phe[pmatch(rownames(motu),rownames(phe)),]

###pick phe accord to NA numbers
NA.n=data.frame(apply(phe,2,function(x){sum(is.na(x))}))
phe_pick<-na.omit(phe[,which(NA.n[,1]<num)])
for (i in 1:ncol(phe)){phe_pick[,i]=as.numeric(phe_pick[,i])}
motu_pick<-motu[pmatch(rownames(phe_pick),rownames(motu)),]
cca_out<-cca(motu_pick,phe_pick)
CCA.plot.plot = cca_out$CCA$v
CCA.plot.biplot = cca_out$CCA$biplot
CCA.eig = cca_out$CCA$eig

###write.table
write.table(CCA.plot.plot,"CCA.plot.txt",quote=F,sep="\t")
write.table(CCA.plot.biplot,"CCA.biplot.txt",quote=F,sep="\t")
write.table(CCA.eig,"CCA.eig.txt",quote=F,sep="\t",col.names=F)

