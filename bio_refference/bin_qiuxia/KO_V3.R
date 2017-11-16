file <- commandArgs(T)
da <- read.table(file[1],head=T,row.names=1,sep="\t")
ref <- da[,-1]
Reference <- sort(apply(ref,1,mean),decreasing=T)[1:30]
media <- sort(apply(ref,1,median),decreasing=T)[1:30]
Sample <- da[names(Reference),1]
names(Sample) <- names(Reference)
prop <- prop.table(cbind(Sample,Reference),2)       
pdf("ko.pdf")
par(mar=c(3,2,2,11))
barplot(prop,col=rainbow(nrow(prop)),axes=F,main="KO level")
legend(par()$usr[2]*1.1,par()$usr[4],rownames(prop),fill=rainbow(nrow(prop)),xpd=T)
dev.off()
