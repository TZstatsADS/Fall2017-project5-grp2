#This file is to get a subset (5000) of common user ids from four datasets.

library(readr)

transaction<-read_csv("transactions_v2.csv")
train<-read_csv("train_v2.csv")
members<-read_csv("members_v3.csv")
logs<-read_csv("user_logs_v2.csv") 

ids.train <- unique(train$msno) #970,960
ids.transaction <- unique(transaction$msno) #1,197,050
ids.members <- unique(members$msno) #6,769,473
ids.logs <- unique(logs$msno) #1,103,894

ids.common <- intersect(ids.train,ids.transaction)
ids.common <- intersect(ids.common,ids.members)
ids.common <- intersect(ids.common,ids.logs)
#the number of common ids in four datasets is 725,722

#subset 5000 ids
flag <- sample(1:length(ids.common),size=5000)
ids.sub <- data.frame(ids.common[flag])  
colnames(ids.sub) = 'msno'

#save subset user id into csv
write.csv(ids.sub,'ids_subset.csv',row.names=F)