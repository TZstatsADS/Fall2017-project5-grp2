rm(list=ls())
setwd("D:/Github/fall2017-project5-proj5-grp2")


### Load data
transaction<-read_csv("./data/transactions_v2.csv")
sample_id<-read_csv('./data/ids_subset.csv') # sample user

train <- read_csv("./data/train_v2.csv") # Training data
final_train <- merge(sample_id, train)
write.csv(final_train, file = "./data/train.csv", row.names = F)


combined = merge(sample_id, transaction)

### auto_renew & is_cancel
total_renew = as.data.frame(aggregate(combined$is_auto_renew,by=list(msno=combined$msno),sum))
colnames(total_renew) <- c("msno","total_renew")

total_cancel = as.data.frame(aggregate(combined$is_cancel,by=list(msno=combined$msno), sum))
colnames(total_cancel) <- c("msno","total_cancel")

final_combined = merge(sample_id,total_renew)
final_combined = merge(final_combined, total_cancel)

final_combined = final_combined[order(final_combined$msno),]