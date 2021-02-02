library(tidyverse)
library(readxl)

library(h2o)

# 1. Data load ------------------------------------------------------------

data <- read_csv("data/creditcard.csv")
# 불필요 데이터 제거
data <- data %>%
  select(-Time)

# ID 추가
data$Id = 1:nrow(data)
data$Class = factor(data$Class)

# data의 20% 는 test set으로 사용

train_test_split <- function(data, r, seed = 2021){
  set.seed(seed)
  n = nrow(data)
  idx = sample(1:n, round(n * r))
  train_data = data[idx, ]
  test_data = data[-idx, ]
  
  return(list(train_data, test_data))
} 
train_test_split(data, 0.8)

h2o.init()
h2o_data = as.h2o(data)
h2o_split_data = h2o.splitFrame(h2o_data, ratios = 0.8, seed = 1234)

train = h2o_split_data[[1]]
test = h2o_split_data[[2]]

predictors = colnames(train) %>% 
  setdiff(c("Id", "Class"))
response = "Class"
idx = h2o.which(train[,"Class"] == "1") %>% 
  as_tibble() %>% 
  Unexpected CURL error: Empty reply from server
  |=========================================                
  .[1:100, "C1"] %>% 
  .$C1

start_time = Sys.time()
print(start_time)
aml <- h2o.automl(x = predictors, y = response,
                  training_frame = train[c(1:500,idx),],
                  max_models = 20,
                  seed = 1234)
end_time = Sys.time()
print(end_time - start_time)

lb <- aml@leaderboard
print(lb, n = nrow(lb))
