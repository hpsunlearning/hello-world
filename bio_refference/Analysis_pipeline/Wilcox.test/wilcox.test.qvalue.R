###qvalue Function###
qvalue<-function (p = NULL, lambda = seq(0, 0.9, 0.05), pi0.method = "smoother",
    fdr.level = NULL, robust = FALSE, gui = FALSE, smooth.df = 3,
    smooth.log.pi0 = FALSE)
{
    if (is.null(p)) {
        qvalue.gui()
        return("Launching point-and-click...")
    }
    if (gui & !interactive())
        gui = FALSE
    if (min(p) < 0 || max(p) > 1) {
        if (gui)
            eval(expression(postMsg(paste("ERROR: p-values not in valid range.",
                "\n"))), parent.frame())
        else print("ERROR: p-values not in valid range.")
        return(0)
    }
    if (length(lambda) > 1 && length(lambda) < 4) {
        if (gui)
            eval(expression(postMsg(paste("ERROR: If length of lambda greater than 1, you need at least 4 values.",
                "\n"))), parent.frame())
        else print("ERROR: If length of lambda greater than 1, you need at least 4 values.")
        return(0)
    }
    if (length(lambda) > 1 && (min(lambda) < 0 || max(lambda) >=
        1)) {
        if (gui)
            eval(expression(postMsg(paste("ERROR: Lambda must be within [0, 1).",
                "\n"))), parent.frame())
        else print("ERROR: Lambda must be within [0, 1).")
        return(0)
    }
    m <- length(p)
    if (length(lambda) == 1) {
        if (lambda < 0 || lambda >= 1) {
            if (gui)
                eval(expression(postMsg(paste("ERROR: Lambda must be within [0, 1).",
                  "\n"))), parent.frame())
            else print("ERROR: Lambda must be within [0, 1).")
            return(0)
        }
        pi0 <- mean(p >= lambda)/(1 - lambda)
        pi0 <- min(pi0, 1)
    }
    else {
        pi0 <- rep(0, length(lambda))
        for (i in 1:length(lambda)) {
            pi0[i] <- mean(p >= lambda[i])/(1 - lambda[i])
        }
        if (pi0.method == "smoother") {
            if (smooth.log.pi0)
                pi0 <- log(pi0)
            spi0 <- smooth.spline(lambda, pi0, df = smooth.df)
            pi0 <- predict(spi0, x = max(lambda))$y
            if (smooth.log.pi0)
                pi0 <- exp(pi0)
            pi0 <- min(pi0, 1)
        }
        else if (pi0.method == "bootstrap") {
            minpi0 <- min(pi0)
            mse <- rep(0, length(lambda))
            pi0.boot <- rep(0, length(lambda))
            for (i in 1:100) {
                p.boot <- sample(p, size = m, replace = TRUE)
                for (i in 1:length(lambda)) {
                  pi0.boot[i] <- mean(p.boot > lambda[i])/(1 -
                    lambda[i])
                }
                mse <- mse + (pi0.boot - minpi0)^2
            }
            pi0 <- min(pi0[mse == min(mse)])
            pi0 <- min(pi0, 1)
        }
        else {
            print("ERROR: 'pi0.method' must be one of 'smoother' or 'bootstrap'.")
            return(0)
        }
    }
    if (pi0 <= 0) {
        if (gui)
            eval(expression(postMsg(paste("ERROR: The estimated pi0 <= 0. Check that you have valid p-values or use another lambda method.",
                "\n"))), parent.frame())
        else print("ERROR: The estimated pi0 <= 0. Check that you have valid p-values or use another lambda method.")
        return(0)
    }
    if (!is.null(fdr.level) && (fdr.level <= 0 || fdr.level >
        1)) {
        if (gui)
            eval(expression(postMsg(paste("ERROR: 'fdr.level' must be within (0, 1].",
                "\n"))), parent.frame())
        else print("ERROR: 'fdr.level' must be within (0, 1].")
        return(0)
    }
    u <- order(p)
    qvalue.rank <- function(x) {
        idx <- sort.list(x)
        fc <- factor(x)
        nl <- length(levels(fc))
        bin <- as.integer(fc)
        tbl <- tabulate(bin)
        cs <- cumsum(tbl)
        tbl <- rep(cs, tbl)
        tbl[idx] <- tbl
        return(tbl)
    }
    v <- qvalue.rank(p)
    qvalue <- pi0 * m * p/v
    if (robust) {
        qvalue <- pi0 * m * p/(v * (1 - (1 - p)^m))
    }
    qvalue[u[m]] <- min(qvalue[u[m]], 1)
    for (i in (m - 1):1) {
        qvalue[u[i]] <- min(qvalue[u[i]], qvalue[u[i + 1]], 1)
    }
    if (!is.null(fdr.level)) {
        retval <- list(call = match.call(), pi0 = pi0, qvalues = qvalue,
            pvalues = p, fdr.level = fdr.level, significant = (qvalue <=
                fdr.level), lambda = lambda)
    }
    else {
        retval <- list(call = match.call(), pi0 = pi0, qvalues = qvalue,
            pvalues = p, lambda = lambda)
    }
    class(retval) <- "qvalue"
    return(retval)
}

