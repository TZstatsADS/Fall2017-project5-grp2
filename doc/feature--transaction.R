#This file contains feature engineering on transactions data

library(readr)

trans<-read_csv("transactions_v2.csv")
trans$discount<-trans$plan_list_price-trans$actual_amount_paid
trans$amt_per_day<-trans$actual_amount_paid/trans$payment_plan_days
trans$transaction_date<-as.Date(as.character(trans$transaction_date),format="%Y%m%d")
trans$membership_expire_date<-as.Date(as.character(trans$membership_expire_date),format="%Y%m%d")
trans$member_duration<-trans$membership_expire_date-trans$transaction_date
#set negative duration value to zero
trans$member_duration[trans$member_duration<0]=0
#read sample user id 
ids.sub = read_csv('ids_subset.csv')
#5000 subset in transaction (one user may have multiple lines)
sub_trans<-trans[trans$msno %in% ids.sub$msno,]
#1. To solve for the problem that pmt_plan_days<=0:
id.wrong.days<-trans$payment_plan_days<=0
#set plan list price to 149, pmt plan days to 30
sub_trans[id.wrong.days,"plan_list_price"]<-149
sub_trans[id.wrong.days,"payment_plan_days"]<-30
sub_trans$discount<-sub_trans$plan_list_price-sub_trans$actual_amount_paid
sub_trans$amt_per_day<-sub_trans$actual_amount_paid/sub_trans$payment_plan_days
#order the data by msno
ordered.data<-sub_trans[order(sub_trans$msno),]


a<-aggregate(ordered.data$payment_plan_days,by=list(msno=ordered.data$msno),FUN=mean)
b<-aggregate(ordered.data$amt_per_day,by=list(msno=ordered.data$msno),FUN=mean)
c<-aggregate(ordered.data$plan_list_price,by=list(msno=ordered.data$msno),FUN=mean)
d<-aggregate(ordered.data$actual_amount_paid,by=list(msno=ordered.data$msno),FUN=mean)
e<-aggregate(ordered.data$discount,by=list(msno=ordered.data$msno),FUN=mean)
f<-aggregate(ordered.data$is_auto_renew,by=list(msno=ordered.data$msno),FUN=sum)
g<-aggregate(ordered.data$is_cancel,by=list(msno=ordered.data$msno),FUN=sum)
h<-aggregate(ordered.data$member_duration,by=list(msno=ordered.data$msno),FUN=mean)

new.trans<-as.data.frame(cbind(a,b[,-1],c[,-1],d[,-1],e[,-1],f[,-1],g[,-1],h[,-1]))
colnames(new.trans)<-c("msno","payment_plan_days","amt_per_day","plan_list_price","actual_amount_paid",
                       "discount","sum_auto_renew","sum_cancel","member_duration")

new.trans$payment_plan_days<-ifelse(new.trans$payment_plan_days<30,0,ifelse(new.trans$payment_plan_days<=90,1,2))
new.trans$payment_plan_days<-as.factor(new.trans$payment_plan_days)
new.trans$is_discount <- ifelse(new.trans$discount==0, 0, 1)
new.trans$is_discount<-as.factor(new.trans$is_discount)
new.trans$sum_cancel<-as.factor(new.trans$sum_cancel)
new.trans$sum_auto_renew <- ifelse(new.trans$sum_auto_renew>=3, 3, new.trans$sum_auto_renew)
new.trans$sum_auto_renew<-as.factor(new.trans$sum_auto_renew)
new.trans<-new.trans[,-6]
#write.csv(new.trans,"subset_transaction.csv",row.names = F)
save(new.trans,file = "new.transaction.RData")
save(sub_trans,file="trans.before.aggregate.RData")
#convert categorical variables to dummmies:
library(dummies)
trans_data_dummy <- dummy.data.frame(new.trans, names=c("payment_plan_days","is_discount","sum_cancel","sum_auto_renew"), sep="_")
save(trans_data_dummy,file="trans.dummy.RData")
