library("Cairo")
argv <- commandArgs(T)
pro <- read.table(argv[1],header=T,sep="\t",row.names=1)
num <- as.numeric(argv[2])
list <- read.table(argv[3],sep="\t")
outdir <- argv[4]
list <- gsub("_"," ",list[,1])
bac_index <- pmatch(list,rownames(pro))
bac_index <- bac_index[!is.na(bac_index)]
d <- pro[bac_index,]
ref <- d[,-(1:num)]

case <- d[,substr(colnames(ref),1,2)=="DB"]
control <- d[,substr(colnames(ref),1,2)!="DB"]
ref <- cbind(case,control)

stat<-data.frame()
for (i in 1:nrow(case)){stat[i,1]=(sum(case[i,]==0)/ncol(case))}
for (j in 1:num){ 
	for (i in 1:nrow(case)){stat[i,j+1]=(sum(case[i,]<=d[i,j])/ncol(case))}
}
for (i in 1:nrow(control)){stat[i,2+num]=(sum(control[i,]==0)/ncol(control))}
for (j in 1:num){
	for (i in 1:nrow(control)){stat[i,j+2+num]=(sum(control[i,]<=d[i,j])/ncol(control))}
}
rownames(stat) <- rownames(ref)
#colnames(stat) <- c(c("zero in case",paste(colnames(d)[1:num]," in case"),"zero in control",paste(colnames(d)[1:num]," in control"))
#stat <- stat[order(stat[,3]),]
out <- data.frame()
out<-cbind(d[,1:num],t(apply(case,1,function(x){quantile(x,probs=c(0.1,0.9))})),t(apply(control,1,function(x){quantile(x,probs=c(0.1,0.9))})))
rownames(out) <- rownames(case)
colnames(out) <- c(colnames(d)[1:num],"10% in case","90% in case","10% in control","90% in control")
write.table(out,paste(outdir,"/","Obese_speciesmarker.stat",sep=""),quote=F,col.names = NA,sep="\t")

for (i in 1:num){
        outName<-paste(outdir,"/",colnames(d)[i],".Obese.speciesmarker.pdf",sep="")
        CairoPDF(outName,width=8,height=6)
        par(mar=c(4.2,15.1,2.1,2.1))
        plot(0,0,ylim=c(0.5,nrow(d)+0.5),xlim=c(0,1),type="n",axes=FALSE,xlab="",ylab="")
        box()
        for (j in 1:nrow(stat)){
                rect(0,j+0.05,1,j+0.3,col=hsv(h=0,s=0.7,v=0.7,alpha=0.5),border=hsv(h=0,s=0,v=0.7))
                rect(0,j-0.3,1,j-0.05,col=hsv(h=2/3,s=0.7,v=0.7,alpha=0.5),border=hsv(h=0,s=0,v=0.7))    

		rect(0,j+0.05,stat[j,1],j+0.3,col=hsv(h=0,s=0,v=0.7),border=hsv(h=0,s=0,v=0.7))
		rect(0,j-0.3,stat[j,2+num],j-0.05,col=hsv(h=0,s=0,v=0.7),border=hsv(h=0,s=0,v=0.7))
	        incase <- stat[j,1+i]
                polygon(c(incase,incase-1/60,incase,incase+1/60),c(j+0.3,j+0.175,j+0.05,j+0.175),col=hsv(alpha=0.9,s=0.26,v=0.45,h=0.46),border=0)
		incontrol <- stat[j,2+i+num]
		polygon(c(incontrol,incontrol-1/60,incontrol,incontrol+1/60),c(j-0.05,j-0.175,j-0.3,j-0.175),col=hsv(alpha=0.9,s=0.4,v=0.6,h=0.85),border=0)
        }
        axis(2,seq(1,nrow(ref),1),labels=rownames(ref),las=2)
#	abline(h=4.5,col=hsv(alpha=0.8,s=0,v=0))#跟9.9M比对时用该条命令
		abline(h=3.5,col=hsv(alpha=0.8,s=0,v=0))#为暂时跟4.3M比对结果所用
        abline(v=seq(0.2,0.8,0.2),lty=4,col=hsv(v=0.5,alpha=0.8))
	mtext(c("20%","40%","60%","80%"),side=1,at=seq(0.2,0.8,0.2),line=0.4)
        dev.off()       
}
