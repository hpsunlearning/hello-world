#library("Cairo")
argv <- commandArgs(T)
pro_198<-read.table(argv[1],header=1,row.names=1,sep="\t")
pro_8<-read.table(argv[2],header=T,sep="\t",row.names=1)
list <- read.table(argv[3],header=F,sep="\t")
list<-as.character(list[,1])
num <- as.numeric(argv[4])
outdir <- argv[5]

bac_pro <- function(profile){
	index<-pmatch(list,rownames(profile))
	index<-index[!is.na(index)]
	out_pro<-profile[index,,drop=F]
	genus<-do.call(rbind,strsplit(rownames(profile)," "))[,1]

	for(i in 1:length(list)){
		if(!is.na(pmatch(list[i],rownames(profile)))){ next }
		sum_index<-which(genus==list[i])
		if(is.na(sum_index[1])){next}
		rownames<-c(rownames(out_pro),list[i])
		out_pro<-rbind(out_pro,apply(profile[sum_index,],2,sum))
		rownames(out_pro)<-rownames
	}
	return (out_pro)
}

stat_pro <- function(profile,profile2,out){
        stat <- data.frame()
        for (i in 1:nrow(profile)){stat[i,1]=(sum(profile[i,-(1:num)]==0)/(ncol(profile)-num))}
        for (j in 1:num){ 
                for (i in 1:nrow(profile)){stat[i,j+1]=(sum(profile[i,-(1:num)]<=profile[i,j])/(ncol(profile)-num))}
        }            
        rownames(stat) <- rownames(profile)
        colnames(stat) <- c("zero",colnames(profile)[1:num])

	out_stat <- cbind(stat[,1],profile[,1:num],t(apply(profile[,-(1:num)],1,function(x){quantile(x,probs=c(0.1,0.9))})))
	rownames(out_stat) <- rownames(profile)  
	colnames(out_stat) <- c("zero",colnames(profile)[1:num],"10%","90%")
        write.table(out_stat,paste(outdir,"/",out,".stat",sep=""),quote=F,col.names=NA)

        ref <- pmatch(rownames(stat),rownames(profile2))    
        ref <- profile2[ref,,drop=F]
        ref_stat <- data.frame()
        ref2 <- pmatch(rownames(stat),rownames(profile))
        ref2 <- profile[ref2,-(1:num),drop=F]
        for (i in 1:ncol(ref)){
                for (j in 1:nrow(stat)){
                        ref_stat[j,i]=(sum(unlist(ref2[j,])<=ref[j,i])/length(ref2[j,]))
                }
        }

        for (i in 1:num){
                for (j in 1:nrow(stat)){
			outfile <- gsub(" ","_",rownames(stat)[j])
			outfile <- paste(out,colnames(stat)[i+1],outfile,"pdf",sep=".")
			outfile <- paste(outdir,"/",outfile,sep="")
		CairoPDF(outfile,width=1.875*3,height=0.278*3)
#svg(outfile,width=1.875*3,height=0.278*3)
			par(mar=c(0,0,0,0))
			plot(0,0,ylim=c(0,0.7),xlim=c(0,1),type="n",axes=FALSE,xlab="",ylab="")        	
			box()
			
		        for (k in seq(0,0.2,length=600)){segments(k,0.2,k,0.45,col=hsv(alpha=0.7,s=0.5,v=0.85,h=1/12+k/0.8),lwd=1.5)}                        
                        for (k in seq(0.2,0.8,length=1000)){segments(k,0.2,k,0.45,col=hsv(alpha=0.7,s=0.5,v=0.85,h=1/3),lwd=1.5)}
                        for (k in seq(0.8,1,length=600)){segments(k,0.2,k,0.45,col=hsv(alpha=0.7,s=0.5,v=0.85,h=1/3+(k-0.8)/0.6),lwd=1.5)}
                        rect(0,0.2,stat[j,1],0.45,col=hsv(h=0,s=0,v=0.7),border=hsv(h=0,s=0,v=0.7))
                        polygon(c(stat[j,i+1]-1/60,stat[j,i+1]-1/60,stat[j,i+1],stat[j,i+1]+1/60,stat[j,i+1]+1/60),c(0.55,0.45,0.3,0.45,0.55),col=hsv(alpha=0.9,s=0.4,v=0.6,h=0.85),border=0)
                        for (k in 1:ncol(ref_stat)){
				points(ref_stat[j,k],0.6,col=hsv(alpha=0.7,s=0.5,v=0.65,h=1/3),pch=20)
                        }
                	text(c(0.1,0.2,0.4,0.6,0.8,0.9),rep(0.08,6),labels =c("10%","20%","40%","60%","80%","90%"),adj=0.5,col=hsv(h=0,s=0,v=0),cex=1)
      		        lines(c(0.14,0.16),c(0.08,0.08),lty=3,col=hsv(h=0,s=0,v=0.4))
               		lines(c(0.24,0.36),c(0.08,0.08),lty=3,col=hsv(h=0,s=0,v=0.4))
   		        lines(c(0.44,0.56),c(0.08,0.08),lty=3,col=hsv(h=0,s=0,v=0.4))
			lines(c(0.64,0.76),c(0.08,0.08),lty=3,col=hsv(h=0,s=0,v=0.4))
			lines(c(0.84,0.86),c(0.08,0.08),lty=3,col=hsv(h=0,s=0,v=0.4))
                	dev.off()
		}
        }
}

pro1<- bac_pro(pro_198)
pro2<- bac_pro(pro_8)
index <- pmatch(rownames(pro1),rownames(pro2))
index<-index[!is.na(index)]
pro2 <- pro2[index,,drop=F]
index <- pmatch(rownames(pro2),rownames(pro1))
index<-index[!is.na(index)]
pro1 <- pro1[index,,drop=F]

stat_pro(pro1,pro2,"diet")
