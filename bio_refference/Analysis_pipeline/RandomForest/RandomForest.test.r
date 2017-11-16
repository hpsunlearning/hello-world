argv <- commandArgs(T)
if(length(argv) == 0){stop("RandomForest.test.r [input1] [input2] [config] [marker]
    input1: train profile
    input2: test profile
    config: train config
    marker: the marker
      ")
    }

train_pro<-read.table(argv[1])
test_pro<-read.table(argv[2])
config_train<-read.table(argv[3])
train_outcome<-factor(config_train[pmatch(colnames(train_pro),config_train[,1]),2])
marker<-read.table(argv[4])
library(randomForest)

train_marker<-train_pro[pmatch(marker[,1],rownames(train_pro)),]
set.seed(1234)
train_rf<-randomForest(t(train_marker),train_outcome,importance=F)

test_marker<-test_pro[pmatch(marker[,1],rownames(test_pro)),]
test_pred<-predict(train_rf,t(test_marker),type="prob")
write.table(test_pred,"test.prob.txt",quote=F,sep="\t",col.names=NA)

