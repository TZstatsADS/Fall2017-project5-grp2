### Cross Validation ###
########################

###Load Package
library(xgboost)
library(adabag)
library(data.table)
library(Matrix)
library(xgboost)
library(dplyr)
library(data.table)
library(nnet)
library(glmnet)
library(randomForest)
library(e1071)
library(gbm)

###Load data & Source train and test functions
load("./data/new3_data_all.RData")
source("./lib/Train_and_Test.r")

###Split 80% to train set
smp_size <- floor(0.8 * nrow(data.all))
set.seed(123)
train_ind <- sample(seq_len(nrow(data.all)), size = smp_size)
train <- data.all[train_ind, ]
test<-data.all[-train_ind,]

###Loss function to evaluate models
LogLossBinary <- function(actual, predicted, eps = 1e-15) {
  predicted <- pmin(pmax(predicted, eps), 1-eps)
  error<- - (sum(actual * log(predicted) + (1 - actual) * log(1 - predicted))) / length(actual)
  return(error)
}

###CV on train set
cv.function <- function(data, K){
  
  n <- nrow(data)
  n.fold <- floor(n/K)
  s <- sample(rep(1:K, c(rep(n.fold, K-1), n-(K-1)*n.fold)))

  cv.loss.xgboost<- rep(NA, K)
  cv.loss.adaboost<- rep(NA, K)
  cv.loss.lasso<- rep(NA, K)
  cv.loss.rf<- rep(NA, K)
  cv.loss.svm<- rep(NA, K)
  cv.loss.gbm<- rep(NA, K)
  
  for (i in 1:K){
    train.data <- data[s != i,]
    test.data <- data[s == i,]
    test.label <- as.numeric(test.data[,2])-1

    ###XGBOOST
    fit.xgboost<-train.xgboost(train.data)
    pred.xgboost<-test.xgboost(fit.xgboost,test.data)
    #cv.error.xgboost[i]<-mean(pred.xgboost != test.data$y)
    cv.loss.xgboost[i]<-LogLossBinary(test.label,pred.xgboost)
    
    ###ADABOOST
    fit.adaboost<-train.adaboost(train.data)
    pred.adaboost<-test.adaboost(fit.adaboost,test.data)
    cv.loss.adaboost[i]<-LogLossBinary(test.label,pred.adaboost)
    
    ###LASSO
    fit.lasso<-train.lasso(train.data)
    pred.lasso<-test.lasso(fit.lasso,test.data)
    cv.loss.lasso[i]<-LogLossBinary(test.label,pred.lasso)
    
    ###Random Forest
    fit.rf<-train.rf(train.data)
    pred.rf<-test.rf(fit.rf,test.data)
    cv.loss.rf[i]<-LogLossBinary(test.label,pred.rf)
    
    ###SVM
    fit.svm<-train.svm(train.data)
    pred.svm<-test.svm(fit.svm,test.data)
    cv.loss.svm[i]<-LogLossBinary(test.label,pred.svm)
    
    ###GBM
    fit.gbm<-train.gbm(train.data)
    pred.gbm<-test.gbm(fit.gbm,test.data)
    cv.loss.gbm[i]<-LogLossBinary(test.label,pred.gbm)
  }			
  
  cv.loss<- data.frame(
       xgboost = mean(cv.loss.xgboost), 
       adaboost = mean(cv.loss.adaboost), 
       lasso = mean(cv.loss.lasso), 
       rf = mean(cv.loss.rf), 
       svm = mean(cv.loss.svm), 
       gbm = mean(cv.loss.gbm))
  
  return(cv.loss)
  
}


######### Model Comparison ############
#######################################
cv.function(train,K=5)  

###Results:

#From the output, we choose GBM as our final model. Random Forest also performs well.


###Test Baseline model(SVM):
svmfit<-train.svm(train)
svmpred<-test.svm(svmfit,test)
svm.loss<-LogLossBinary(as.numeric(test$is_churn)-1,svmpred) 
svm.loss                     #loss=0.155

###Test Selected Models:

#1.GBM
gbmfit<-train.gbm(train)
gbmpred<-test.gbm(gbmfit,test)
gbm.loss<-LogLossBinary(as.numeric(test$is_churn)-1,gbmpred) 
gbm.loss                    #loss=0.066

#2.Random Forest
rffit<-train.rf(train)
rfpred<-test.rf(rffit,test)
rf.loss<-LogLossBinary(as.numeric(test$is_churn)-1,rfpred) 
rf.loss                     #loss=0.062