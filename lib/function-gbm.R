
######### Train Function & Test Function for GBM
###################################################################
library("gbm")
train.gbm<-function(train_data) {
  
  gbmModel<-gbm(is_churn~., data = train_data,
                distribution = "bernoulli",
                n.trees = 1000,
                shrinkage = 0.05,
                interaction.depth = 1,
                n.minobsinnode=1,
                cv.folds = 5)
  best_ntrees<- gbm.perf(gbmModel,method = "cv", plot.it = TRUE)
  return(list( model.fit=gbmModel, best_ntrees=best_ntrees))
}

test.gbm<-function(fit_train, test_data) {
  gbmTrainPrediction<-predict(fit_train$model.fit, 
                              test_data,
                              n.trees=fit_train$best_ntrees,
                              type = "response")
  
  return(gbmTrainPrediction)
}
#######################################################################
