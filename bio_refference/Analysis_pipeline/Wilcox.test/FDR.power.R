qsummary1 <- function (qobj, cuts = c(1e-04, 0.001, 0.01, 0.025, 0.05, seq(0.1,1,0.1)), digits = getOption("digits"), ...) 
{
	counts <- sapply(cuts, function(x) c(`p-value` = sum(qobj$pvalues < 
        x), `q-value` = sum(qobj$qvalues < x)))
	colnames(counts) <- paste("<", cuts, sep = "")
	counts
}

argv <- commandArgs(T)
if(length(argv)==0){stop("/ifs1/ST_META/USER/xiehailiang/usr/bin/Rscript FDR.power.R [input1] [input2] [output1] [output2]
input1 : p.value of each genes
input2 : The colum of the p.lvaue
output3: pq summary
output4: pvalue_qvalue
output5: FDR
")}
library(qvalue)
dat <- read.table(argv[1])
n <- as.numeric(argv[2])
x <- as.numeric(dat[,n])
dq <- qvalue(x,lambda=seq(0.60,0.90,0.05))
qs <- qsummary1(dq)
write.table(qs,argv[3],quote=F,sep="\t")
pq <- cbind(dat,dq$qvalue)
write.table(pq,argv[4],quote=F,sep="\t",col.names=F,row.names=F)
lab = c(0.01,0.05,seq(0.1,1,0.1))
FDR.1 <- rep(0,length(lab))
power.1 <- rep(0,length(lab))
for(i in 1:length(lab)){
	m.len.1 <- length(dq$qvalues[dq$pvalues<=lab[i]])
	FDR.1[i] <- sort(dq$qvalues[dq$pvalues<=lab[i]])[m.len.1]
	power.1[i] <- m.len.1*(1-FDR.1[i])/length(x)/(1-dq$pi0)
}
fdr=data.frame(Level=lab,FDR=FDR.1,Power=power.1)
write.table(fdr,argv[5],quote=F,sep="\t",row.names=F)

