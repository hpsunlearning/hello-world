argv <- commandArgs(T)
    if(length(argv) == 0){stop("intersect.R  [input] [input2] [prefix]
            input: meta profile
            input1: metabolites profile
            prefix: prefix.")}

mebo <- read.table(argv[2],head = T,row.names=1)
meta <- read.table(argv[1])
na_c=apply(meta,1,function(x){mean(x==0)})
meta=meta[na_c<=0.8,]
meta=(meta+1e-16)*1e6
com_n=intersect(colnames(mebo),colnames(meta))
mebo=mebo[,pmatch(com_n,colnames(mebo))]
meta=meta[,pmatch(com_n,colnames(meta))]
write.table(meta,"mrmr.mlg.prof",sep="\t",quote=F)
mycor<-  function(meta,mebo){
                    for(i in 1:nrow(mebo)){
                    res=c()   
                    for(j in 1:nrow(meta)){
                    res[j]=round(cor.test(as.numeric(mebo[i,]),log(as.numeric(meta[j,])),method="kendall")$estimate,2)}
                    new2=data.frame(y=as.numeric(mebo[i,]),log(t(meta)))
                    names(res)=rownames(meta)
write.table(res,paste(argv[3],"_",rownames(mebo)[i],".mrmr.boruta.txt",sep=""),col.names=F,sep="\t",quote=F)
write.table(new2,paste(argv[3],".mrmr.boruta_table_",rownames(mebo)[i],".txt",sep=""),sep="\t",quote=F)
            }
        }
mycor(meta,mebo)
