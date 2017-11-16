argv <- commandArgs(T)
    if(length(argv) == 0){stop("intersect.R  [input] [input2] [prefix]
            input: meta profile
            input1: metabolites profile
            prefix: prefix.")
    }

mebo <- read.table(argv[2],head = T,row.names=1)
meta <- read.table(argv[1])
na_c=apply(meta,1,function(x){mean(x==0)})  
meta=meta[na_c<=0.8,]
meta=(meta+1e-16)*1e6
com_n=intersect(colnames(mebo),colnames(meta))
mebo=mebo[,pmatch(com_n,colnames(mebo))]
meta=meta[,pmatch(com_n,colnames(meta))]
n=nrow(mebo)
id=c(1,nrow(mebo))
sink(paste(argv[3],".sh",sep="") )
num=nrow(mebo)
new2=rbind(mebo,log(meta))
write.table(new2, paste(argv[3],".mine.process.csv",sep=""), sep=",",col.names =F,row.names=T,quote=F)
cat("java -jar /home/luoxiao/bin/MINE.jar  ", paste(argv[3],".mine.csv",sep=""), "  -pairsBetween ", num,"\n")
sink()
