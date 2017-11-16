argv <- commandArgs(T)
if(length(argv)==0){stop("Rscript Correlation.R [profile][COR] [Method] [prefix]
profile: profile.
COR: COL or ROW: col:Calculate the sample's correlatin. row:Calculate the variables correlation
Method: pearson spearman kendall
prefix: output prefix
")}
dat <- read.table(argv[1],head=T)
dat <- dat[rowSums(dat)!=0,]
COR <- as.vector(argv[2])
if(COR=="COL"){
	dat <- t(dat)
}
if(COR=="ROW"){
	dat <- dat
}
Method <- as.vector(argv[3])
prefix <- as.vector(argv[4])
for(i in 1:(nrow(dat)-1)){
	for(j in (i+1):nrow(dat)){
		tmp = cor.test(as.numeric(dat[i,]),as.numeric(dat[j,]),method=Method)
		res <- as.matrix(c(rownames(dat)[i],rownames(dat)[j],as.numeric(tmp$estimate),tmp$p.value))
		res <- t(res)
		write.table(res,paste(prefix,"_",Method,"_corr.txt",sep=""),quote=F,sep="\t",append=T,row.names=F,col.names=F)
	}
}

