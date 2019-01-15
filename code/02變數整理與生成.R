
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
rm(list = ls()); gc()

# Reference URL -----------------------------------------------------------
# 



# 期末報告規劃 ------------------------------------------------------------------
# 因為現在沒有比賽了
# 所以我們也拿不到test-data的正確label
# 那就把train data拿出來切割成80/20
# 
train <- fread("data_ver01/training-set.csv", encoding = "UTF-8", stringsAsFactors = F)
order <- fread("data_ver01/order.csv", encoding = "UTF-8", stringsAsFactors = F)
group <- fread("data_ver01/group.csv", encoding = "UTF-8", stringsAsFactors = F)
airline <- fread("data_ver01/airline.csv", encoding = "UTF-8", stringsAsFactors = F)
day_sch <- fread("data_ver01/day_schedule.csv", encoding = "UTF-8", stringsAsFactors = F)

# train %>% head()
# order %>% head()
# group %>% head()
# airline %>% head()
# day_sch %>% head()
# 
# train %>% colnames()
# order %>% colnames()
# day_sch %>% colnames()
# group %>% colnames()
# airline %>% colnames()

train$deal_or_not %>% table() %>% prop.table()
#      0      1 
# 238432  58588
#         0         1 
# 0.8027473 0.1972527 




# 抓取 旅行團group 的資訊 ---------------------------------------------------------
# 利用order.csv去計算一個group有多少人
tmp01 <- order %>% group_by(group_id) %>% summarise(group_amount = sum(people_amount))
# 45042個group

# 抓取group中的days, price, subline, area
# 這邊有49223個group，所以有多餘團，等等合併的時候要注意
tmp02 <- group[, .(group_id, days, price, sub_line, area)]




# 下單熱度 --------------------------------------------------------------------
# 下單熱度定義為該group_id有幾筆order_id
tmp03 <- order %>% group_by(group_id) %>% summarise(group_order_heat = n())





# 合併資料 --------------------------------------------------------------------
# 因為train的order_id是int型態，group的order_id是char型態
train$order_id <- train$order_id %>% as.character() 
df01 <- merge(x = train, y = order, by = "order_id", all.x = T)
df02 <- merge(x = df01, y = tmp01, by = "group_id", all.x = T)
df03 <- merge(x = df02, y = tmp02, by = "group_id", all.x = T)
df04 <- merge(x = df03, y = tmp03, by = "group_id", all.x = T)
df04 %>% colnames()
# [1] "group_id"         "order_id"         "deal_or_not"      "order_date"       "source_1"        
# [6] "source_2"         "unit"             "people_amount"    "group_amount"     "days"            
# [11] "price"            "sub_line"         "area"             "group_order_heat"




# 合併聖翔大大資料 --------------------------------------------------------------------
# 要用order_id做合併，計算了
# begin_date_weekday, begin_date_is_weekend, 
# order_date_weekday, order_date_is_weekend
# wait_duration
tmp04 <- fread("data_ver02/order_with_group_begin_date.csv", encoding = "UTF-8", stringsAsFactors = F)
tmp04 %>% head()
tmp04 %>% colnames()
tmp04 <- tmp04[,.(order_id, wait_duration, order_date_weekday, order_date_is_weekend,
                  begin_date_weekday, begin_date_is_weekend)]

df05 <- merge(x = df04, y = tmp04, by = "order_id", all.x = T)
df05 %>% colnames()

df06 <- df05[,!"order_date"]
df06 %>% colnames()




# 新生成欄位 -------------------------------------------------------------------
# sub_line, area的熱度，也就是 sub_line副線別有幾團、area有幾團
# sub_line的熱門程度要從group.csv統計
# area的熱門程度要從group.csv統計
group %>% colnames()
tmp05 <- group %>% group_by(sub_line) %>% summarise(sub_line_heat = n())
tmp06 <- group %>% group_by(area) %>% summarise(area_heat = n())



# 再合併資料 ------------------------------------------------------------------
df07 <- merge(x = df06, y = tmp05, by = "sub_line", all.x = TRUE)
df08 <- merge(x = df07, y = tmp06, by = "area", all.x = TRUE)







