library(tidyverse)
library(stringr)
library(dplyr)
library(lubridate)
library(caret)
library(stringr)

## import and merge original data
setwd("/Users/jay/Desktop/UMD/20Spring/BUDT758T/project/data/")
df_x = read.csv('airbnb_train_x.csv')
df_y = read.csv('airbnb_train_y.csv')
df_x$high_booking_rate = df_y$high_booking_rate
df_x$high_booking_rate = as.factor(df_x$high_booking_rate)
df_x$review_scores_rating = df_y$review_scores_rating


## Initial organizing

# delete index column since it exists already
# delete "host_total_listings_count" for duplication with "host_listings_count" (checked with other codes)
df_x <- df_x %>% select(-X, -host_total_listings_count)

#check for and drop messy entries
levels(df_x$accommodates)
messy1 = df_x %>% filter(accommodates == 't')
nrow(messy1)
df_x = df_x %>% filter(accommodates != 't')

# delete dollar sign for numeric values
df_x<- df_x %>% 
  mutate(cleaning_fee =  as.numeric(str_remove_all(cleaning_fee, "[$]")), 
         extra_people = as.numeric(str_remove_all(extra_people, "[$]")), 
         host_response_rate = as.numeric(str_remove_all(host_response_rate, "[%]")),
         host_acceptance_rate = as.numeric(str_remove_all(host_acceptance_rate, "[%]")),
         price = as.numeric(str_remove_all(price, "[$]")),
         security_deposit = as.numeric(str_remove_all(security_deposit, "[$]")),
         weekly_price = as.numeric(str_remove_all(weekly_price, "[$]")),
         monthly_price = as.numeric(str_remove_all(monthly_price, "[$]")))

# unify datatype in single columns
df_x$zipcode <- as.numeric(levels(df_x$zipcode)[df_x$zipcode])




## Reload dataset for convenience

# write to csv file 
write.csv(df_x,"MyTrain.csv", row.names = FALSE)

# retrive data which is processed by Python
df = read.csv('df_x1.csv', na.strings='')

# create df2 as back up
df2 = df



## Dealing with missing values

# check the number of missing values
colSums(is.na(df2))

# dropping null for the fillowing columns: 
# 'host_has_profile_pic', 'host_identity_verified', 'host_is_superhost'
# first 3 columns share common rows with null, apply dropping na to all 3 columns doesn't affect the whole dataset much
df2$host_has_profile_pic = as.character(df2$host_has_profile_pic)
df2 = df2 %>% filter(host_has_profile_pic == "t" | host_has_profile_pic == "f")
df2$host_has_profile_pic = as.factor(df2$host_has_profile_pic)

df2$host_identity_verified = as.character(df2$host_identity_verified)
df2 = df2 %>% filter(host_identity_verified == 't' | host_identity_verified == 'f')
df2$host_identity_verified = as.factor(df2$host_identity_verified)

df2$host_is_superhost = as.character(df2$host_is_superhost)
df2 = df2 %>% filter(host_is_superhost == 't' | host_is_superhost == 'f')
df2$host_is_superhost = as.factor(df2$host_is_superhost)

#drop null for 'state', 'property_type'
df2<-df2 %>% drop_na(state)
df2<-df2 %>% drop_na(property_type)

# fill na with 0 for security_deposit
df2$security_deposit = df2$security_deposit %>% replace_na(0)

# fill na with mean for: bathrooms, price, bedrooms, beds, host_response_rate
df2<-
  df2 %>% 
  mutate(bathrooms = ifelse(is.na(bathrooms), mean(bathrooms,na.rm = TRUE),bathrooms),
         price  = ifelse(is.na(price), mean(price,na.rm = TRUE),price),
         beds =  ifelse(is.na(beds), mean(beds,na.rm = TRUE),beds),
         bedrooms =  ifelse(is.na(bedrooms), mean(bedrooms,na.rm = TRUE),beds),
         host_response_rate =  ifelse(is.na(host_response_rate), mean(host_response_rate,na.rm = TRUE),host_response_rate),
  )

# fill na with mode
df2$host_response_time = df2$host_response_time %>% replace_na("within an hour")



## Data cleaning

# cleanning state
df2$state = tolower(df2$state)
df2$state <- as.factor(as.character(df2$state))

## Feature selection

# replace 'host_since' and 'first_review' with number of days since then
# create a new variable to record the time difference between opening and the first review
df2$host_since = as.character(df2$host_since)
df2$host_since = ymd(df2$host_since)

df2$first_review = as.character(df2$first_review)
df2$first_review = ymd(df2$first_review)

df2$diff.time.review <- as.numeric(difftime(df2$first_review, df2$host_since , units="days"))

df2$host_since <- as.numeric(difftime("2019-04-19", df2$host_since, units="days"))
df2$first_review<- as.numeric(difftime("2019-04-19", df2$first_review, units="days"))

#create a new category for missing value in is_business_travel_ready (fill with 'other' to be consistant with test data)
df2$is_business_travel_ready = as.character(df2$is_business_travel_ready)
df2$is_business_travel_ready = df2$is_business_travel_ready %>% replace_na('other')
df2$is_business_travel_ready = as.factor(df2$is_business_travel_ready)

#create a new category for missing value in market (fill with 'other' to be consistant with test data)
df2$market = as.character(df2$market)
df2$market = df2$market %>% replace_na('other')
df2$market = as.factor(df2$market)

#create new variables "is_monthly", "is_weekly" to determine if monthly/weekly prices are available
df2$monthly_price = as.character(df2$monthly_price) %>% replace_na("f")
df2$is_monthly = as.factor(ifelse((df2$monthly_price == 'f'), 'f', 't'))

df2$weekly_price = as.character(df2$weekly_price) %>% replace_na("f")
df2$is_weekly = as.factor(ifelse((df2$weekly_price == 'f'), 'f', 't'))

df2$monthly_price = as.numeric(df2$monthly_price)
df2$weekly_price = as.numeric(df2$weekly_price)

#create new variable to determine whether host shares neighborhood with the house
df2$neighbourhood=as.character(df2$neighbourhood)
df2$host_neighbourhood=as.character(df2$host_neighbourhood)

df2$neighbourhood_same<- ifelse(df2$neighbourhood==df2$host_neighbourhood,1,0)
df2$neighbourhood_same= df2$neighbourhood_same %>% replace_na('unkown')
df2$neighbourhood_same = as.factor(df2$neighbourhood_same)

#create new variable bathroom per bedroom
df2$bath_per_bedroom=df2$bathrooms/(df2$bedrooms+0.01)

#change data type to factor
df2<- df2 %>% 
  mutate(high_booking_rate =as.factor(high_booking_rate), 
         top_travel_city  = as.factor(top_travel_city), 
         top_economic_market = as.factor(top_economic_market),
         TV = as.factor(TV),
         Wifi = as.factor(Wifi),
         AC = as.factor(AC),
         Parking = as.factor(Parking),
         Laundry  = as.factor(Laundry),
         Bathtub = as.factor(Bathtub),
         Pet = as.factor(Pet),
         Kitchen = as.factor(Kitchen))

# write to csv file 
write.csv(df2,'Clean_Train.csv', row.names = FALSE)


