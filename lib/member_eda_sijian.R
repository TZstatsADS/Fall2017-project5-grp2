load("../data/member_new_data.rdata")

library("dummies")
trans_data_dummy = dummy.data.frame(member_new_data, names = "sex(female 2 male 3 NA 1)",sep = " ")
colnames(trans_data_dummy)[5:7] = c("no_sex_specified","female","male")
trans_data_dummy = dummy.data.frame(trans_data_dummy, names = "city", sep = " ")
trans_data_dummy = dummy.data.frame(trans_data_dummy, names = "registervia", sep = " ")

for(i in 1:5000){
  if (trans_data_dummy[i,24] <= 10){
    trans_data_dummy[i,24] = 1
  }
  else if ( trans_data_dummy[i,24] > 10 & trans_data_dummy[i,24] <= 20){
    trans_data_dummy[i,24] = 2
  }
  else if ( trans_data_dummy[i,24] > 20 & trans_data_dummy[i,24] <= 30){
    trans_data_dummy[i,24] = 3
  }
  else if ( trans_data_dummy[i,24] > 30 & trans_data_dummy[i,24] <= 40){
    trans_data_dummy[i,24] = 4
  }
  else if ( trans_data_dummy[i,24] > 40 & trans_data_dummy[i,24] <= 50){
    trans_data_dummy[i,24] = 5
  }
  else if ( trans_data_dummy[i,24] > 50 & trans_data_dummy[i,24] <= 60){
    trans_data_dummy[i,24] = 6
  }
  else if ( trans_data_dummy[i,24] > 60 & trans_data_dummy[i,24] <= 70){
    trans_data_dummy[i,24] = 7
  }
  else{
    trans_data_dummy[i,24] = 8
  }
  
}

trans_data_dummy = dummy.data.frame(trans_data_dummy,names = "bd", sep = " ")
dummyvariablesformember = trans_data_dummy# rename
save(dummyvariablesformember, file = "../data/dummyvariablesformember.Rdata")