# 轉機轉機再轉機 -----------------------------------------------------------------
# 去程轉機次數+回程轉機次數+去回程轉機總次數
# 這要從 airline.csv 去統計次數
airline$group_id %>% unique() %>% length()
airline %>% colnames()
tmp07 <- airline %>% filter(go_back=="去程") %>% group_by(group_id) %>% summarise(go_n = n())
tmp08 <- airline %>% filter(go_back=="回程") %>% group_by(group_id) %>% summarise(back_n = n())
tmp09 <- airline %>% group_by(group_id) %>% summarise(goback_n = n())



 

# 再再合併資料 ------------------------------------------------------------------
df09 <- merge(x = df08, y = tmp07, by = "group_id", all.x = TRUE)
df10 <- merge(x = df09, y = tmp08, by = "group_id", all.x = TRUE)
df11 <- merge(x = df10, y = tmp09, by = "group_id", all.x = TRUE)
df11 %>% colnames()






# 關於景點 --------------------------------------------------------------------
# 從day_schedule，抓出 [景點總數量,平均一天有多少景點]

# 先看一下長怎樣
day_sch$title %>% head()

# 清除[....]、[:punct:]、有的沒的
day_sch$title <- day_sch$title %>% gsub(pattern = "\\[.*\\]", replacement = " ", x = .)
day_sch$title <- day_sch$title %>% gsub(pattern = "<.*>", replacement = " ", x = .)
day_sch$title <- day_sch$title %>% gsub(pattern = "【", replacement = " ", x = .)
day_sch$title <- day_sch$title %>% gsub(pattern = "】", replacement = " ", x = .)
day_sch$title <- day_sch$title %>% gsub(pattern = "─", replacement = " ", x = .)
day_sch$title <- day_sch$title %>% gsub(pattern = "[A-Za-z]+", replacement = " ", x = .)
day_sch$title <- day_sch$title %>% gsub(pattern = "約.*小時", replacement = " ", x = .)
day_sch$title <- day_sch$title %>% gsub(pattern = "約.*分", replacement = " ", x = .)
day_sch$title <- day_sch$title %>% gsub(pattern = "[0-9]+.[0-9]+", replacement = " ", x = .)
day_sch$title <- day_sch$title %>% gsub(pattern = "[0-9]+", replacement = " ", x = .)
day_sch$title <- day_sch$title %>% gsub(pattern = "★", replacement = " ", x = .)
day_sch$title <- day_sch$title %>% gsub(pattern = "～", replacement = " ", x = .)
day_sch$title <- day_sch$title %>% gsub(pattern = "→", replacement = " ", x = .)
day_sch$title <- day_sch$title %>% gsub(pattern = "、", replacement = " ", x = .)
day_sch$title <- day_sch$title %>% gsub(pattern = "＋", replacement = "", x = .)
day_sch$title <- day_sch$title %>% gsub(pattern = "[[:punct:]]", replacement = " ", x = .)
day_sch$title <- day_sch$title %>% gsub(pattern = "到邊界", replacement = " ", x = .)
day_sch$title <- day_sch$title %>% gsub(pattern = "[０|１|２|３|４|５|６|７|８|９]", replacement = " ", x = .)
day_sch$title <- day_sch$title %>% gsub(pattern = "[Ａ|Ｂ|Ｃ|Ｄ|Ｅ|Ｆ|Ｇ|Ｈ|Ｉ|Ｊ|Ｋ]", replacement = " ", x = .)
day_sch$title <- day_sch$title %>% gsub(pattern = "[Ｌ|Ｍ|Ｎ|Ｏ|Ｐ|Ｑ|Ｒ|Ｓ|Ｔ|Ｕ|Ｖ]", replacement = " ", x = .)
day_sch$title <- day_sch$title %>% gsub(pattern = "[Ｗ|Ｘ|Ｙ|Ｚ]", replacement = " ", x = .)
day_sch$title <- day_sch$title %>% gsub(pattern = "或", replacement = "", x = .)
day_sch$title <- day_sch$title %>% gsub(pattern = "號", replacement = "", x = .)
day_sch$title <- day_sch$title %>% gsub(pattern = "小時", replacement = "", x = .)
day_sch$title <- day_sch$title %>% gsub(pattern = "及", replacement = "", x = .)
day_sch$title <- day_sch$title %>% gsub(pattern = "約", replacement = "", x = .)
day_sch$title <- day_sch$title %>% gsub(pattern = "　", replacement = " ", x = .)
day_sch$title <- day_sch$title %>% gsub(pattern = "建議您可自費搭乘電車前往", replacement = "", x = .)
day_sch$title <- day_sch$title %>% gsub(pattern = "盡情暢遊一票到底", replacement = "", x = .)
day_sch$title <- day_sch$title %>% gsub(pattern = "一張", replacement = "", x = .)
day_sch$title <- day_sch$title %>% gsub(pattern = " {1,}", replacement = " ", x = .)

