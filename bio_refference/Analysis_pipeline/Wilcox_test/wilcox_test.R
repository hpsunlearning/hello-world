argv <- commandArgs(T)
if(length(argv)==0){stop("Rscript wilcox_test.R [input1] [input2] [output]
input1 : profile
input2 : config.
output: The result
")
}

library(coin)
dat <- as.matrix(read.table(argv[1],head=T))
dat <- dat[rowSums(dat)!=0,]
num <- nrow(dat)

### phenotypes...
con <- read.table(argv[2])
outcome = con[,2]
bf <- as.character(con[,3])
t2d = as.character(outcome)
t2d[t2d=="case"] = 1
t2d[t2d=="control"] = 0
# result...
res <- matrix(0,nrow=num,ncol=4)
rownames(res) <- rownames(dat)

# test...
for(i in 1:num){
	a <- as.numeric(dat[i,])
	data <- data.frame(a=a,outcome=outcome,bf=bf)
	res[i,1] <- pvalue(wilcox_test(a~outcome|bf,data))[1]
	r <- rank(a)
	res[i,2] <- mean(r[t2d==1])
	res[i,3] <- mean(r[t2d==0])
	res[i,4] <- 1
	if (res[i,3]>res[i,2]) res[i,4] <- 0
}

# write table...
write.table(res, argv[3], sep="\t", quote=F,col.names=F)

