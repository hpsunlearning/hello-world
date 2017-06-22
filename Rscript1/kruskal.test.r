argv <- commandArgs(T)
if(length(argv) != 3){stop("Rscript wilcox.test.R [input1] [input2] [input3]
input1 : profile
input2 : factor
input4 : p.adj('none', 'holm', 'hommel', 'hochberg', 'bonferroni', 'BH', 'BY', 'fdr', default = 'none')
NOTICE: the order of sample profile and factor must be the same!!
")}

pro <- read.table(argv[1],sep = "\t",header = T)
phe <- read.table(argv[2])
#if(exists(argv[3])){ adj <- argv[3] 
#} else{ adj <- "none"
#}
adj <- argv[3]

library(agricolae)
if(ncol(pro) != nrow(phe)) {stop("Wrong tables! Didn't have equale sample!")}
a <- cbind(t(pro),phe[,2])
nf <- length(levels(as.factor(phe[,2])))

#a <- as.data.frame(a)
#attach(a)
str(a)

res <- matrix(0,nrow=nrow(pro),ncol=(2+2*nf))
k <- kruskal(a[,1],a[,ncol(a)],group=FALSE, p.adj="none", alpha = 0.05, main="a")
res_n <- c("Chisq","p.chisq")
for (i in rownames(k$comparison)){
	res_n <- c(res_n, i, "p.adj")
}
colnames(res) <- res_n
rownames(res) <- rownames(pro)

for (i in 1:(ncol(a)-1)) {
	k <- kruskal(a[,i],a[,ncol(a)],group=FALSE, p.adj=adj, alpha = 0.05, main="a")
	res[i,1] <- k$statistics[1,1]
	res[i,2] <- k$statistics[1,2]
	for (j in 1:nrow(k$comparison)) {
		res[i,2*j+1] <- k$comparison[j,1]
		res[i,2*j+2] <- k$comparison[j,2]
	}
}

for (j in 1:nf) {
	x <- p.adjust(res[,2*j+2],method = adj)
	res[,2*j+2] <- x
}

write.csv(res,file="b.csv")







