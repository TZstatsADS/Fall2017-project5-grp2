#########################################################################
########### Test a classification model with extracted features ########
#########################################################################

### Authors: Grp 2
### Project 3
### ADS Fall 2017

######### Test Function for XGBOOST############
################################################################


test.xgboost<-function(fit,test.data){
  testtt<-as.matrix(test.data[,-1])
  m.test <- mapply(testtt, FUN=as.numeric)
  m.test <- matrix(data=m.test, nrow=nrow(test.data))
  xgboost.pred<-predict(fit, newdata = m.test[,-1]) 
  return(xgboost.pred)
}

######### Test Function for ADABOOST ############
#################################################################

test.adaboost<-function(fit.adaboost,test.data){
  adaboost.pred <- predict.boosting(fit.adaboost,newdata = test.data[,-1])
  return(adaboost.pred$prob[,2])
}

######### Test Function for LASSO ###############
#################################################################

test.lasso<-function(fit.lasso,test.data){
  lambda.1se <- fit.lasso$lambda.1se
  lasso.pred<-predict(fit.lasso, newx = data.matrix(test.data[,3:ncol(test.data)]), s=lambda.1se, type="response")
  return(lasso.pred)
}


###### Test Function for Random Forest ##########
#################################################################


test.rf<-function(fit.rf,test.data){
  rf.pred <- predict(fit.rf, test.data[,3:ncol(test.data)], type = "prob")
  return(rf.pred[,2])
}


######### Test Function for SVM #################
#################################################################

test.svm <- function(fit.svm,test.data){
  svm.mid<-predict(fit.svm,test.data[,-1],probability = TRUE)
  svm.pred = attr(svm.mid,"probabilities")[,2]
  return(svm.pred)
}


######### Test Function for GBM #################
#################################################################

test.gbm<-function(fit.gbm, test.data) {
  test.data<-test.data[,-1]
  test.data[,1]<- as.numeric(as.character(test.data[,1]))
  best_ntrees<- gbm.perf(fit.gbm,method = "cv", plot.it = FALSE)
  gbm.pred<-predict(fit.gbm, 
                    test.data,
                    n.trees=best_ntrees,
                    type = "response")
  
  return(gbm.pred)
}

