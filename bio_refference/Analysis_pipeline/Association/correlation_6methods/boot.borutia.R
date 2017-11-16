argv <- commandArgs(T)
if(length(argv) == 0){stop("intersect.R  [input] [input2] [prefix]
input: meta profile
input1: metabolites profile
prefix: prefix.")
}
  
### part1   read file
dat<-read.table(argv[1])
#colnames(dat)=gsub("X","",colnames(dat))
  #    rank1<-read.table(argv[2])

prefix<-argv[2]
library("Boruta")
library("multicore")
library(doMC)
registerDoMC(5)

stable_selection<-function(new4,nbootstrap=10){

r <- foreach(icount(nbootstrap), .combine=cbind) %dopar% {
                    res=rep(0,ncol(new4)-1)
                    Boruta.Ozone2 <- Boruta(y ~ ., data = new4, doTrace = 0, ntree = 500,pValue = 0.01)
                    n1=getSelectedAttributes(Boruta.Ozone2, withTentative = F)
	            n2=attStats(Boruta.Ozone2)
                    colid=   pmatch(n1,colnames(new4))-1
                    res[colid]=n2[pmatch(n1,rownames(n2)),2]
                    res=as.matrix(res,ncol=1)
                }
            r=t(r)
            colnames(r)=colnames(new4)[-1]
            r
}

set.seed(0)
score1=stable_selection(dat,nbootstrap=10)
mean1=apply(score1,2,function(x){mean(x!=0)})
mean2=apply(score1,2,function(x){mean(x)})
if(any(mean1>=0.8)){
     	name1=(colnames(dat)[-1])[mean1>=0.8]
     	n2=which(mean1>=0.8)+1
        write.table(cbind(prefix,name1),paste(prefix,"-final.txt",sep=""),quote=F,row.names=F,col.names=F)
}
write.table(cbind(prefix,mean2),paste(prefix,"-zscore.txt",sep=""),quote=F)
	
