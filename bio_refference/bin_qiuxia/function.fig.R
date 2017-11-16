argv <- commandArgs(T)
dat <- read.table(argv[1],head=T,sep="\t",row.names=1)
names <- rownames(dat)
Lipopolysaccharide <- colSums(dat[c(4,5),])
dat <- rbind(dat[-c(4,5),],Lipopolysaccharide)
rownames(dat)[nrow(dat)] = "Lipopolysaccharide"
num <- as.numeric(argv[2])
con <- dat[,(num+1):ncol(dat)]
test <- dat[,1:num,drop=F]
colnames(test) <- gsub("X","",colnames(test))
fig.dat <- t(apply(con,1,function(x){as.numeric(x);quantile(x,seq(0,1,0.001),na.rm=T)}))

a <-data.frame();
for (k in 1:ncol(test)){for (i in 1:7){a[i,k] <- names(which.min(abs(test[i,k]-fig.dat[i,])))}}
colnames(a) <- colnames(test)
rownames(a) <- c("Energy Metabolism","Glycan Biosynthesis and Metabolism",
		"Metabolism of Cofactors and Vitamins","Oxidative_stress_resistance",
		"H2S","SCFA","Lipopolysaccharide")

#write.table(a,"function.pro",quote=F,sep="\t",col.names=NA)

col<-c("Glycan Biosynthesis and Metabolism","Energy Metabolism","Lipopolysaccharide","H2S","Metabolism of Cofactors and Vitamins","SCFA","Oxidative_stress_resistance")	
aa<-a[pmatch(col,rownames(a)),,drop=F]
write.table(aa,"function.pro",quote=F,sep="\t",col.names=NA)

for (i in 1:4){
	for (j in 1:num){
		outName <- paste(names(aa)[j],gsub(" ","_",rownames(aa))[i],"pdf",sep=".")
		pdf(outName,bg=rgb(red=238,green=236,blue=225,max =
        255),width=1.875,height=0.278)
		par(mar=c(0,0,0,0))
		plot(0,0,ylim=c(0,1),xlim=c(0,1),type="n",axes=FALSE,xlab="",ylab="")
		for (k in seq(0,0.2,length=200)){segments(k,0.1,k,0.9,col=hsv(alpha=0.9,v=0.76,h=k/0.6),lwd=1.5)}
		for (k in seq(0.2,0.8,length=600)){segments(k,0.1,k,0.9,col=hsv(alpha=0.9,v=0.76,h=1/3),lwd=1.5)}
		for (k in seq(0.8,1,length=200)){segments(k,0.1,k,0.9,col=hsv(alpha=0.9,v=0.76,h=1/3-(k-0.8)/0.6),lwd=1.5)}
		val <- as.numeric(gsub("%","",aa[i,j]))*0.01
		polygon(c(val-0.05,val-0.05,val,val+0.05,val+0.05),c(1,0.9,0.5,0.9,1),col=hsv(h=0,s=0,v=0.45),border=0,xpd=T)
		dev.off()
	}
}

for (i in 5:6){
	        for (j in 1:num){
                outName <- paste(names(aa)[j],gsub(" ","_",rownames(aa))[i],"pdf",sep=".")
                pdf(outName,bg=rgb(red=238,green=236,blue=225,max =
                255),width=1.875,height=0.278)
		par(mar=c(0,0,0,0))
                plot(0,0,ylim=c(0,1),xlim=c(0,1),type="n",axes=FALSE,xlab="",ylab="")
                for (k in seq(0,0.2,length=200)){segments(k,0.1,k,0.9,col=hsv(alpha=0.9,v=0.76,h=k/0.6),lwd=1.5)}
                for (k in seq(0.2,1,length=800)){segments(k,0.1,k,0.9,col=hsv(alpha=0.9,v=0.76,h=1/3),lwd=1.5)}
                val <- as.numeric(gsub("%","",aa[i,j]))*0.01
                polygon(c(val-0.05,val-0.05,val,val+0.05,val+0.05),c(1,0.9,0.5,0.9,1),col=hsv(h=0,s=0,v=0.45),border=0,xpd=
T)      
                dev.off()
        }
}

 for (i in c(7)){
	 for (j in 1:num){
                outName <- paste(names(aa)[j],gsub(" ","_",rownames(aa))[i],"pdf",sep=".")
                pdf(outName,bg=rgb(red=238,green=236,blue=225,max =
                255),width=1.875,height=0.278)
		par(mar=c(0,0,0,0))
                plot(0,0,ylim=c(0,1),xlim=c(0,1),type="n",axes=FALSE,xlab="",ylab="")
                for (k in seq(0,0.8,length=800)){segments(k,0.1,k,0.9,col=hsv(alpha=0.9,v=0.76,h=1/3),lwd=1.5)}
                for (k in seq(0.8,1,length=200)){segments(k,0.1,k,0.9,col=hsv(alpha=0.9,v=0.76,h=1/3-(k-0.8)/0.6),lwd=1.5)}
		val <- as.numeric(gsub("%","",aa[i,j]))*0.01
              	polygon(c(val-0.05,val-0.05,val,val+0.05,val+0.05),c(1,0.9,0.5,0.9,1),col=hsv(h=0,s=0,v=0.45),border=0,xpd=
T)
                dev.off()
        }
}

