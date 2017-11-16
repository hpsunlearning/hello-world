kruskal_test <- function(pro,label,alpha = 0.05,p.adj="none"){
    ### pro: profile of all sample, label:sample classification
    library(agricolae)
    if(nrow(pro) != length(label)) {stop("Didn't have equale samples!")}
    nf <- length(levels(as.factor(label)))
    res <- matrix(0,nrow=ncol(pro),ncol=(2+2*choose(nf,2)))
    
    k <- kruskal(pro[,1],label,group=FALSE, p.adj="none", alpha = 0.05)
    res_n <- c("Chisq","p.chisq")
    for (i in rownames(k$comparison)){
        res_n <- c(res_n, i, "p.adj")
    }
    colnames(res) <- res_n
    rownames(res) <- colnames(pro)
    
    for (i in 1:(ncol(pro))) {
        k <- kruskal(pro[,i],label,group=FALSE, p.adj="none", alpha = alpha)
        res[i,1] <- k$statistics[1,1]
        res[i,2] <- k$statistics[1,3]
        for (j in 1:nrow(k$comparison)) {
            res[i,2*j+1] <- k$comparison[j,1]
            res[i,2*j+2] <- k$comparison[j,2]
        }
    }

    for (j in 1:choose(nf,2)) {
        x <- p.adjust(res[,2*j+2],method = p.adj)
        res[,2*j+2] <- x
    }
    res
}

argv <- commandArgs(T)
if(length(argv) != 3){stop("Rscript kruskal.test.R [input1] [input2] [input3]
input1 : profile
input2 : factor
input3 : p.adj('none', 'holm', 'hommel', 'hochberg', 'bonferroni', 'BH', 'BY', 'fdr', default = 'none')
NOTICE: the order of sample profile and factor must be the same!!
")}

pro <- read.table(argv[1],sep = "\t",header = T)
label <- read.table(argv[2])
label <- label[,1]
adj <- argv[3]

library(agricolae)

res <- kruskal_test(pro,label,alpha=alpha,p.adj=adj)
outname <- paste(argv[1],"_",argv[2],"kruskaltest.csv",sep="")
write.csv(res,file=outname)

