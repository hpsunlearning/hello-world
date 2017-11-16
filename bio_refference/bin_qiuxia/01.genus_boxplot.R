file <- commandArgs(T)
da <- read.table(file[1],head=T,row.names=1,sep="\t")
index <- grep("",rownames(da))
da <- da[index,]
genus <- apply(da,2,sum)
range <- quantile(genus,c(0.1,0.9))

