#!~qiuhongwen/work/opt/R-3.1.2/bin/R
#library(Cairo)
argv <- commandArgs(T)
data <- read.table(argv[1],sep="\t",row.names=1,header=T)
ant_name <- read.table(argv[2],sep="\t",row.names=1,header=F)
num <- as.numeric(argv[3])

outdir <- argv[5]

stat_pro <- function(profile){
	stat <- data.frame()
	for (i in 1:nrow(profile)){stat[i,1]=(sum(profile[i,-(1:num)]==0)/(ncol(profile)-num))}
	for (j in 1:num){ 
		for (i in 1:nrow(profile)){stat[i,j+1]=(sum(profile[i,-(1:num)]<=profile[i,j])/(ncol(profile)-num))}
	}
	rownames(stat) <- rownames(profile)
	colnames(stat) <- c("zero",colnames(profile)[1:num])
	stat_out <- cbind(profile[,1:num],stat[,1],t(apply(profile[,-(1:num)],1,function(x){quantile(x,probs=c(0.1,0.9))})))
	rownames(stat_out) <- rownames(profile)
	colnames(stat_out) <- c(colnames(profile)[1:num],"zero","10%","90%")
	write.table(stat_out,paste(outdir,"/","Antibiotic",".stat",sep=""),quote=F,col.names=NA,sep="\t")
	return(stat)
}

draw <- function(stat,out){
      outName<-paste(outdir,"/",out,".pdf",sep="")
      cairo_pdf(outName,width=8,height=nrow(stat)*0.4+0.8,family="SimSun")
#      CairoPDF(outName,width=8,height=nrow(stat)*0.4+0.8,family="SimSun")
	  par(mar=c(4.2,16.1,2.1,2.1))
      plot(0,0,ylim=c(0.5,nrow(stat)+0.5),xlim=c(0,1),type="n",axes=FALSE,xlab="",ylab="")
      box()
      for (j in 1:nrow(stat)){
      	for (k in seq(0,0.8,length=1500)){segments(k,j+0.2,k,j-0.2,col=hsv(alpha=0.7,s=0.5,v=0.85,h=1/3),lwd=1.5)}
        for (k in seq(0.8,1,length=600)){segments(k,j+0.2,k,j-0.2,col=hsv(alpha=0.7,s=0.5,v=0.85,h=1/3+(k-0.8)/0.6),lwd=1.5)}
        rect(0,j-0.2,stat[j,1],j+0.2,col=hsv(h=0,s=0,v=0.7),border=hsv(h=0,s=0,v=0.7))
        polygon(c(stat[j,2],stat[j,2]-1/60,stat[j,2],stat[j,2]+1/60),c(j+0.2,j,j-0.2,j),col=hsv(alpha=0.9,s=0.4,v=0.6,h=0.85),border=0)
	name <- paste(ant_name[pmatch(rownames(stat),rownames(ant_name)),1],"(",rownames(stat),")",sep="")
	mtext(name,side=2,at =seq(1,nrow(stat),1),las=2,line=1.5)
	abline(v=seq(0.2,0.8,0.2),lty=4,col=hsv(v=0.5,alpha=0.8))
	mtext(c("20%","40%","60%","80%"),side=1,at =seq(0.2,0.8,0.2),line=0.5)
        }
      dev.off()
}

data <- data[rowSums(data)!=0,]
name <- colnames(data)[1:num]
name <- gsub("X","",name)
#normal <- apply(data[,-(1:num)],1,median)
#normal_top <-names(normal[order(normal,decreasing=T)])[1:10]
normal <- read.table(argv[4],sep="\t",header=F)
normal_top <- as.character(normal[,1])
stat <- stat_pro(data)

for (i in 1:num){
#	top_list <-unique(c(rownames(stat)[ stat[,i+1]>=0.9 & stat[,1]!=stat[,i+1] ],normal_top))
	abnormal <- setdiff(rownames(stat)[ stat[,i+1]>=0.9 & stat[,1]!=stat[,i+1] ],normal_top)
	top_list <- union(abnormal,normal_top)
	sample_stat <- stat[pmatch(top_list,rownames(stat)),c(1,i+1)]
	outfile <- paste("Anti",colnames(stat)[i+1],sep=".")
	draw(sample_stat,outfile)
}
