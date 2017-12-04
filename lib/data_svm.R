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


# x = train[,-c(1,2)]
# y = train[,2]
# model = svm(x,y)
# 
# xtest = as.numeric(unlist(test[,-c(1,2)]))
# ytest = test[,2]
# 
# pred = predict(model, xtest)
# length(pred)
# sum(pred == ytest)/1000

train.svm<- function(traindata) {
  traindata$y<- as.factor(traindata$y)
  model.svm<- svm(y~., data = traindata,cost=100, gamma=0.01)
  return(model.svm)
}
test.svm <- function(model,test.data)
{
  return(predict(model,test.data,type="class"))
}

svm.model <- train.svm(train)
svm.pre=test.svm(svm.model,test[,-1])
table(svm.pre,test$y)
accuracy = sum(svm.pre == test$y)/1000
accuracy
