argv <- commandArgs(T)
if(length(argv) == 0){stop("plot.R  [input] [input2] [output.ful] [num] [prefix]
            input: meta profile
            input1: metabolites profile
            prefix: prefix.")}

meta <- read.table(argv[1],head = T,row.names=1)
mebo <- read.table(argv[2],head = T,row.names=1)
na_c=apply(meta,1,function(x){mean(x==0)})
meta=meta[na_c<=0.8,]
meta=(meta+1e-16)*1e6
com_n=intersect(colnames(mebo),colnames(meta))
mebo=mebo[,pmatch(com_n,colnames(mebo))]
meta=meta[,pmatch(com_n,colnames(meta))]
rank<-read.table(argv[3],head=T)
num<-as.numeric(argv[4])
type=ifelse(substr(colnames(meta),1,1)=="D",2,3)
pdf(argv[5])
count<-function(x){mean(x!=((0+1e-16)*1e6))}
for(i in 1:num){
         x<-as.numeric(meta[pmatch(rank$Id1[i+1],rownames(meta)),])
         occur=round(as.numeric(by(x,type,count )),2)
         print(occur)
         y<-as.numeric(mebo[pmatch(rank$Id2[i+1],rownames(mebo)),])
         occur1=round(as.numeric(by(y,type,count )),2)
         print(occur1)
         plot(log(x+1e-10),y,xlab=paste(rank$V1[i+1]," (case= ", occur[1], " , con= ", occur[2], " )",sep=" "),ylab=paste(rank$V2[i+1] ," (case= ", occur1[1], " , con= ", occur1[2], " )",sep=" "),pch=19,col=type)
}   
dev.off()
