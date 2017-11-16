argv <- commandArgs(T)
if(length(argv) == 0){stop("fit.mRMR.r [input] [config]
input: profile.
config:sample information")
}

library("sideChannelAttack")
data <- read.table(argv[1])
outcome <- rad.table(argv[2])
outcome = outcome$V1
attack=filter.mRMR(X=t(data),Y=outcome,nbreVarX_=nrow(data))
res <- rownames(data)[attack$filter]
write.table(res,"mrmr.results",quote=F,sep="\t",col.names=F)

