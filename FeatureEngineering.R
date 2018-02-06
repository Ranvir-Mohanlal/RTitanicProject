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

# function to create family id
FamilyId = function(dataFrame) {
  
  # add family size field
  dataFrame[["FamilySize"]] = dataFrame[["Parch"]] + dataFrame[["SibSp"]] + 1
  
  # add surname field
  dataFrame[["Surname"]] = sapply(dataFrame[["Name"]], function(x) {
    gsub(" ", "", strsplit(x, ",")[[1]][1])
  })
  
  # create family id field
  dataFrame[["FamilyId"]] = paste0(dataFrame[["FamilySize"]], dataFrame[["Surname"]])
  
  # remove family size and surname fields
  dataFrame = dataFrame[, !(colnames(dataFrame) %in% c("Surname"))]
  
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

# function to drop unnecessary columns
ColumnDropper = function(dataFrame) {
  
  dataFrame = dataFrame[, !(colnames(dataFrame) %in% c("Name", "SipSp", "Parch", "Ticket", "Cabin"))]
  
}


# create title field and convert fields to binary
featuredData = ColumnDropper(Binarizer(TitleField(cleanData), c("Title", "Pclass", "Embarked", "Sex")))

# remove cleanData, TitleField and Binarizer from memory
rm(cleanData, TitleField, FamilyId, Binarizer, ColumnDropper)

# garbage cleanup
gc()