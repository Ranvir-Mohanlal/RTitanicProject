# load raw data here

# libraries
library(dplyr)

# load train dataset and add train data label
train = read.csv("./resources/train.csv") %>% mutate("Dataset" = "Train")

# load test dataset and add survived column and test data label
test = read.csv("./resources/test.csv") %>% mutate("Survived" = 1, "Dataset" = "Test")

# join train and test
rawData = rbind(train, test)

# remove train and test from memory
rm(train, test)

# garbage cleanup
gc()