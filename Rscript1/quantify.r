argv <- commandArgs(T)
if(length(argv) != 1) {stop("require input: Raw Ct file!")}

a <- read.table(argv[1],sep = '\t')
a <- a[,c(5,6,8)]
colnames(a) <- c("ID","Primer","Ct")
a$Ct <- gsub("Undetermined",NA,a$Ct)
a$Ct <- as.numeric(a$Ct)
b <- unique(as.character(a$ID))
c <- matrix(data=NA,nrow=length(b),ncol=10)
rownames(c) <- b
colnames(c) <- c("ID","AKK_c","FP_c","BIF_c","LAC_cc","ALL_c","AKK","FP","BIF","LAC")

for(n in b){
	d <- subset(a,a$ID == n)

	AKK_c <- mean(d$Ct[grep("MN6",d$Primer)],na.rm = T)
	FP_c <- mean(d$Ct[grep("237",d$Primer)],na.rm = T)
	BIF_c <- mean(d$Ct[grep("M18",d$Primer)],na.rm = T)
	LAC_c <- mean(d$Ct[grep("214",d$Primer)],na.rm = T)
	ALL_c <- mean(d$Ct[grep("MN1",d$Primer)],na.rm = T)

	AKK <- 2^(ALL_c - AKK_c)
	FP <- 2^(ALL_c - FP_c)
	BIF <- 2^(ALL_c - BIF_c)
	LAC <- 2^(ALL_c - LAC_c)

	c[which(rownames(c) == n),] <- c(n,AKK_c,FP_c,BIF_c,LAC_c,ALL_c,AKK,FP,BIF,LAC)
}

write.table(c,file = "Ct_result.xls",quote = F,sep = "\t",row.names = F)

