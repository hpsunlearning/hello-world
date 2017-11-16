##argv <- c("/ifs3/solexa/data/heyuan/meta/PO011/function/important_function.profile","3")
library("Cairo")
argv <- commandArgs(T)
dat<-read.table(argv[1],head=T,sep="\t",row.names=1)
names <- rownames(dat)
Lipopolysaccharide <- colSums(dat[c(4,5),])
dat <- rbind(dat[-c(4,5),],Lipopolysaccharide)
rownames(dat)[nrow(dat)] = "Lipopolysaccharide"
num <- as.numeric(argv[2])
time <- c("2012.09.19","2012.11.02","2012.11.29")
con <- dat[,(num+1):ncol(dat)]
test <- dat[,1:num]
colnames(test) <- gsub("X","",colnames(test))
fig.dat <- t(apply(con,1,function(x){as.numeric(x);quantile(x,seq(0,1,0.001),na.rm=T)}))

a <-data.frame();
for (k in 1:ncol(test)){for (i in 1:7){a[i,k] <- names(which.min(abs(test[i,k]-fig.dat[i,])))}}
colnames(a) <- colnames(test)
rownames(a) <- c("Energy Metabolism","Glycan Biosynthesis and Metabolism",
                "Metabolism of Cofactors and Vitamins","Oxidative_stress_resistance",
                "H2S","SCFA","Lipopolysaccharide")
col<-c("Glycan Biosynthesis and Metabolism","Energy Metabolism","Lipopolysaccharide","H2S","Metabolism of Cofactors and Vitamins","SCFA","Oxidative_stress_resistance") 
aa<-a[pmatch(col,rownames(a)),]
#rownames(aa) <- c("糖类代谢","能量代谢","脂多糖(LPS)生物合成","H2S生物合成","维生素生物合成","短链脂肪酸(SCFA)生物合成","氧化压力抵抗")
rownames(aa) <- c("糖类代谢","能量代谢","LPS生物合成","H2S生物合成","维生素生物合成","SCFA生物合成","氧化压力抵抗")

CairoPDF("funtion.time.pdf",bg=rgb(red=238,green=236,blue=225,max = 255))
par(mar=c(4.2,13.1,2.1,2.1),bg=rgb(red=238,green=236,blue=225,max = 255))
lheight <-  par("csi")
h <- min(strwidth(time,"inch"),strheight(time,"inch"))/lheight
plot(0,0,ylim=c(0,((num+2)*2*7-3)*h),xlim=c(0,1),type="n",axes=FALSE,xlab="",ylab="")


loffset1 <- min(strwidth(time,"inch"),strheight(time,"inch"))/lheight
loffset2 <- max(strwidth(time,"inch"),strheight(time,"inch"))/lheight+loffset1

for (i in 1:4){
	 for (j in 1:num){
		y = ((4+2*num)*(i-1)+1+(j-1)*2)*h
		
		for (k in seq(0,0.2,length=200)){segments(k,y,k,y+ h,col=hsv(alpha=0.9,v=0.76,h=k/0.6),lwd=1.5)}
		for (k in seq(0.2,0.8,length=600)){segments(k,y,k,y+ h,col=hsv(alpha=0.9,v=0.76,h=1/3),lwd=1.5)}
                for (k in seq(0.8,1,length=200)){segments(k,y,k,y+ h,col=hsv(alpha=0.9,v=0.76,h=1/3-(k-0.8)/0.6),lwd=1.5)}
                val <- as.numeric(gsub("%","",aa[i,j]))*0.01
                polygon(c(val-0.02,val-0.02,val,val+0.02,val+0.02),c(y+1.5* h,y+ h,y+0.5* h,y+ h,y+1.5* h),col=hsv(h=0,s=0,v=0.45),border=0,xpd=T)
		mtext(time[j],side=2,at=y+0.5*h,las=2,line =loffset1)
	}
	mtext(rownames(aa)[i],side=2,at=((num+2)*2*i-3)*h,las=2,line = loffset2 )
}

for (i in 5:6){
                for (j in 1:num){
  		y = ((4+2*num)*(i-1)+1+(j-1)*2)*h
		for (k in seq(0,0.2,length=200)){segments(k,y,k,y+ h,col=hsv(alpha=0.9,v=0.76,h=k/0.6),lwd=1.5)}
		for (k in seq(0.2,1,length=800)){segments(k,y,k,y+ h,col=hsv(alpha=0.9,v=0.76,h=1/3),lwd=1.5)}
                val <- as.numeric(gsub("%","",aa[i,j]))*0.01
                polygon(c(val-0.02,val-0.02,val,val+0.02,val+0.02),c(y+1.5* h,y+ h,y+0.5* h,y+ h,y+1.5* h),col=hsv(h=0,s=0,v=0.45),border=0,xpd=T)
		mtext(time[j],side=2,at=y+0.5*h,las=2,line =loffset1)
        }
	mtext(rownames(aa)[i],side=2,at=((num+2)*2*i-3)*h,las=2,line = loffset2 )
}

 i<-7
 for (j in 1:num){
		y = ((4+2*num)*(i-1)+1+(j-1)*2)*h
		for (k in seq(0,0.8,length=600)){segments(k,y,k,y+ h,col=hsv(alpha=0.9,v=0.76,h=1/3),lwd=1.5)}
                for (k in seq(0.8,1,length=200)){segments(k,y,k,y+ h,col=hsv(alpha=0.9,v=0.76,h=1/3-(k-0.8)/0.6),lwd=1.5)}
                val <- as.numeric(gsub("%","",aa[i,j]))*0.01
                polygon(c(val-0.02,val-0.02,val,val+0.02,val+0.02),c(y+1.5* h,y+ h,y+0.5* h,y+ h,y+1.5* h),col=hsv(h=0,s=0,v=0.45),border=0,xpd=T)
		mtext(time[j],side=2,at=y+0.5*h,las=2,line =loffset1)
        }
	mtext(rownames(aa)[i],side=2,at=((num+2)*2*i-3)*h,las=2,line = loffset2 )
box()

dev.off()
