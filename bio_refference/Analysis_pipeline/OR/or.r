argv <- commandArgs(T)
if(length(argv) == 0){stop("or.r [input] [config]
input: profile.
config:sample information.")
}

data <- read.table(argv[1])
data <- data[rowSums(data)>0,]
config <- read.table(argv[2])
type = as.factor(config$V2)
data1=t(scale(t(data)))

logtest<-function(marker,outcome1){
         model = model=glm(outcome1~marker,family=binomial())
        #c(coef(summary(model))["marker","Pr(>|z|)"],coef(summary(model))["marker","Estimate"])
        coef(summary(model))["marker",c("Estimate","Std. Error","Pr(>|z|)")]
}

or1=apply(data1,1,function(x){logtest(as.numeric(x),type)})
or1=t(or1)
OR=exp(as.numeric(or1[,1]))
lower=exp(as.numeric(or1[,1])-1.96*as.numeric(or1[,2]))
uper=exp(as.numeric(or1[,1])+1.96*as.numeric(or1[,2]))
or2=data.frame(round(OR,4),round(lower,4),round(uper,4),com=paste(round(OR,2),"(",round(lower,2),",",round(uper,2),")",sep=""))
colnames(or2) = c("OR","95%CI_lower","95%CI_upper","OR_lower_upper")
write.table(or2,"or.txt",quote=F,sep="\t",row.names=rownames(data))

