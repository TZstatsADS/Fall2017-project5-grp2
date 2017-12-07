# ADS Project 5: Churn Prediction for KKBox

Term: Fall 2017

+ Team #2
+ Project title: Churn Prediction for KKBox
  ![image](figs/WechatIMG171.jpeg)
+ Team members
	+ Xinyao Guo  (xg2257) (Presenter)
	+ Qingyun Lu  (ql2273) (Presenter)
	+ Peilin Qiu  (pq2128)
	+ Sijian Xuan (sx2195)
	+ Yi Zhang    (yz3006)
+ Project summary: 
KKBox is a leading music streaming service in Asia. The objective of our project is to build an algorithm that predicts whether a subscription user will churn after expiration of their KKBOX membership. The data we used consists of three kinds of features: User information in members, transactions and user logs. Before going into the analysis of features, we merged all datasets and sample 5000 commom users as our data. Our pipeline is broken down into 7 steps. <br />

+ Introduction
	+ Goal: 
		+ Understand important drivers of the retention rate for popular musical Apps
		+ Build predictive model to forecast whether a user will churn after subscription expires
	+ Data:
		+ User information at member, transaction and user logs level. 
		+ Merge data by id and select 5000 common users
		+ Features Engineering: Select and create certain features based on EDA
		+ Feature Importance: Random Forest, XGBoost
	+ Models:
		+ Baseline Model: SVM
		+ Advanced Models: Random Forest, GBM, XGBoost, ADABoost, Lasso


+ Step 1: Feature Analysis on EDA <br />
![image](figs/pmt.PNG) 
![image](figs/songs.png) <br />
For more detailed EDA plots, please refer to our Main file in doc. <br />

+ Step 2: Split the dataset and set the evaluation metric <br />
![image](figs/logloss.png) <br />
 where N is the number of observations, yi is the binary target, and pi is the predicted probability that yi equals to 1. <br />

+ Step 3: Train the models and get the error rate using testing data <br />
 Baseline Model: SVM <br />
 Advanced Models: Random Forest, GBM, XGBoost, AdaBoost, Lasso <br />
 
+ Step 4: Cross Validation to select the best model <br />
![image](figs/original.png) <br />

+ Step 5: Feature Importance using Random Forest and XGBoost <br />
![image](figs/Rplot8.png)  <br />

+ Step 6: Reduce the features and test the model <br />
	+ Ignore Gender, Registration Method in the Member dataset; Ignore Discount in the Transaction dataset--Better fit. <br />
![image](figs/simple.png) <br />
	+ Ignore Gender, Registration Method in the Member dataset; Ignore Discount, Actual Amount Paid in the Transaction dataset--Worse fit. <br />
	+ Conclusion: choose Random Forest model on data with 3 reduced features as final model. <br />

+ Step 7: Further Investigation

	+ Separate models for the users who provide valid information and no information (ex. Ignore the member dataset for those who did not have complete information and use a different model for them)
		+ RF model for the group ignoring member dataset: Log Loss= 0.052
		+ RF model for the remaining group with member dataset: Log Loss= 0.059
		+ Need validation on a larger user base


**Contribution statement**: ([default](doc/a_note_on_contributions.md)) All team members contributed equally in all stages of this project. All team members approve our work presented in this GitHub repository including this contributions statement. 

Following [suggestions](http://nicercode.github.io/blog/2013-04-05-projects/) by [RICH FITZJOHN](http://nicercode.github.io/about/#Team) (@richfitz). This folder is orgarnized as follows.

```
proj/
├── lib/
├── data/
├── doc/
├── figs/
└── output/
```

Please see each subfolder for a README file.
