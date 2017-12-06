#########################################################################
########### Cross Validation to select best model among the six models ########
#########################################################################

### Authors: Grp 2
### Project 3
### ADS Fall 2017


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
