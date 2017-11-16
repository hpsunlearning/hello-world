file <- commandArgs(T)
da <- read.table(file[1],head=T,row.names=1,sep="\t")
list <- read.table(file[2],head=T,row.names=1,sep="\t")
index <- pmatch(rownames(list),rownames(da))
da <- da[index,]
ref <- da[,-1]
ref <- ref[rownames(list),]
Reference <- sort(apply(ref,1,mean),decreasing=T)
print(Reference)
sample <- da[names(Reference),1]
list <- list[names(Reference),]
prop <- prop.table(cbind(sample,Reference,list[,1],list[,2],list[,3]),2)      
colnames(prop) <- c("sample","Reference",colnames(list))
print(prop)
pdf("KO.pdf")
par(mar=c(3,2,2,11))
col <- NULL
for(i in 1:nrow(list)){
    tmp <- hsv(h=i/nrow(list),s=1-i/nrow(list)*0.8,v=0.85)
    col <- c(col,tmp)
}
barplot(prop,col=col,axes=F,main="KO level")
legend(par()$usr[2]*1.1,par()$usr[4],rownames(prop),fill=col,xpd=T)
dev.off()
