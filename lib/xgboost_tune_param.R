
#load data
load("D:/Fall 2017/ADS/proj 5/new3_data_all.RData")

##############################################
####Tune model and choose parameters
library(xgboost)
#split 80% of the data to train set and 20% to test set
smp_size <- floor(0.8 * nrow(data.all))
set.seed(123)
train_ind <- sample(seq_len(nrow(data.all)), size = smp_size)
train <- data.all[train_ind, ]
test <- data.all[-train_ind, ]

labels <- train$is_churn 
test_label <- test$is_churn
trainnn<-as.matrix(train[,-1])
testtt<-as.matrix(test[,-1])
m <- mapply(trainnn, FUN=as.numeric)
m <- matrix(data=m, nrow=4000)
m.test <- mapply(testtt, FUN=as.numeric)
m.test <- matrix(data=m.test, nrow=1000)
dtrain=xgb.DMatrix(data=m[,-1],label=m[,1])

### Parameter

NROUNDS = c(500,1000)
ETA = c(0.3)
MAX_DEPTH = c(3,4,5,6)

cv.xgb <- function(X.train, y.train, K, NROUNDS, ETA, MAX_DEPTH){
  for (nround in NROUNDS){
    for (eta in ETA){
      for (max_depth in MAX_DEPTH){
        n <- length(y.train)
        n.fold <- floor(n/K)
        s <- sample(rep(1:K, c(rep(n.fold, K-1), n-(K-1)*n.fold)))  
        cv.loss <- rep(NA, K)
        
        for (i in 1:K){
          train.data <- X.train[s != i,]
          train.label <- y.train[s != i]
          test.data <- X.train[s == i,]
          test.label <- y.train[s == i]
          
          param <- list("objective" = "binary:logistic",
                        "eval_metric" = "mlogloss",
                        'eta' = eta, 'max_depth' = max_depth)
          
          dtrain=xgb.DMatrix(data=train.data,label=train.label)
          
          bst <- xgb.train(data = dtrain,  param = param, nrounds = nround)
          pred <- predict(bst, newdata = test.data) 
          
          #cv.acc[i] <- mean(pred == test.label) 
          cv.loss[i]<-LogLossBinary(test.label,pred)
        }			
        print(paste("------Mean 5-fold cv loss for nround=",nround,",eta=",eta,",max_depth=",max_depth,
                    "------",mean(cv.loss)))
        #key = c(nround,eta,max_depth)
        #CV_ERRORS[key] = mean(cv.loss)
        
      }
    }
  }
}

#CV_ERRORS = list()
cv.xgb(m[,-1],m[,1], 5, NROUNDS, ETA, MAX_DEPTH)
#####Tuned xgboost model

cv.loss.xgboost<-LogLossBinary(test.data[,1],pred)

###Calculate Logloss Error to deal with imbalanced label

LogLossBinary <- function(actual, predicted, eps = 1e-15) {
  predicted <- pmin(pmax(predicted, eps), 1-eps)
  error<- - (sum(actual * log(predicted) + (1 - actual) * log(1 - predicted))) / length(actual)
  return(error)
}
LogLossBinary(m.test[,1],pred)
