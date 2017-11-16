library(Cairo)
args <- commandArgs(TRUE)
file <- args[1]
num <- args[2]
cut.off <- args[3]
out_file <- args[4]
da <- read.table(file,header=T,row.names=1,sep="\t")
du <- da[1:times]
for ( i in 1:num ){du[[i]]<-gsub("%","",du[[i]])} 
names <- NULL
for (i in 1:num){
        names <- unique(c(names,rownames(du[du[i] > cut.off,])))
    }

data <- du[names,]

CairoPDF(out_file)
plot(unlist(data[1,]),type="b",axes=F,ylim=c(0,100),ylab="content",col=1,lty=1,pch=1+18)
axis(2)
axis(1,at=seq(1,3,1),tick=seq(1,3,1),labels=c("data1","data2","data3"))
for (i in 2:length(rownames(data))){
    lines(unlist(data[i,]),type="b",col=i,lty=i,pch=i+18)
    }
legend("topright",legend=rownames(data),col=1:length(rownames),lty=1:length(rownames))
dev.off()


