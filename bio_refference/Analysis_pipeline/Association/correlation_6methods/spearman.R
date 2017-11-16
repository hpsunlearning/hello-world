argv <- commandArgs(T)
if(length(argv) == 0){stop("intersect.R  [input] [input2] [prefix]
	input: meta profile
	input1: metabolites profile
	 prefix: prefix.")
    }

mebo <- read.table(argv[2],head = T,row.names=1)
meta <- read.table(argv[1],head = T,row.names=1)
na_c=apply(meta,1,function(x){mean(x==0)})
meta=meta[na_c<=0.8,]
meta=(meta+1e-16)*1e6
com_n=intersect(colnames(mebo),colnames(meta))
length(com_n)
mebo=mebo[,pmatch(com_n,colnames(mebo))]
meta=meta[,pmatch(com_n,colnames(meta))]
library(iterators)
library(doMC)
registerDoMC(7)
res= foreach(b=iter(mebo, by='row'), .combine=cbind) %dopar%{apply(meta,1,function(x){ abs(as.numeric(cor(as.numeric(b),as.numeric(x),method="spearman")))  })}
colnames(res)=rownames(mebo)
write.table(res,paste(argv[3],".spearman",sep=""),sep="\t",quote=F)
require(reshape2)
xx=melt(res)
write.table(xx[order(xx[,3],decreasing=T),],paste(argv[3],".spearman.melt",sep=""),sep="\t",quote=F,row.names=F,col.names=F)
