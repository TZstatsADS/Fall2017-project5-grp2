# ADS Project 5: Churn Prediction for KKBox

Term: Fall 2017

+ Team #2
+ Project title: Churn Prediction for KKBox
+ Team members
	+ Xinyao Guo
	+ Qingyun Lu
	+ Peilin Qiu
	+ Sijian Xuan
	+ Yi Zhang
+ Project summary: 
  ![image](figs/Rplot8.png)
  KKBox is a leading music streaming service in Asia. The objective of our project is to built an algorithm that predicts whether a subscription user will churn after their membership expiration for KKBOX. The data we used consists of three kinds of features: User information in members, transactions and user logs. Our pipeline is broken down into 4 steps. First, we merged all features and sample 5000 commom users. Second, we extracted the features and analyzed the features based on EDA. Then we trained the classification models and tested the models using LogLoss evaluation. Last, we reduced the features based on the importance of features in step 3 and retrained the models.  
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
