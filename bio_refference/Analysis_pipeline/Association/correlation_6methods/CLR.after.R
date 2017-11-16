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
            new2=rbind(mebo,log(meta))
    cat ("orignal file ","\t",dim(new2),"\n")
    cat("meta: ",dim(meta),"\n")
     cat("mebo: ",dim(mebo),"\n")

        res<-read.csv(argv[3],head=F)
       cat (argv[3],"\t", dim(res),"\n")

 part=res[1:nrow(mebo),(nrow(mebo)+1):ncol(res)]
                                      dim(part)
    rownames(part)=rownames(mebo)
    colnames(part)=rownames(meta)
 require(reshape2)
    xx=melt(t(part))
                    xx[,1]=gsub("X","",as.character(xx[,1]))
            xx[,3]=abs(xx[,3])
    write.table(xx[order(xx[,3],decreasing=T),],paste(argv[4],".melt",sep=""),sep="\t",quote=F,row.names=F,col.names=F)
                                                                                                                                                          31


