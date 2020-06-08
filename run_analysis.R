filename <- "project.zip"

# read the data
if (!file.exists(filename)){
  download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip",destfile = "project.zip", method = "curl")
  unzip(filename)
  }

##Merges the training and the test sets to create one data set.

#read labels
activityLabels <- read.table("UCI HAR Dataset/activity_labels.txt")

features <- read.table("UCI HAR Dataset/features.txt")

#read test data
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt")
X_test <- read.table("UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("UCI HAR Dataset/test/y_test.txt")

#read train data
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt")
X_train <- read.table("UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("UCI HAR Dataset/train/y_train.txt")

#combine subject, x, and y
test <- cbind(subject_test,X_test,y_test)
train <- cbind(subject_train,X_train, y_train)

#combine train and test

combined <- rbind(test,train)

##Extracts only the measurements on the mean and standard deviation for each measurement.

selectedmeasurements <- c("subject","activity",as.character(features$V2))
mean_std <- grep("subject|activity|mean|std", selectedmeasurements, value = FALSE)
extracted <- combined[ ,mean_std]
                          
##Uses descriptive activity names to name the activities in the data set
names(activityLabels) <- c("activityNumber", "activityName")
#combined$V1.1 <- activityLabels$activityName[combined$V1.1]


##Appropriately labels the data set with descriptive variable names.
reducedNames <- selectedmeasurements[mean_std]    # Names after subsetting
reducedNames <- gsub("mean", "Mean", reducedNames)
reducedNames <- gsub("std", "Std", reducedNames)
reducedNames <- gsub("gravity", "Gravity", reducedNames)
reducedNames <- gsub("[[:punct:]]", "", reducedNames)
reducedNames <- gsub("^t", "time", reducedNames)
reducedNames <- gsub("^f", "frequency", reducedNames)
reducedNames <- gsub("^anglet", "angleTime", reducedNames)
names(extracted) <- reducedNames 

##From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

newData<-aggregate(. ~subject + activity, extracted, mean)
newData<-newData[order(newData$subject,newData$activity),]
write.table(newData, file = "tidydata.txt",row.name=FALSE,quote = FALSE)
