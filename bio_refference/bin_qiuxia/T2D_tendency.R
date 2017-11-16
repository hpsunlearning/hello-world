library(Cairo)
file <- commandArgs(T)
dat <- read.table(file[1],sep="\t",head=T,row.names=1)
da <- dat[,-1]
list <- read.table(file[2],head=F,row.names=1)
gene <- read.table(file[3],head=F)
rownames(list) <- gsub("[-.]","",rownames(list))
colnames(da) <- gsub("\\.","",colnames(da))
con <- intersect(colnames(da),rownames(list))
control <- da[,con]
case <- da[,!(colnames(da) %in% rownames(list))]
control_gene_0 <- control[gene[,2]==0,]
control_gene_1 <- control[gene[,2]==1,]
case_gene_0 <- case[gene[,2]==0,]
case_gene_1 <- case[gene[,2]==1,]
control_gene_0_index <- apply(control_gene_0,2,sum)/nrow(control_gene_0)*1e6
control_gene_1_index <- apply(control_gene_1,2,sum)/nrow(control_gene_1)*1e6
case_gene_0_index <- apply(case_gene_0,2,sum)/nrow(case_gene_0)*1e6
case_gene_1_index <- apply(case_gene_1,2,sum)/nrow(case_gene_1)*1e6
control_id <- c(which(control_gene_1_index>6),which(control_gene_0_index>6))
case_id <- c(which(case_gene_1_index>6),which(case_gene_0_index>6))
case_gene_0_index <- case_gene_0_index[-case_id]
case_gene_1_index <- case_gene_1_index[-case_id]
control_gene_0_index <- control_gene_0_index[-control_id]
control_gene_1_index <- control_gene_1_index[-control_id]
sample <- dat[,1]
names(sample) <- rownames(dat)
sample_0 <- sample[gene[,2]==0]
sample_1 <- sample[gene[,2]==1]
sample_0_index <- sum(sample_0)/length(sample_0)*1e6
sample_1_index <- sum(sample_1)/length(sample_1)*1e6
CairoPDF("T2D_tendency.pdf")
a <- 0.6
xmax <- 7
ymax <- 7
colmin <- 0
colmax <- 120
seq1 <- seq(0,xmax,length=300)
seq2 <- seq(0,ymax,length=300)
plot(0,0,xlab="Abundance of markers enriched in case",ylab="Abundance of markers enriched in control",xlim=c(0,6),ylim=c(0,6))
for(i in seq1){
    for(j in seq2){
        i <- i
        j <- j
        h <- (((j-i+xmax) / (ymax+xmax)) * (colmax - colmin)) / 360
        points(i,j,pch = 15, cex = 2 , col = hsv(h=h, s=0.2, v=0.8,
            alpha=0.3))
        #rgb(35*(i/7+j/7+5)/255,35*(7-i/7-j/7)/255,180/255,alpha=0.2))
    }
}
points(control_gene_1_index,control_gene_0_index,col=hsv(alpha=0.9,s=0.5,v=0.85,h=1/3),pch=19,cex=0.5)
points(case_gene_1_index,case_gene_0_index,col=hsv(alpha=0.9,s=0.5,v=0.85,h=0),pch=17,cex=0.8)
points(sample_1_index,sample_0_index,col=hsv(alpha=0.9,s=0.5,v=0.85,h=2/3),pch=19,cex=1.5)
legend("topright",c("case","control","sample"),pch=c(17,20,19),col=c(hsv(alpha=0.9,s=0.5,v=0.85,h=0),hsv(alpha=0.9,s=0.5,v=0.85,h=1/3),hsv(alpha=0.9,s=0.5,v=0.85,h=2/3)))
