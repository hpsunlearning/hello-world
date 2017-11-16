args <- commandArgs(TRUE)
h=0.95
l=0.05
n <- as.numeric(args[2])
cc <- read.table("CC.index",sep="\t",row.names=1,header=T)
tag <- read.table(args[1],sep="\t",row.names=1)
rownames(cc) <- gsub("\\.","",rownames(cc))
rownames(cc) <- gsub("X","",rownames(cc))
case <- rownames(tag)[tag==0]
case <- gsub("-","",case)
case <- case[cc[case,] >= quantile(cc[case,],probs=l) & cc[case,] <= quantile(cc[case,],probs=h)]
control <- rownames(tag)[tag==1]
control <- gsub("-","",control)
control <- control[cc[control,] >= quantile(cc[control,],probs=l) & cc[control,] <= quantile(cc[control,],probs=h)]
ratio <- apply(cc[1],1,function(x){sum(x>cc[case,])/length(case)/(sum(x>cc[control,])/length(control)+sum(x>cc[case,])/length(case))})
write.table(ratio[1:n],"CC",sep="\t",quote=F)

