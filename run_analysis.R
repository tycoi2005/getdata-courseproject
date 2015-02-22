#data https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 

library(reshape2)
# go to directory
setwd("UCI HAR Dataset")
# load label, data col names
labels <- read.table("activity_labels.txt")
names(labels) <- c("id","label")
features <- read.table("features.txt")
names(features) <- c("id","feature")
filterFeatures <- grep(".*mean\\(\\)|.*std\\(\\)", features$feature)

# load all data
testY <- read.table("test/y_test.txt", header=F, col.names=c("label"))
testS <- read.table("test/subject_test.txt", header=F, col.names=c("subject"))
testX <- read.table("test/X_test.txt", header=F, col.names=features$feature)
trainY <- read.table("train/y_train.txt", header=F, col.names=c("label"))
trainS <- read.table("train/subject_train.txt", header=F, col.names=c("subject"))
trainX <- read.table("train/X_train.txt", header=F, col.names=features$feature)
#Extracts only the measurements on the mean and standard deviation for each measurement. 
testX <- testX[,filterFeatures]
trainX <- trainX[,filterFeatures]

#Merges the training and the test sets to create one data set.
testData <- cbind(testS, testY, testX)
trainData <- cbind(trainS, trainY, trainX)
data <- rbind(testData,trainData)
#Appropriately labels the data set with descriptive variable names.  
data$label <- labels[data$label,2]
# From the data set in step 4, creates a second, independent tidy data set with the average 
# of each variable for each activity and each subject.
idLabels   <- c("subject", "label")
dataLabels <- setdiff(colnames(data), idLabels)
meltData <- melt(data, id = idLabels, measure.vars = dataLabels)
tidyData <- dcast(meltData, label + subject ~ variable, mean)
names <- names(tidyData)
tidyNames <- gsub("[^[:alpha:]]", "", names)
names(tidyData) <- tidyNames
# write to file
write.table(tidyData, file = "./tidy_data.txt", row.name=FALSE)
