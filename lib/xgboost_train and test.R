######### Train Function & Test Function for XGBOOST############
###################################################################

train.xgboost<-function(train.data){
  param <- list("objective" = "binary:logistic",
                "eval_metric" = "mlogloss",
                'eta' = 0.3, 'max_depth' = 4)
  nround<-500
  trainnn<-as.matrix(train.data[,-1])
  m <- mapply(trainnn, FUN=as.numeric)
  m <- matrix(data=m, nrow=4000)
  dtrain=xgb.DMatrix(data=m[,-1],label=m[,1])
  bst<-xgb.train(data = dtrain,  param = param, nrounds = nround)
  return(bst)
}

test.xgboost<-function(test.data){
  testtt<-as.matrix(test.data[,-1])
  m.test <- mapply(testtt, FUN=as.numeric)
  m.test <- matrix(data=m.test, nrow=1000)
  xgboost.pred<-predict(bst, newdata = m.test[,-1]) 
  return(xgboost.pred)
}