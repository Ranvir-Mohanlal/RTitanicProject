# create data features here

# load clean data from DataCleaner
source("DataCleaner.R")

# function to create title field
TitleField = function(dataFrame) {
  
  # create title field from name field
  dataFrame[["Title"]] = sapply(dataFrame[["Name"]], function(x) {
    gsub(" ", "", strsplit(strsplit(x, ",")[[1]][2], "[.]")[[1]][1])
  })
  
  return(dataFrame)
  
}

# function to convert input columns in input data frame to binary
Binarizer = function(dataFrame, columns) {
  
  for(column in columns) {
    
    # create list of unique values in column
    uniqueValues = unique(dataFrame[[column]])
    
    for(value in uniqueValues) {
      
      dataFrame[[paste0(column, "_", value)]] = sapply(dataFrame[[column]], FUN = function(x) {
        ifelse(x == value, 1, 0)
      })
      
    }
    
    # remove column
    dataFrame = dataFrame[, !(colnames(dataFrame) %in% (column))]
    
  }
  
  return(dataFrame)
  
}

# create title field and convert fields to binary
featuredData = Binarizer(TitleField(cleanData), c("Title", "Pclass", "Embarked"))

# remove cleanData, TitleField and Binarizer from memory
rm(cleanData, TitleField, Binarizer)
