######### Train Function & Test Function for XGBOOST############
################################################################

train.xgboost<-function(train.data){
  param <- list("objective" = "binary:logistic",
                "eval_metric" = "mlogloss",
                'eta' = 0.3, 'max_depth' = 4)
  nround<-500
  trainnn<-as.matrix(train.data[,-1])
  m <- mapply(trainnn, FUN=as.numeric)
  m <- matrix(data=m, nrow=nrow(train.data))
  dtrain=xgb.DMatrix(data=m[,-1],label=m[,1])
  xgboost.bst<-xgb.train(data = dtrain,  param = param, nrounds = nround)
  return(xgboost.bst)
}

test.xgboost<-function(fit,test.data){
  testtt<-as.matrix(test.data[,-1])
  m.test <- mapply(testtt, FUN=as.numeric)
  m.test <- matrix(data=m.test, nrow=nrow(test.data))
  xgboost.pred<-predict(fit, newdata = m.test[,-1]) 
  return(xgboost.pred)
}
######### Train Function & Test Function for ADABOOST############
#################################################################
train.adaboost<-function(train.data){
  adaboost.bst <- boosting(is_churn~.,data = train.data[,-1], boos = T, mfinal = 20, coeflearn = "Breiman")
  return(adaboost.bst)
}
test.adaboost<-function(fit.adaboost,test.data){
  adaboost.pred <- predict.boosting(fit.adaboost,newdata = test.data[,-1])
  return(adaboost.pred$prob[,2])
}
######### Train Function & Test Function for LASSO###############
#################################################################
train.lasso <-function(train.data){
  lasso.bst<-cv.glmnet(data.matrix(train.data[,3:ncol(train.data)]), 
                       data.matrix(train.data[,2]), 
                       alpha=1,
                       family="binomial",
                       type.measure = "class",
                       nfolds = 5,
                       standardize = TRUE)
  return(lasso.bst)
}
test.lasso<-function(fit.lasso,test.data){
  lambda.1se <- fit.lasso$lambda.1se
  lasso.pred<-predict(fit.lasso, newx = data.matrix(test.data[,3:ncol(test.data)]), s=lambda.1se, type="response")
  return(lasso.pred)
}


###### Train Function & Test Function for Random Forest##########
#################################################################
train.rf<-function(train.data){
  rf.bst<- randomForest(train.data[,3:ncol(train.data)], 
                        as.factor(train.data[,2]), 
                        ntree = 450)
  return(rf.bst)
}

test.rf<-function(fit.rf,test.data){
  rf.pred <- predict(fit.rf, test.data[,3:ncol(test.data)], type = "prob")
  return(rf.pred[,2])
}


######### Train Function & Test Function for SVM#################
#################################################################
train.svm<- function(train.data) {
  #train.data$y<- as.factor(train.data$y)
  svm.bst<- svm(is_churn~., data = train.data[,-1], cost = 1, gamma=0.5 ,probability = TRUE)
  return(svm.bst)
}
test.svm <- function(fit.svm,test.data){
  svm.mid<-predict(fit.svm,test.data[,-1],probability = TRUE)
  svm.pred = attr(svm.mid,"probabilities")[,2]
  return(svm.pred)
}


######### Train Function & Test Function for GBM#################
#################################################################
train.gbm<-function(train.data) {
  train.data<-train.data[,-1]
  train.data[,1]<- as.numeric(as.character(train.data[,1]))
  gbmModel<-gbm(is_churn~., data = train.data,
                distribution = "bernoulli",
                n.trees = 1000,
                shrinkage = 0.05,
                interaction.depth = 1,
                n.minobsinnode=1,
                cv.folds = 5)
  
  return(gbmModel)
}

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


############################################################

LogLossBinary <- function(actual, predicted, eps = 1e-15) {
  predicted <- pmin(pmax(predicted, eps), 1-eps)
  error<- - (sum(actual * log(predicted) + (1 - actual) * log(1 - predicted))) / length(actual)
  return(error)
}


