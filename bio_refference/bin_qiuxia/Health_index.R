argv <- commandArgs(T)
dat <- read.table(argv[1])
x <- read.table(argv[2])
lab = x[,2]
num <- as.numeric(argv[3])
dis <- as.character(argv[4])
d <- (apply(dat,2,function(x){a <- as.numeric(x); dex <- mean(a[lab==0])-mean(a[lab==1])}) * (1e+06))*(-1)
d <- as.data.frame(d)
write.table(d,paste(dis,".index",sep=""),quote=F,sep="\t")
ds <- dim(d)
if(num!=1){
	res <- matrix(0,num,2)
	rownames(res) = rownames(d)[1:num]
	res[,1] = d[1:num,1]
	for(i in 1:num){
		ID <- as.numeric(d[1:num,1])
		NID <- as.numeric(d[(num+1):ds[1],1])
		res[i,2] <- round((sum(NID > ID[i])/(ds[1]-num))*100,2)
	}
	write.table(res,paste(dis,"_index.txt",sep=""),quote=F,sep="\t",col.names=F)
	}
if(num==1){
	res <- matrix(0,1,2)
	rownames(res) = rownames(d)[1]
	res[1,1] = d[1,1]
	ID <- as.numeric(d[1,1])
	NID <- as.numeric(d[2:ds[1],1])
	res[1,2] <- round((sum(NID > ID)/(ds[1]-1))*100,2)
	write.table(res,paste(dis,"_index.txt",sep=""),quote=F,sep="\t",col.names=F)
}

