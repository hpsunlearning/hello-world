file <- commandArgs(T)
data <- read.table(file[1],header=T,row.names=1,sep="\t",check.names=F)
num <- as.numeric(file[2])
sam_name <- colnames(data)[1:num]
quan <- t(apply(data,1,function(x){quantile(x,seq(0,1,0.001))}))
bac_name <- rownames(quan)
aa <- matrix(0,length(sam_name),length(bac_name))
for (i in 1:length(sam_name)){
    for (j in 1:length(bac_name)){
	ab <- abs(quan[bac_name[j],]-data[bac_name[j],sam_name[i]])
	min <- min(abs(quan[bac_name[j],]-data[bac_name[j],sam_name[i]]))
	aa[i,j] <- as.numeric(gsub("%","",names(ab[max(which(ab==min))])))
#        aa[i,j] <- 
#         as.numeric(gsub("%","",names(which.min(abs(quan[bac_name[j],]-data[bac_name[j],sam_name[i]])))))
	}
}
aa<-as.data.frame(aa)
rownames(aa) <- sam_name
colnames(aa) <- bac_name
bb <- apply(data,1,function(x){quantile(x,c(0.1,0.9))})
bb <- as.data.frame(bb)
cc <- rbind(aa,bb)
print(cc)
cc <- t(cc)
write.table(cc,file[3],sep="\t",row.names=T,col.names=NA,quote=F)
