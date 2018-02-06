# load featured data from FeatureEngineering
source("FeatureEngineering.R")

# load libraries
library(caret)


# split data back into train and test set
train = featuredData[which(featuredData[["Dataset"]]=="Train"), ] %>% select(-Dataset)
test = featuredData[which(featuredData[["Dataset"]]=="Test"), ] %>% select(-Dataset)

# create training and evaluation datasets
trainingIndex = createDataPartition(
  train[["Survived"]],
  p = 0.7,
  list = FALSE,
  times = 1
)

trainingData = train[trainingIndex, ]
evaluationData = train[-trainingIndex, ]

# remove feature data from memory
rm(featuredData)

gbmGrid <-  expand.grid(interaction.depth = c(1, 5, 9), 
                        n.trees = (1:30)*10, 
                        shrinkage = 0.1,
                        n.minobsinnode = 20)

fitControl <- trainControl(## 10-fold CV
  method = "repeatedcv",
  number = 10,
  ## repeated ten times
  repeats = 10)

set.seed(825)
gbmFit1 <- train(Survived ~ ., data = trainingData, 
                 method = "gbm", 
                 trControl = fitControl,
                 ## This last option is actually one
                 ## for gbm() that passes through
                 verbose = FALSE,
                 tuneGrid = gbmGrid)
gbmFit1





