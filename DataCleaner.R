# clean the raw data from DataLoader here

# load rawData from DataLoader
source("DataLoader.R")

# convert columns to correct types
rawData[["Survived"]] = as.factor(rawData[["Survived"]])
rawData[["Embarked"]] = as.character(rawData[["Embarked"]])
rawData[["Name"]] = as.character(rawData[["Name"]])
rawData[["Pclass"]] = as.character(rawData[["Pclass"]])

# function to fill in missing values in a column witht the mean value of that column
MeanValueNaFill = function(dataFrame, column) {
  # calculate mean value of column
  meanValue = mean(dataFrame[[column]][which(!is.na(dataFrame[[column]]))])
  
  dataFrame[[column]][which(is.na(dataFrame[[column]]))] = meanValue
  
  return(dataFrame)
  
}

# fill in missing values of age and fare with their mean values
cleanData = MeanValueNaFill(MeanValueNaFill(rawData, "Fare"), "Age")

# fill in missing value of embarked with 'S'
cleanData[["Embarked"]][which(cleanData[["Embarked"]] == "")] = "S"

# remove rawData and MeanValueFill from memory
rm(rawData, MeanValueNaFill)

# garbage cleanup
gc()
