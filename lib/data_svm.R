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
######################################### tune SVM
train1 <- mapply(train, FUN=as.numeric)
train1 <- matrix(data=train1, nrow=4000)

svm_tune <- tune(svm, y~. ,data = train, 
                 kernel="radial", ranges=list(cost=10^(-1:2), gamma=c(.5,1,2)))

print(svm_tune)
########################################## SVM training and predicting
train.svm<- function(traindata) {
  traindata$y<- as.factor(traindata$y)
  model.svm<- svm(y~., data = traindata, cost = 1, gamma=0.5 ,probability = TRUE)
  return(model.svm)
}
test.svm <- function(model,test.data)
{
  return(predict(model,test.data,probability = TRUE))
}

svm.model <- train.svm(train)
svm.pre = test.svm(svm.model,test[,-1])
####################################### performance
prob = attr(svm.pre,"probabilities")

LogLossBinary <- function(actual, predicted, eps = 1e-15) {
  predicted <- pmin(pmax(predicted, eps), 1-eps)
  error<- - (sum(actual * log(predicted) + (1 - actual) * log(1 - predicted))) / length(actual)
  return(error)
}
testtt<-as.numeric(test[,1])-1
LogLossBinary(testtt,prob[,2])

