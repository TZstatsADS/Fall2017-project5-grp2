#### data 3 svm
#### Sijian
library("e1071")
load("../data/new3_data_all.rdata")
data.all = data.all[,-1]
colnames(data.all)[1] = "y"
#split 80% of the data to train set and 20% to test set
smp_size <- floor(0.8 * nrow(data.all))
set.seed(123)
train_ind <- sample(seq_len(nrow(data.all)), size = smp_size)
train <- data.all[train_ind, ]
test <- data.all[-train_ind, ]

train.svm<- function(traindata) {
  traindata$y<- as.factor(traindata$y)
  model.svm<- svm(y~., data = traindata, probability = TRUE)
  return(model.svm)
}
test.svm <- function(model,test.data)
{
  return(predict(model,test.data,probability = TRUE))
}

svm.model <- train.svm(train)
svm.pre = test.svm(svm.model,test[,-1])
prob = attr(svm.pre,"probabilities")
list_1 = which(test$y == 1)
list_0 = which(test$y == 0)
accuracy = -(sum(1*log(prob[list_1,2])) + sum(1*log(1-prob[list_0,1])))/1000

# ########################################
LogLossBinary <- function(actual, predicted, eps = 1e-15) {
  predicted <- pmin(pmax(predicted, eps), 1-eps)
  error<- - (sum(actual * log(predicted) + (1 - actual) * log(1 - predicted))) / length(actual)
  return(error)
}
a = as.numeric(as.character(prob[,2]))
b = as.numeric(as.character(test[,1]))
LogLossBinary(a,b)

