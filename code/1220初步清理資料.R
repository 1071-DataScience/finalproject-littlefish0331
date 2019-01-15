
# Basic Information -------------------------------------------------------
# Author: Steve, Yu
# Date: Sun Sep 30 09:26:06 2018
# --
# Topic:
# Date:
# Modification:
# --
#
# Setting Path ------------------------------------------------------------
setwd("D:/比賽證照講座/[00比賽][2018T_brain_旅遊訂單成行預測]/新公布的資料/")
getwd()

# Package -----------------------------------------------------------------
library(dplyr)
library(data.table)
library(lubridate)

# Reference URL -----------------------------------------------------------
#




# training-set.csv -----------------------------------------------------------
A <- fread("training-set.csv", encoding = "UTF-8")
A %>% head()
A %>% dim() #297020      2
# fwrite(x = A, file = "D:/tmp/training-set.csv", row.names = F)





# testing-set.csv -----------------------------------------------------------
A <- fread("data_ver01/testing-set.csv", encoding = "UTF-8")
A %>% head()
A %>% dim() #99895     2
# fwrite(x = A, file = "D:/tmp/testing-set.csv", row.names = F)



# cmp4_sample_submission.csv ------------------------------------------------
A <- fread("data_ver01/cmp4_sample_submission.csv", encoding = "UTF-8")
A %>% head()
A %>% dim() #99895     2
# fwrite(x = A, file = "D:/tmp/cmp4_sample_submission.csv", row.names = F)




# order.csv ----------------------------------------------------------------
A <- fread("raw_data/order.csv", encoding = "UTF-8")
A %>% head()
A %>% colnames()
A %>% dim() #396915      7

# source_1 #訂單來源一
# source_2 #訂單來源二
# unit #訂單負責單位

A$source_1 %>% unique() # 只有三種。"src1_value_1" "src1_value_2" "src1_value_3"
A$source_2 %>% unique() # 只有四種。"src2_value_1" "src2_value_2" "src2_value_3" "src2_value_4"
A$unit %>% unique() %>% length() #有130種。"unit_value_1"~"unit_value_131"

A$source_1 %>% table()
# src1_value_1 src1_value_2 src1_value_3 
#       271299       116301         9315 

A$source_2 %>% table()
# src2_value_1 src2_value_2 src2_value_3 src2_value_4 
#       305353         4678        59457        27427

A$unit %>% table()
# 太多種我就不列了

# 基本清理
A$source_1 <- A$source_1 %>% gsub(pattern = "src1_value_", replacement = "", x = .)
A$source_2 <- A$source_2 %>% gsub(pattern = "src2_value_", replacement = "", x = .)
A$unit <- A$unit %>% gsub(pattern = "unit_value_", replacement = "", x = .)

# 存檔
fwrite(x = A, file = "D:/tmp/order.csv", row.names = F)






# group.csv ---------------------------------------------------------------
A <- fread("raw_data/group.csv", encoding = "UTF-8")
A %>% head()
A %>% colnames()
A %>% dim() #104275      6

# sub_line: 副線別
# area: 地區
A$sub_line %>% unique() # 共有23種。
A$area %>% unique() # 共有157個

# 清理
A$sub_line <- A$sub_line %>% gsub(pattern = "subline_value_", replacement = "", x = .)
A$area <- A$area %>% gsub(pattern = "area_value_", replacement = "", x = .)

# 存檔
fwrite(x = A, file = "D:/tmp/group.csv", row.names = F)




# airline.csv ---------------------------------------------------------------
A <- fread("raw_data/airline.csv", encoding = "UTF-8")
A %>% head()
A %>% colnames()
A %>% dim() #104275      6
fwrite(x = A, file = "D:/tmp/airline.csv", row.names = F)




# day_schedule.csv --------------------------------------------------------
A <- fread("raw_data/day_schedule.csv", encoding = "UTF-8")
A %>% head()
A %>% colnames()
A %>% dim() #307046      3
fwrite(x = A, file = "D:/tmp/day_schedule.csv", row.names = F)






# cache_map.csv ---------------------------------------------------------------
# cache_map.csv、lion_cache先不做處理