####
argv <- commandArgs(T)
if(length(argv)==0){stop("Rscript wilcox.test.R [input1] [input2] [output] [FDR_method]
input1 : profile
input2 : config.
output: The result
FDR_method : eg : p.adjust qvalue
")}
# genotypes...
dat <- as.matrix(read.table(argv[1],head=T))
dat <- dat[rowSums(dat)!=0,]
num <- nrow(dat)

### phenotypes...
con <- read.table(argv[2])
t2d <- as.numeric(con[,2])

# result...
res <- matrix(0,nrow=num,ncol=4)
rownames(res) <- rownames(dat)

# test...
for(i in 1:num){
	a <- as.numeric(dat[i,])
	res[i,1] <- wilcox.test(a[t2d==1],a[t2d==0])$p.value
	r <- rank(a)
	res[i,2] <- mean(r[t2d==1])
	res[i,3] <- mean(r[t2d==0])
	res[i,4] <- 1
	if (res[i,3]>res[i,2]) res[i,4] <- 0
}

# write table...
write.table(res, argv[3], sep="\t", quote=F, col.names=F)

#####hist####
dat <- res
lab = hist(dat[,1],plot=F,breaks=20)
Peak <- lab$mids[which.max(lab$density)]
sd <- sd(dat[,1])
main = paste("P.value.Peak=",Peak,".Sd=",round(sd,3),sep="")
pdf("P.value.hist.pdf")
hist(dat[,1],freq=F,breaks=20,xlab="p.value",main=main)
dev.off()
####FDR####
FDR_method <- as.vector(argv[4])
if(FDR_method == "p.adjust" ){
x <- dat[,1]
x <- x[!is.na(x)]
x.a <- p.adjust(x,method = "BH")
y <- cbind(x,x.a)
r <- order(x)
y <- y[r,]
fdr.1 <- y[max(which(y[,1] < 0.01)),]
fdr.5 <- y[max(which(y[,1] < 0.05)),]
fdr=data.frame(c(0.01,0.05),c(fdr.1[2],fdr.5[2]))
colnames(fdr) = c("Significant_level","FDR")
write.table(fdr,paste("FDR.",FDR_method,".txt",sep=""),quote=F,sep="\t",row.names=F)
}
if(FDR_method == "qvalue"){
x <- dat[,1]
dq <- qvalue(x,lambda=seq(0.60,0.90,0.05))

m.len.1 <- length(dq$qvalues[dq$pvalues<=0.05])
m.len.2 <- length(dq$qvalues[dq$pvalues<=0.01])
FDR.1 <- sort(dq$qvalues[dq$pvalues<=0.05])[m.len.1]
FDR.2 <- sort(dq$qvalues[dq$pvalues<=0.01])[m.len.2]
power.1 <- m.len.1*(1-FDR.1)/length(x)/(1-dq$pi0)
power.2 <- m.len.2*(1-FDR.2)/length(x)/(1-dq$pi0)
fdr=data.frame(c(0.01,0.05),c(FDR.2,FDR.1),c(power.2,power.1))
colnames(fdr) = c("Significant_level","FDR","Power")
write.table(fdr,paste("FDR.",FDR_method,".txt",sep=""),quote=F,sep="\t",row.names=F)
}


