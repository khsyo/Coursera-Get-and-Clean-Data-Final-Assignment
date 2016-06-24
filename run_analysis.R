library("reshape2")

filename <- "getdata_dataset.zip"

## Download and unzip the dataset:
if (!file.exists(filename)){
  fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip "
  download.file(fileURL, filename, method="curl")
}  
if (!file.exists("UCI HAR Dataset")) { 
  unzip(filename) 
}

##Tidy up data for test portion

test <- read.table("UCI HAR Dataset/test/X_test.txt")
testActivities <- read.table("UCI HAR Dataset/test/Y_test.txt")
testSubjects <- read.table("UCI HAR Dataset/test/subject_test.txt")
data_test <- cbind(testSubjects, testActivities, test)               

featurespath <- "UCI HAR Dataset/features.txt"
features <- read.table(featurespath)                        #read features.txt
features_vector <- features[,2]                             #extract features as a vector
features_vector <- as.character(features_vector)            


colnames(data_test) <- c("Subject", "Activity", features_vector)  #set column names for the data set 

##Work on train portion, similar to "test"

train <- read.table("UCI HAR Dataset/train/X_train.txt")
trainActivities <- read.table("UCI HAR Dataset/train/Y_train.txt")
trainSubjects <- read.table("UCI HAR Dataset/train/subject_train.txt")
data_train <- cbind(trainSubjects, trainActivities, train)

colnames(data_train) <- c("Subject", "Activity", features_vector)  #set column names for the data set 

##Merge the two dataset into one

full_data <- rbind(data_test, data_train)
new_data <- full_data[,grep("(.*)mean(.*)|(.*)std(.*)|Subject|Activity|Category", names(full_data))]

activitylabelpath <- "UCI HAR Dataset/activity_labels.txt"
activity_label <- read.table(activitylabelpath)

##Label the activity

new_data$Activity <- factor(new_data$Activity, levels = activity_label[,1], labels = activity_label[,2])
new_data$Category <- NULL
new_data$Subject <- as.factor(new_data$Subject)

##Summarize the data by average

new_data_melted <- melt(new_data, id = c("Subject", "Activity"))
new_data_mean <- dcast(new_data_melted, Subject+Activity~variable, mean)

##Output the data

write.table(new_data_mean, "tidy.txt", row.names = F, quote = F)







