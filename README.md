# Cut Down the Cost due to Uncertainty of travel order

### Groups
* Dept. of MIS - Jack（林聖翔）, 106356022
* Dept. of Statistics - Steve（余佑駿）, 106354005

### Goal

A travel group would be sucessfully established depending on whether there is enough orders not being cancelled. To keep the elasticity and consumers' right, the way of reservation cause the problem that many orders will be cancelled finally. As the result, if we can predict whether the order will be cancelled when we take it, it will save much cost of the travel angency. Meanwhile, providing the better service.
### demo 
You should provide an example commend to reproduce your result
```R
Rscript code/your_script.R --input data/training --output results/performance.tsv
```
* any on-line visualization

## Folder organization and its related information

### docs
* Your presentation, 1071_datascience_FP_<yourID|groupName>.ppt/pptx/pdf, by **Jan. 15**
* Any related document for the final project
  * papers
  * software user guide

### data

* Source:[T-brain 旅遊訂單成行預測](https://tbrain.trendmicro.com.tw/Competitions/Details/4)
* Input format
    * orderId with features 
* Any preprocessing?
  * Handle missing data
      * drop the rows with missing data (missing data is only 0.37% of whole data) 
  * Feature Gernerating
      * Because following categorical data has too muny categories
          * change data to heat (熱門程度) = category count/whole data count 
  * One-hot Encoding
      * One-hot encode some categorical data with few categories (like column source_1, source_2) using dummy variable
  * Scale value

### code

* Which method do you use?
    * XGBoost(Extreme Gradient Boosting), Random Forest
* What is a null model for comparison?
    * Guess all the orders not to deal (not deal : deal = 8:2)
        * Acuracy : 0.802
        * Precision / Recall : 0
        * AUC : 0.5
* How do your perform evaluation?
    * Split data to training set and testing set (9:1) to evaluate model on testing set
    * Use training data to do 5-fold cross validation

### results

* Which metric do you use 
    * Accuracy
    * Precision
    * Recall
    * AUC
* Is your improvement significant?
    * The AUC of model with balanced data is 0.655 where null model is 0.5
* What is the challenge part of your project?
    * Image Data Processing
    
