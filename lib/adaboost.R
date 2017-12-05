rm(list=ls())
setwd("D:/Github/fall2017-project5-proj5-grp2")

library(adabag)
load("./data/new3_data_all.Rdata")
str(data.all)

#split 80% of the data to train set and 20% to test set
smp_size <- floor(0.8 * nrow(data.all))
set.seed(123)
train_ind <- sample(seq_len(nrow(data.all)), size = smp_size)
train <- data.all[train_ind, ]
test <- data.all[-train_ind, ]

row.names(train)<-train[,1]
train<-train[,-1]

### Adaboost
# ntree = 20
adaboost20 <- boosting(is_churn~.,data = train, boos = T, mfinal = 20, coeflearn = "Breiman")
pred <- predict.boosting(adaboost20,newdata = test[,-1])

#ntree = 30
adaboost30 <- boosting(is_churn~.,data = train, boos = T, mfinal = 30, coeflearn = "Breiman")
pred2 <- predict.boosting(adaboost30, newdata = test[,-1])

#ntree = 50
adaboost50 <- boosting(is_churn~.,data = train, boos = T, mfinal = 50, coeflearn = "Breiman")
pred3 <- predict.boosting(adaboost50, newdata = test[,-1])

#ntree = 70
adaboost70 <- boosting(is_churn~., data = train, boos = T, mfinal = 70, coeflearn = "Breiman")
pred4 <- predict.boosting(adaboost70, newdata = test[,-1])




ada.cv20 <- boosting.cv(is_churn~.,data = train, v=5, mfinal = 20, 
                        coeflearn = "Breiman",control = rpart.control(cp=0.01))
ada.cv30 <- boosting.cv(is_churn~.,data = train, v=5, mfinal = 30, 
                        coeflearn = "Breiman",control = rpart.control(cp=0.01))
ada.cv50 <- boosting.cv(is_churn~.,data = train, v=5, mfinal = 50,
                        coeflearn = "Breiman",control = rpart.control(cp=0.01))
ada.cv70 <- boosting.cv(is_churn~., data = train, v=5, mfinal = 70,
                        coeflearn = "Breiman", control = rpart.control(cp=0.01))


ada.cv20$error #0.03125
ada.cv30$error #0.02825
ada.cv50$error #0.0285
ada.cv70$error #0.02925

pred$error #0.029
pred2$error #0.023
pred3$error #0.016
pred4$error #0.021



LogLossBinary <- function(actual, predicted, eps = 1e-15) {
  predicted <- pmin(pmax(predicted, eps), 1-eps)
  error<- - (sum(actual * log(predicted) + (1 - actual) * log(1 - predicted))) / length(actual)
  return(error)
}


LogLossBinary(as.numeric(as.character(test[,2])),pred$prob[,2])
LogLossBinary(as.numeric(as.character(test[,2])),pred2$prob[,2])
LogLossBinary(as.numeric(as.character(test[,2])),pred3$prob[,2])
LogLossBinary(as.numeric(as.character(test[,2])),pred4$prob[,2])
