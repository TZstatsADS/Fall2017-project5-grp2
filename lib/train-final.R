#########################################################################
########### Train a classification model with extracted features ########
#########################################################################

### Authors: Grp 2
### Project 3
### ADS Fall 2017

######### Train Function for XGBOOST ############
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


######### Train Function for ADABOOST ############
#################################################################
train.adaboost<-function(train.data){
  adaboost.bst <- boosting(is_churn~.,data = train.data[,-1], boos = T, mfinal = 20, coeflearn = "Breiman")
  return(adaboost.bst)
}


######### Train Function for LASSO ###############
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


###### Train Function for Random Forest ##########
#################################################################
train.rf<-function(train.data){
  rf.bst<- randomForest(train.data[,3:ncol(train.data)], 
                        as.factor(train.data[,2]), 
                        ntree = 500, 
                        importance = T)
  return(rf.bst)
}



######### Train Function for SVM #################
#################################################################
train.svm<- function(train.data) {
  #train.data$y<- as.factor(train.data$y)
  svm.bst<- svm(is_churn~., data = train.data[,-1], cost = 1, gamma=0.5 ,probability = TRUE)
  return(svm.bst)
}



######### Train Function for GBM #################
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


