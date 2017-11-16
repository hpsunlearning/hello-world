logistic_regression <- function(train, test, label, fit,...){
	library(pROC)
	model = glm(formula=fit, data=train, family = "binomial")
	train$prob = model$fitted.values
	modelroc = roc(train[label][,1],train$prob)
	modelthres = coords(modelroc,"best")
	modelauc = modelroc$auc[1]
	if (class(modelthres) == "matrix"){
		modelthres = modelthres[,which.min(abs(modelthres[1,]-0.5))]
	}
	train$pred = ifelse(train$prob > modelthres[1],1,0)
	train_accuracy = sum(model$y == train$pred) / nrow(train)
	
	test$prob = predict(model,type = "response", newdata = test)
	test$pred = ifelse(test$prob > modelthres[1],1,0)
	test_accuracy = sum(test[label][,1] == test$pred) / nrow(test)
	
	res = c(train_accuracy, test_accuracy)
}

random_forest <- function(train,test,label){
	library(randomForest)
	library(pROC)
	train_y = train[label][,1]
	train_x = train[,-which(colnames(train) == label)]
	test_y = test[label][,1]
	test_x = test[,-which(colnames(test) == label)]
	rdf = randomForest(x=train_x, y=as.factor(train_y),ntree=500)
	train_x$prob = predict(rdf,train_x,type="prob")[,2]
	rdf_roc = roc(train_y,train_x$prob)
	rdf_thres = coords(rdf_roc,"best")
	rdf_auc = rdf_roc$auc[1]
	if (class(rdf_thres) == "matrix"){
		rdf_thres = rdf_thres[,which.min(abs(rdf_thres[1,]-0.5))]
	}
	train_x$pred = ifelse(train_x$prob > rdf_thres[1],1,0)
	train_accuracy = sum(train_y == train_x$pred) / nrow(train_x)	
	
	test_x$prob = predict(rdf,test_x,type = "prob")[,2]
	test_x$pred = ifelse(test_x$prob > rdf_thres[1],1,0)
	test_accuracy = sum(test_y == test_x$pred) / nrow(test_x)
	
	res = c(train_accuracy, test_accuracy)	
}

k_fold_cv <- function(train,label,k=10,method = "logistic",fit){
	library(caret)
	folds = createFolds(train[label][,1],k)
	res = matrix(0,k,2)
	for(i in 1:length(folds)){
		train_i = train[-folds[[i]],]
		test_i = train[folds[[i]],]
		if (method == "logistic"){
			res[i,] = logistic_regression(train_i,test_i,label,fit)
		}
		else if(method == "randomforest"){
			set.seed(i*5)
			res[i,] = random_forest(train_i,test_i,label)
		}
		
	}
	colnames(res) = c("train_accuracy","test_accuracy")
	res
}

nk_cv <- function(train,label,n=10,k=10,method = "logistic",fit){
	res = matrix(0,n,2)
	for(i in 1:n){
		set.seed(i)
		a = k_fold_cv(train,label,k,method,fit)
		res[i,] = colMeans(a)
	}
	colnames(res) = c("train_accuracy","test_accuracy")
	res
}

loo_cv <- function(train,label,method = "logistic",fit){
	res = matrix(0,nrow(train),2)
	for(i in 1:nrow(train)){
		train_i = train[-i,]
		test_i = train[i,]
		if (method == "logistic"){
			res[i,] = logistic_regression(train_i,test_i,label,fit)
		}
		else if(method == "randomforest"){
			set.seed(i*5)
			res[i,] = random_forest(train_i,test_i,label)
		}

	}
	colnames(res) = c("train_accuracy","test_accuracy")
	res
}





