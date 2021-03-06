library("Cairo")
argv <- commandArgs(T)
pro <- read.table(argv[1],header=T,sep="\t",row.names=1)
num <- as.numeric(argv[2])
list <- read.table(argv[3],sep="\t")
list <- rev(list[,1])

bac_index <- pmatch(list,rownames(pro))
bac_index <- bac_index[!is.na(bac_index)]
d <- pro[bac_index,]

ref <- d[,-(1:num)]
colnames(ref) <- gsub("X","",colnames(ref))
li <-read.table(argv[4],head=F,sep="\t",row.names=1)
rownames(li)<-gsub("-",".",rownames(li))
case_name <- rownames(li)[li[,1]==0]
control_name <- rownames(li)[li[,1]==1]
case_index <- pmatch(case_name,colnames(ref))
control_index <- pmatch(control_name,colnames(ref))
case_index<- case_index[!is.na(case_index)]
control_index <- control_index[!is.na(control_index)]
case <- ref[,case_index]
control <- ref[,control_index]
outdir <- argv[5]

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
write.table(out,paste(outdir,"/","CC_speciesmarker.stat",sep=""),quote=F,col.names = NA,sep="\t")

for (i in 1:num){
        outName<-paste(outdir,"/",colnames(d)[i],".CC.speciesmarker.pdf",sep="")
        CairoPDF(outName,width=8,height=6)
        par(mar=c(4.2,15.1,2.1,2.1))
        plot(0,0,ylim=c(0.5,nrow(d)+0.5),xlim=c(0,1),type="n",axes=FALSE,xlab="",ylab="")
        box()
        for (j in 1:nrow(stat)){
        #       for (k in seq(stat[j,2],stat[j,3],length=1000)){segments(k,j+0.2,k,j-0.2,col=hsv(alpha=0.9,v=0.76,h=k),lwd=1.5)}
        #       for (k in seq(stat[j,4],stat[j,5],length=1000)){segments(k,j+0.2,k,j-0.2,col=hsv(alpha=0.9,v=0.76,h=k),lwd=1.5)}
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
#	abline(h=4.5,col=hsv(alpha=0.8,s=0,v=0))
        abline(v=seq(0.2,0.8,0.2),lty=4,col=hsv(v=0.5,alpha=0.8))
	mtext(c("20%","40%","60%","80%"),side=1,at=seq(0.2,0.8,0.2),line=0.4)
        dev.off()       
}
