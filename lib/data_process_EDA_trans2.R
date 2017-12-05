rm(list=ls())
setwd("D:/Github/fall2017-project5-proj5-grp2")
library(readr)
library(ggplot2)
library(dplyr)
#library(lubridate)
#library(ggforce)
library(tidyr)

### Load data
transaction<-read_csv("./data/transactions_v2.csv")
sample_id<-read_csv('./data/ids_subset.csv') # sample user
load("./data/new.transaction.Rdata")

train <- read_csv("./data/train_v2.csv") # Training data
final_train <- merge(sample_id, train)
#write.csv(final_train, file = "./data/train.csv", row.names = F)

combined = merge(sample_id, transaction)
combined$is_auto_renew<-as.factor(combined$is_auto_renew)
combined$is_cancel<-as.factor(combined$is_cancel)
combined$payment_method_id<-as.factor(combined$payment_method_id)
combined$is_discount <- as.factor(ifelse(combined$actual_amount_paid<combined$plan_list_price,1,0))

### auto_renew & is_cancel
total_renew = as.data.frame(aggregate(combined$is_auto_renew,by=list(msno=combined$msno),sum))
colnames(total_renew) <- c("msno","total_renew")

total_cancel = as.data.frame(aggregate(combined$is_cancel,by=list(msno=combined$msno), sum))
colnames(total_cancel) <- c("msno","total_cancel")

final_combined = merge(sample_id,total_renew)
final_combined = merge(final_combined, total_cancel)

final_combined = final_combined[order(final_combined$msno),]



### is_discount & sum_auto_renew update
load("./data/data.all.Rdata")
data.all$is_discount <- ifelse(data.all$discount==0, 0, 1)
data.all$sum_auto_renew <- ifelse(data.all$sum_auto_renew>=3, 3, data.all$sum_auto_renew)


### EDA


# is_cancel barplot
combined %>%
  ggplot(aes(is_cancel, fill=is_cancel))+
  geom_bar() + 
  theme(legend.position = "none")

# auto_renew barplot
combined %>%
  ggplot(aes(is_auto_renew,fill=is_auto_renew))+
  geom_bar() +
  theme(legend.position = "none")

# is_discount barplot
combined %>%
  ggplot(aes(is_discount,fill=is_discount))+
  geom_bar()+
  theme(legend.position = "none")

# transaction date & expiration date
#combined$transaction_date
#combined$membership_expire_date
#combined %>%
# filter(membership_expire_date > ymd("20170301")) %>%
#  ggplot(aes(membership_expire_date))+
#  geom_freqpoly(color="red", binwidth=1)+
#  geom_freqpoly(aes(transaction_date),color="orange",binwidth=1)
#  facet_zoom(x=(transaction_date>ymd("20170301") & transaction_date < ymd("20170331") &
#                 membership_expire_date>ymd("20170301") & membership_expire_date<ymd("20170331")))+
#  labs(x="Transaction date (orange) vs Expiration date (red)")

# trans
#combined %>%
#  mutate(month = month(transaction_date,label = T))%>%
#  ggplot(aes(wday,fill=wday))+
#  geom_bar()+
#  theme(legend.position = "none")+
#  labs(x="Day of the week")+
#  ggtitle("Transaction Dates")

Mode <- function(x){
  ux <- unique(x)
  ux[which.max(tabulate(match(x,ux)))]
}

get_binCI <- function(x,n) {
  rbind(setNames(c(binom.test(x,n)$conf.int),c("lwr","upr")))
}

# auto renew & is churn
combined %>%
  group_by(msno) %>%
  summarise(is_auto_renew = Mode(is_auto_renew))%>%
  inner_join(train,by="msno") %>%
  group_by(is_auto_renew,is_churn)%>%
  count() %>%
  spread(is_churn,n)%>%
  mutate(frac_churn=`1`/(`1`+`0`)*100,
         lwr = get_binCI(`1`,(`1`+`0`))[[1]]*100,
         upr = get_binCI(`1`,(`1`+`0`))[[2]]*100
         )%>%
  ggplot(aes(is_auto_renew,frac_churn,fill=is_auto_renew))+
  geom_col()+
  geom_errorbar(aes(ymin=lwr,ymax=upr),width=0.5,size=0.7,color="gray30")+
  theme(legend.position = "none")+
  labs(x="Auto renew",y="Churn[%]")

# is cancel & is churn
combined %>%
  group_by(msno) %>%
  summarise(is_cancel = Mode(is_cancel))%>%
  inner_join(train,by="msno") %>%
  group_by(is_cancel,is_churn)%>%
  count() %>%
  spread(is_churn,n)%>%
  mutate(frac_churn=`1`/(`1`+`0`)*100,
         lwr = get_binCI(`1`,(`1`+`0`))[[1]]*100,
         upr = get_binCI(`1`,(`1`+`0`))[[2]]*100
  )%>%
  ggplot(aes(is_cancel,frac_churn,fill=is_cancel))+
  geom_col()+
  geom_errorbar(aes(ymin=lwr,ymax=upr),width=0.5,size=0.7,color="gray30")+
  theme(legend.position = "none")+
  labs(x="Cancelled",y="Churn[%]")

# is discount & is churn
new.trans %>%
  group_by(msno) %>%
  summarise(is_discount = Mode(is_discount))%>%
  inner_join(train,by="msno") %>%
  group_by(is_discount,is_churn)%>%
  count() %>%
  spread(is_churn,n)%>%
  mutate(frac_churn=`1`/(`1`+`0`)*100,
         lwr = get_binCI(`1`,(`1`+`0`))[[1]]*100,
         upr = get_binCI(`1`,(`1`+`0`))[[2]]*100
  )%>%
  ggplot(aes(is_discount,frac_churn,fill=is_discount))+
  geom_col()+
  geom_errorbar(aes(ymin=lwr,ymax=upr),width=0.5,size=0.7,color="gray30")+
  theme(legend.position = "none")+
  labs(x="Discount",y="Churn[%]")

# member duration
new.trans %>%
  mutate(member_duration = factor(member_duration)) %>%
  ggplot(aes(member_duration, fill = member_duration)) +
  geom_bar() +
  scale_y_sqrt() +
  theme(legend.position = "none") +
  labs(x = "member duration")
