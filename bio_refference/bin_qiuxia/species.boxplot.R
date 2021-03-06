library(Cairo)
argv <- commandArgs(T)
in_f <- argv[1]
num <- argv[2]
num <- as.numeric(num)
d <- read.table(in_f)
#name = colnames(data)
#name = gsub("X","",name)
#max_d <- max(data)
#min_d <- min(data)
#data <- apply(data,2,function(x)(1+(1e6-1)/(max_d-min_d)*(x-min_d)))
#data <- log(data)
data<- data.frame()
for (i in 1:nrow(d)){for (j in 1:ncol(d)){data[i,j]=sum(d[i,(num+1):ncol(d)]<d[i,j])/(ncol(d)-(num+1))}}
colnames(data)=colnames(d)
rownames(data)= gsub("_"," ", rownames(d))
name  = colnames(data)
name = gsub("X","",name)

if(num == 1){
	CairoPDF(paste(name[1],".bac.pdf",sep=""),bg=rgb(red=238,green=236,blue=225,max = 255))
#	par(mar=c(4.2,12.2,2.1,2.1),bg=rgb(red=238,green=236,blue=225,max = 255))
	par(mar=c(4.2,8.1,2.1,2.1),bg=rgb(red=238,green=236,blue=225,max = 255))
	
	plot(0,0,ylim=c(0,nrow(data)+1),xlim=c(0,1),type="n",axes=FALSE,xlab="",ylab="")
	box()
	
	for (i in 1:nrow(data)){
		for (j in seq(0,0.2,length=200)){segments(j,i+0.2,j,i-0.2,col=hsv(alpha=0.9,v=0.76,h=j/0.6),lwd=1.5)}
		for (j in seq(0.2,0.8,length=1000)){segments(j,i+0.2,j,i-0.2,col=hsv(alpha=0.9,v=0.76,h=1/3),lwd=1.5)}
		for (j in seq(0.8,1,length=200)){segments(j,i+0.2,j,i-0.2,col=hsv(alpha=0.9,v=0.76,h=1/3-(j-0.8)/0.6),lwd=1.5)}
	}
	abline(v=0.1,lty=4)
	abline(v=0.9,lty=4)
	
	for (i in 1:nrow(data)){
		polygon(c(data[i,1]-1/60,data[i,1]-1/60,data[i,1],data[i,1]+1/60,data[i,1]+1/60),c(i+0.3,i+0.2,i,i+0.3,i+0.2),col=hsv(h=0,s=0,v=0.45),border=0)	}
	
	axis(side=1,at=0.95,lwd=0,lwd.ticks=0,tck=-0.03,labels="含量偏高",font=2,las=1)
	axis(side=1,at=0.05,lwd=0,lwd.ticks=0,tck=-0.03,labels="含量偏低",font=2,las=1)
	axis(side=1,at=0.5,lwd=0,lwd.ticks=0,tck=-0.03,labels="正常",font=2,las=1)
	axis(2,seq(1,nrow(data),1),labels=rownames(data),las=2,font=3)

	dev.off()

#	for (i in 1:nrow(data)){
#		pdf(paste(name[1],".",rownames(data)[i],".bac.pdf",sep=""),width = 480,height = 480)
#		x = density(data[i,])$x
#		y = density(data[i,])$y^2
#		plot(0,0,ylim=c(0,1),xlim=c(min(x),max(x)),type="n",axes=FALSE,xlab="",ylab="")
#		for (j in 1:length(x)){segments(x[j],0.2,x[j],0.8,
#			col=hsv(v=0.76,h=1/4,s=0.7,alpha=(y[j]-min(y))/(max(y)-min(y))),lwd=1.5)}
##		segments(data[i,1],0.2,data[i,1],0.8,lwd=2)
#		w = (max(x)-min(x))/30
#		polygon(c(data[i,1]-w,data[i,1]-w,data[i,1],data[i,1]+w,data[i,1]+w),
#			c(0.85,0.8,0.7,0.8,0.85),col=hsv(h=0,s=0,v=0.45),border=0)
#			
#		dev.off()
#	}
}
if(num!=1){
	for(i in 1:num){
		outName<-paste(name[i],".bac.pdf",sep="")
		CairoPDF(outName,bg=rgb(red=238,green=236,blue=225,max = 255))
#		par(mar=c(4.2,12.2,2.1,2.1),bg=rgb(red=238,green=236,blue=225,max = 255))
		par(mar=c(4.2,8.1,2.1,2.1),bg=rgb(red=238,green=236,blue=225,max = 255))
		plot(0,0,ylim=c(0,nrow(data)+1),xlim=c(0,1),type="n",axes=FALSE,xlab="",ylab="")
		box()

		for (j in 1:nrow(data)){
			for (k in seq(0,0.2,length=200)){segments(k,j-0.2,k,j+0.2,col=hsv(alpha=0.9,v=0.76,h=k/0.6),lwd=1.5)}
			for (k in seq(0.2,0.8,length=1000)){segments(k,j-0.2,k,j+0.2,col=hsv(alpha=0.9,v=0.76,h=1/3),lwd=1.5)}
			for (k in seq(0.8,1,length=200)){segments(k,j-0.2,k,j+0.2,col=hsv(alpha=0.9,v=0.76,h=1/3-(k-0.8)/0.6),lwd=1.5)}
		}
		abline(v=0.1,lty=4)
		abline(v=0.9,lty=4)

		for (j in 1:nrow(data)){
			polygon(c(data[j,i]-1/60,data[j,i]-1/60,data[j,i],data[j,i]+1/60,data[j,i]+1/60),c(j+0.3,j+0.2,j,j+0.2,j+0.3),col=hsv(h=0,s=0,v=0.45),border=0)	}

		axis(side=1,at=0.95,lwd=0,lwd.ticks=0,tck=-0.03,labels="含量偏高",font=2,las=1)
		axis(side=1,at=0.05,lwd=0,lwd.ticks=0,tck=-0.03,labels="含量偏低",font=2,las=1)
		axis(side=1,at=0.5,lwd=0,lwd.ticks=0,tck=-0.03,labels="正常",font=2,las=1)
		axis(2,seq(1,nrow(data),1),labels=rownames(data),las=2,font=3)
		
		dev.off()

#		for (j in 1:nrow(data)){
#			outName<-paste(name[i],".",rownames(data)[j],".bac.pdf",sep="")
#			pdf(outName,width =480,height=240)
##			jpeg(filename=outName,width = 480, height = 240)
#			x = density(data[j,])$x
#			y=density(data[j,])$y^2
#			plot(0,0,ylim=c(0,1),xlim=c(min(x),max(x)),type="n",axes=FALSE,xlab="",ylab="")
#			for (k in (i+1):length(x)){
#				segments(x[k],0.2,x[k],0.8,
#					col=hsv(v=0.76,h=1/4,s=0.7,alpha=(y[k]-min(y))/(max(y)-min(y))),lwd=1.5)}
##			segments(data[j,i],0.2,data[j,i],0.8,lwd=2)
#			w = (max(x)-min(x))/30
#			polygon(c(data[j,i]-w,data[j,i]-w,data[j,i],data[j,i]+w,data[j,i]+w),
#				c(0.85,0.8,0.7,0.8,0.85),col=hsv(h=0,s=0,v=0.45),border=0)
#			dev.off()
#		}
	}
}
