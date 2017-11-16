args <- commandArgs(TRUE)
h=0.95
l=0.05
n <- as.numeric(args[2])
data <- read.table("T2D.index",sep="\t",row.names=1,header=T)
tag <- read.table(args[1],row.names=1,sep="\t")
rownames(data) <- gsub("[X.]","",rownames(data))
rownames(tag) <- gsub("[-.]","",rownames(tag))
control <- intersect(rownames(data),rownames(tag))
case <- rownames(data)[!rownames(data) %in% control]
case <- case[-(1:n)]
case <- case[data[case,] >= quantile(data[case,],probs=l) & data[case,] <= quantile(data[case,],probs=h)]
control <- control[data[control,] >= quantile(data[control,],probs=l) & data[control,] <= quantile(data[control,],probs=h)]
ratio <- apply(data[1],1,function(x){sum(x<data[case,])/length(case)/(sum(x<data[control,])/length(control)+sum(x<data[case,])/length(case))})
write.table(ratio[1:n],"T2D",sep="\t",quote=F)
