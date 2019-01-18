# Cut Down the Cost due to Uncertainty of travel order

### Groups
* Dept. of MIS - Jack（林聖翔）, 106356022
* Dept. of Statistics - Steve（余佑駿）, 106354005

### Goal

A travel group would be sucessfully established depending on whether there is enough orders not being cancelled. To keep the elasticity and consumers' right, the way of reservation cause the problem that many orders will be cancelled finally. As the result, if we can predict whether the order will be cancelled when we take it, it will save much cost of the travel angency. Meanwhile, providing the better service.

### demo 
For the NDA of contest, we cannot offer the data. However, if you are really interesting about this, you can contact the T-brain. Then run our R & Python data step by step, and you'll get the same result like ours.

* any on-line visualization
  * We don't give any on-line demo visualization, because the NDA of competition. We can only share the experience and data-precessing idea. It's a pity of that!><

## Folder organization and its related information

### docs
* Your presentation, 1071_datascience_FP_106354005_106356022.ppt/pptx/pdf, 
* Any related document for the final project
  * PPT
  * decisionTree.pdf is the result of DT model
  * feature_importance_rfc.csv and feature_importance_xgbc.csv are importance from other two models

### data

* Source:[T-brain 旅遊訂單成行預測](https://tbrain.trendmicro.com.tw/Competitions/Details/4)

* Input format
    * orderId with features, including the following
   
feature | detail 
---|---
sub_line | route of traveling 
area | section of sub_line 
source_1 | sales channel 
source_2 | sales platform 
unit | travel agency 
people_amount | people amount in travel order 
group_amount | people amount in group 
group_days | days of group 
group_price | price of group 
group_order_heat | Popularity of group 
wait_duration | differtime between order and begin 
order_date_weekday | (will do one-hot encoding) 
order_date_weekend | (binary) 
begin_date_weekday | (will do one-hot encoding) 
begin_date_weekend | (binary) 
sub_line_heat | Popularity of sub_line 
area_heat | Popularity of area 
go_n | flights for arriving 
back_n | flights for back 
goback_n | how many flight  
group_site_sum | total spots  in group 
group_site_ave | average spots in group 
unit_group_count | Familiarity of processing group 

 

* Any preprocessing?
  * Handle missing data
      * drop the rows with missing data (missing data is only 0.37% of whole data) 

  * Feature Gernerating
      * Because some categorical data has too muny categories
          * change data to heat (popularity熱門程度) = (category count)/(whole data count)

  * One-hot Encoding
      * One-hot encode some categorical data with few categories (like column source_1, source_2) using dummy variable

  * Scale value

### code

* Which method do you use?
    * XGBoost(Extreme Gradient Boosting), Random Forest, decision tree

* What is a null model for comparison?
    * Guess all the orders not to deal (not_deal : deal = 8:2)
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
    * The AUC of model with balanced data is 0.655 where null model is 0.5, so YES! Our improvement is significant

* What is the challenge part of your project?
    * generate the features which are meaningful and importance from original features
    * Image Data Processing
    
