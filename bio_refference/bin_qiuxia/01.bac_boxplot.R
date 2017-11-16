library(Cairo)
argv <- commandArgs(T)
in_f <- argv[1]
num <- argv[2]
outdir <- argv[3]
num <- as.numeric(num)
d <- read.table(in_f,header=T,sep="\t",row.names=1)
#name = colnames(data)
#name = gsub("X","",name)
#max_d <- max(data)
#min_d <- min(data)
#data <- apply(data,2,function(x)(1+(1e6-1)/(max_d-min_d)*(x-min_d)))
#data <- log(data)
data<- data.frame()
for (i in 1:nrow(d)){for (j in 1:ncol(d)){data[i,j]=sum(d[i,(num+1):ncol(d)]<=d[i,j])/(ncol(d)-(num+1))}}
colnames(data)=colnames(d)
rownames(data)= gsub("_"," ", rownames(d))
name  = colnames(data)
name = gsub("X","",name)
zero <- data.frame()
for (i in 1:nrow(d)){zero[i,1]=(sum(d[i,(num+1):ncol(d)]==0)/(ncol(d)-(num+1)))}
rownames(zero)=rownames(data)

for (n in 1:num){
#	dir = paste(outdir,"/",name[n],sep="")
#	dir.create(dir)	
	for (i in 1:nrow(data)){
		outfile = gsub(" ","_",rownames(data)[i])
		outfile = paste(outdir,"/",name[n],".",outfile,".pdf",sep="")
 		CairoPDF(outfile,width=1.875*3,height=0.278*3)
       		par(mar=c(0,0,0,0))
		
		plot(0,0,ylim=c(0,0.7),xlim=c(0,1),type="n",axes=FALSE,xlab="",ylab="")
		for (j in seq(0,0.2,length=300)){segments(j,0.2,j,0.45,col=hsv(alpha=0.7,s=0.5,v=0.85,h=1/12+j/0.8),lwd=1.5)}
		for (j in seq(0.2,0.8,length=1000)){segments(j,0.2,j,0.45,col=hsv(alpha=0.7,s=0.5,v=0.85,h=1/3),lwd=1.5)}
		for (j in seq(0.8,1,length=600)){segments(j,0.2,j,0.45,col=hsv(alpha=0.7,s=0.5,v=0.85,h=1/3+(j-0.8)/0.6),lwd=1.5)}
       	 	rect(0,0.2,zero[i,1],0.45,col=hsv(h=0,s=0,v=0.7),border=hsv(h=0,s=0,v=0.7))
	        polygon(c(data[i,n]-1/60,data[i,n]-1/60,data[i,1],data[i,n]+1/60,data[i,n]+1/60),c(0.55,0.45,0.3,0.45,0.55),col=hsv(alpha=0.9,s=0.26,v=0.45,h=0.46),border=0) 	
		text(c(0.1,0.2,0.4,0.6,0.8,0.9),rep(0.08,6),labels =c("10%","20%","40%","60%","80%","90%"),adj=0.5,col=hsv(h=0,s=0,v=0),cex=1)
		lines(c(0.14,0.16),c(0.08,0.08),lty=3,col=hsv(h=0,s=0,v=0.4))
		lines(c(0.24,0.36),c(0.08,0.08),lty=3,col=hsv(h=0,s=0,v=0.4))
		lines(c(0.44,0.56),c(0.08,0.08),lty=3,col=hsv(h=0,s=0,v=0.4))
		lines(c(0.64,0.76),c(0.08,0.08),lty=3,col=hsv(h=0,s=0,v=0.4))
		lines(c(0.84,0.86),c(0.08,0.08),lty=3,col=hsv(h=0,s=0,v=0.4))
		dev.off()
	}
}