# 計算一天有幾個行程
tmp10 <- day_sch$title %>% strsplit(x = ., split = " ")
tmp11 <- tmp10 %>% lapply(., length)
tmp12 <- tmp11 %>% unlist()
day_sch$n <- tmp12
tmp13 <- day_sch %>% group_by(group_id) %>% summarise(group_site_sum = sum(n),
                                                      group_site_ave = mean(n))




# 再再再合併 -------------------------------------------------------------------
df12 <- merge(x = df11, y = tmp13, by = "group_id", all.x = T)




# 再合併聖翔大大資料 --------------------------------------------------------------------
# 計算了 unit(處理訂單的業務單位)和group_id(該旅行團)，篩選下的order_id數量
# 也就是 業務單位處理旅行團的訂單數量
# 然後應該會是 unit, group_id, n
# 厲害的聖翔大大已經幫忙先合併進入order_id中了
tmp14 <- fread("data_ver02/unit_group_count.csv", encoding = "UTF-8", stringsAsFactors = F)
tmp14$order_id <- tmp14$order_id %>% as.character()
df13 <- merge(x = df12, y = tmp14, by = "order_id", all.x = T)




# 欄位重新命名 ------------------------------------------------------------------
colnames(df13)
colnames(df13) <- c("order_id", "group_id", "area", "sub_line", "deal_or_not",
                    "source_1", "source_2", "unit", "people_amount", "group_amount",
                    "group_days", "group_price", "group_order_heat", "wait_duration", "order_date_weekday",
                    "order_date_weekend", "begin_date_weekday", "begin_date_weekend", "sub_line_heat", "area_heat",
                    "go_n", "back_n", "goback_n", "group_site_sum", "group_site_ave", "unit_group_count")





# 標準化 ------------------------------------------------------------
# 目前沒有用到
# max-min()
nor_max_min <- function(x){
  (x-min(x))/(max(x)-min(x))
}







# 切割train ------------------------------------------------------------------
# 90% of the sample size
final_df <- df13
final_df_label0 <- final_df[deal_or_not==0,]
final_df_label1 <- final_df[deal_or_not==1,]

# label0分成90/10
label0_smp_size <- floor(0.9 * nrow(final_df_label0))

set.seed(9527)
label0_train_ind <- sample(seq_len(nrow(final_df_label0)), size = label0_smp_size, replace = F)

label0_train_tmp <- final_df_label0[label0_train_ind, ]
label0_testing <- final_df_label0[-label0_train_ind, ]


# label1分成90/10
label1_smp_size <- floor(0.9 * nrow(final_df_label1))

set.seed(9527)
label1_train_ind <- sample(seq_len(nrow(final_df_label1)), size = label1_smp_size, replace = F)

label1_train_tmp <- final_df_label1[label1_train_ind, ]
label1_testing <- final_df_label1[-label1_train_ind, ]


# 合併train_tmp 以及testing
train_tmp <- rbind(label0_train_tmp, label1_train_tmp)
testing <- rbind(label0_testing, label1_testing)

write.csv(x = train_tmp, file = "data_ver02/train_tmp.csv", row.names = F, fileEncoding = "UTF-8")
write.csv(x = testing, file = "data_ver02/testing.csv", row.names = F, fileEncoding = "UTF-8")



