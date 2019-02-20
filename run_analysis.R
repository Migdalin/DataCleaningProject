
DataDirectory <- "UCI HAR Dataset"

LoadPackages <- function() {
    library(dplyr)
    library(reshape2)
}

#
# Downloand and upzip source data.
#
AcquireData <- function() {
    url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
    destFilename <- "UciHar.zip"
    if(!file.exists(destFilename)) {
        download.file(url, destFilename, mode="wb")
        unzip(destFilename)
    }
    invisible(NA)
}

#
#  Helper method for step 1: make tidy column
#  names for merged dataset
#
GetTidyColumnNames <- function() {
    featureInfo <- read.table(file.path(DataDirectory, 
                              "features.txt"))
    
    # Fix duplicate naming issue
    colNames <- paste(featureInfo$V2, featureInfo$V1, sep="")
    
    # all lower case makes the result unreadable, IMHO
    # colNames <- tolower(colNames)
    colNames <- gsub("[^[:alnum:]]", "", colNames)
    
    return(colNames)
}

#
#  Step 1:  Merge the training and the test sets to create one 
#   data set.
#
GetSingleMergedDataset <- function() {
    # Get names of columns in X_* datasets
    colNames <- GetTidyColumnNames()
    
    # Training Data
    trainPath <- file.path(DataDirectory, "train")
    X_train <- read.table(file.path(trainPath, "X_train.txt"))
    colnames(X_train) <- colNames
    
    y_train <- read.table(file.path(trainPath, "y_train.txt"))
    colnames(y_train) <- "activity"

    subject_train <- read.table(file.path(trainPath, "subject_train.txt"))
    colnames(subject_train) <- "subject"
    
    allTrainingData <- cbind(X_train, y_train)
    allTrainingData <- cbind(allTrainingData, subject_train)
    
    # Test Data
    testPath <- file.path(DataDirectory, "test")
    X_test <- read.table(file.path(testPath, "X_test.txt"))
    colnames(X_test) <- colNames
    
    y_test <- read.table(file.path(testPath, "y_test.txt"))
    colnames(y_test) <- "activity"

    subject_test <- read.table(file.path(testPath, "subject_test.txt"))
    colnames(subject_test) <- "subject"
    
    allTestData <- cbind(X_test, y_test)
    allTestData <- cbind(allTestData, subject_test)
    
    # Merge
    mergedData <- merge(allTrainingData, allTestData, all=TRUE)
    return(mergedData)
}

# 
#  Step 2:  Extract only the measurements on the mean and 
#  standard deviation for each measurement.
# 
GetMeanAndStdMeasurements <- function(mergedData) {
    meanAndStd <- mergedData[,grepl("mean|std|subject|activity", colnames(mergedData))]
    return(meanAndStd)
}

# 
#  Step 3: Use descriptive activity names to name the activities 
#  in the data set 
#
ApplyDescriptiveActivityNames <- function(mergedData) {
    # Get tidy activity names
    activities <- read.table(file.path(DataDirectory, "activity_labels.txt"))
    activities$V2 <- tolower(activities$V2)
    activities$V2 <-gsub("[^[:alnum:]]", "", activities$V2)
    
    mergedData$activity <- sapply(mergedData$activity,
                                  function(a) activities$V2[a])
    
    mergedData$activity <- as.factor(mergedData$activity)
    return(mergedData)
}

# 
#  Step 4:  Appropriately label the data set with descriptive 
#  variable names
#
AssignDescriptiveVariableNames <- function(mergedData)  {
    # Already done  as part of Step 1, merging the data.
    # y$V1 became "activity", and subject$V1 became "subject."
    #
    # The column names were rendered tidy by removal of "()", "-",
    # etc.
    #
    # Given the length of some of the column names already,
    # I hesitate to expand the various abbreviations.
    #
    # Originally I had converted the column names to all lower case,
    # but the result seemed unreadable.  I know that camel casing
    # that was deprecated in the lecture, but looking at the names
    # in that format made my head hurt, so I left the columns in 
    # mixed case, though with all non-alphanumeric characters removed.
    return(mergedData)
}


#
# Step 5: creates a second, independent tidy data set 
# with the average of each variable for each activity 
# and each subject.
#
GetAverageByActivityAndSubject <- function(mergedData) {
    # averagedData <- mergedData %>% 
    #     group_by(subject, activity) %>%
    #     summarise_all(funs(mean))  
    
    meltedData <- melt(mergedData, id.vars=c("activity", "subject"))
    castData <- dcast(meltedData, 
                      formula=activity+subject ~...,
                      mean)
}

WriteTidyData <- function(tidyData) {
    write.table(tidyData, "tidyData.txt", row.names = FALSE)
    invisible(NA)
}


#
#  Performs the required steps in a slightly altered order,
#  so that friendly activity names are applied prior to 
#  splitting the dataset.
#
AssignmentMain <- function() {
    
    # Prep
    LoadPackages()
    AcquireData()

    # Step 1
    mergedData <- GetSingleMergedDataset()
    
    # Step 3:  Seems to make more sense to pretty the activity
    # names before splitting off a separate data set.
    meergedData <- ApplyDescriptiveActivityNames(mergedData)
    
    # Step 2:  Get filtered list of columns.
    mergedData <- GetMeanAndStdMeasurements(mergedData)
    
    # Step 4
    mergedData <- AssignDescriptiveVariableNames(mergedData)
    
    # Step 5
    tidyData <- GetAverageByActivityAndSubject(mergedData)
    WriteTidyData(tidyData)
    
    return("Success!")
}

