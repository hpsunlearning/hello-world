argv <- commandArgs(T)
if(length(argv) == 0){stop("Rscript loocv.r [input] [config]
input: profile.
config:sample information")
}



data<-read.table(argv[1])
outcome = read.table(argv[2])


	library(gtools)
	data1<-data.frame(t(data),fact=outcome)
	comb<-combinations(nrow(data1),1)

	library(MASS)
	i<-1
	sep<-1:nrow(data1)
	err<-NULL
	errnum<-0

	
	for(j in 2:nrow(data)){
	 mis<-c()
	i=1
	while(i<=nrow(comb)){
		train=sep[-comb[i,]]
		model=glm(outcome[train]~. ,data=data1[train,c(1:j)],family=binomial())
     		pred <-as.numeric(as.vector(predict(model, data1[-train,c(1:j)], type="response")))
		mis<-c(mis,pred)
		i=i+1
	}
	pred=mis
	err=sum(pred>0.5&outcome==0|pred<0.5&outcome==1)/length(outcome)
      tpr=sum(pred<0.5&outcome==0)/sum(outcome==0)
      fpr=sum(pred<0.5&outcome==1)/sum(outcome==1)
      write.table(list(err=err,tpr=tpr,fpr=fpr),"mix.txt",sep="\t",quote=F,col.names=F,append=T)
	}

