library(randomForest)
argv <- commandArgs(T)
dat <- read.table(argv[1],head=T)
num <- as.numeric(argv[2])
print (colnames(dat))
d <- t(dat[,-num])
lab <- ifelse(substr(colnames(dat)[-num],1,2) == "DB",1,0)
rf <- randomForest(d,lab,prod = TRUE)
pd <- predict (rf,t(dat))
pd <- as.data.frame(pd)
write.table(pd,"Obese.risk",quote=F,sep="\t",col.names=F)
res <- matrix(0,num,2)
rownames(res) = rownames(pd)[1:num,drop=F]
res[,1] = pd[1:num,1]
ds <- dim(d)
for(i in 1:num){
        ID <- as.numeric(pd[1:num,1])
        NID <- as.numeric(pd[(num+1):ds[1],1])
        res[i,2] <- round((sum(NID > ID[i])/(ds[1]-num))*100,2)
}
write.table(res,"Obese_index.txt",quote=F,sep="\t",col.names=F)
