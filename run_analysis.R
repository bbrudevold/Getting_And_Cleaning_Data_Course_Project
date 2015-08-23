# Getting and Cleaning Data Course Project

# data was downloaded from this link and save to "UCI HAR Dataset" folder
# https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

library(plyr)
library(reshape2)

# read feature list and rename columns to be more descriptive
features <- read.table("./UCI HAR Dataset/features.txt",stringsAsFactors=FALSE)
names(features)[1] <- "index"
names(features)[2] <- "feature"

# read activity list and rename columns to be more descriptive
activities <- read.table("./UCI HAR Dataset/activity_labels.txt",stringsAsFactors=FALSE)
names(activities)[1] <- "index"
names(activities)[2] <- "label"

# read test data
subjectTest <- read.table("./UCI HAR Dataset/test/subject_test.txt")
xTest <- read.table("./UCI HAR Dataset/test/X_test.txt")
yTest <- read.table("./UCI HAR Dataset/test/Y_test.txt")

# read training data
subjectTrain <- read.table("./UCI HAR Dataset/train/subject_train.txt")
xTrain <- read.table("./UCI HAR Dataset/train/X_train.txt")
yTrain <- read.table("./UCI HAR Dataset/train/Y_train.txt")

# rename subject and activity columns 
names(subjectTest)[1] <- "subject"
names(yTest)[1] <- "activity"
names(subjectTrain)[1] <- "subject"
names(yTrain)[1] <- "activity"

# rename all feature columns
names(xTest) <- features$feature
names(xTrain) <- features$feature

# merge all test data to a single data frame
testData <- data.frame(subjectTest,yTest,xTest)

# merge all training data to a single data frame
trainData <- data.frame(subjectTrain,yTrain,xTrain)

# Merge the training and the test sets to create one data set
allData = merge(testData,trainData,all=TRUE,sort=FALSE)

# find only fields with mean or standard deviation measurements by searching the field titles
# need to add 2 to the column number because of the subject and activity fields at the start of the data frame
stdEntries <-grepl(c("std"),features$feature) 
meanEntries <-grepl(c("mean"),features$feature) 
stdOrMeanEntries <- stdEntries | meanEntries
columnNumList <- which(stdOrMeanEntries)+2

# Extract only the measurements on the mean and standard deviation for each measurement. 
filteredData <-allData[,c(1,2,columnNumList)]

# Use descriptive activity names to name the activities in the data set
# read the activity label which matches the number from the activity list
filteredData$activity <- sapply(filteredData$activity, function(x) activities$label[x])

# melt the data using subject and activity as ID
meltedData <- melt(filteredData,id=c("subject","activity"),measure.vars=names(filteredData)[3:ncol(filteredData)])

# cast the data to form a table showing mean of each measurement for each combination of subject and activity
meanData <- dcast(meltedData, subject + activity ~ variable,mean)

# write the output
write.table(meanData, "tidyOutput.txt",row.name=FALSE )