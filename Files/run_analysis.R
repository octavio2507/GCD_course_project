#Getting and cleaning data course project

##Student's Name: Octavio Reyes Matte

#Create a working space for the data
if(!file.exists("FinalProject_GCD")){
  dir.create("FinalProject_GCD")
}

#Download the file containing the data
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

download.file(fileUrl, destfile = "FinalProject_GCD/file.zip")

#Since the downloaded file is a .zip file, we must extract the compressed data
unzip("FinalProject_GCD/file.zip", exdir="FinalProject_GCD/unzipfolder")

# Read the features that will make most of the names on the dataframe

features <- read.table("FinalProject_GCD/unzipfolder/UCI HAR Dataset/features.txt", header = F, sep=" ")
features <- as.character(features[,2])

# Read the training data
trainingX <- read.table("FinalProject_GCD/unzipfolder/UCI HAR Dataset/train/X_train.txt")
trainingY <- read.table("FinalProject_GCD/unzipfolder/UCI HAR Dataset/train/y_train.txt", header = F, sep=" ")
trainingSubject <- read.table("FinalProject_GCD/unzipfolder/UCI HAR Dataset/train/subject_train.txt", header = F, sep=" ")

#Merge them into a single data frame and assign the column names
training_data <- data.frame(trainingSubject, trainingY, trainingX)
names(training_data) <- c(c('Subject', 'Activity'), features)

#Do the same process to the test data

testingX <- read.table("FinalProject_GCD/unzipfolder/UCI HAR Dataset/test/X_test.txt")
testingY <- read.table("FinalProject_GCD/unzipfolder/UCI HAR Dataset/test/y_test.txt", header = F, sep=" ")
testingSubject <- read.table("FinalProject_GCD/unzipfolder/UCI HAR Dataset/test/subject_test.txt", header = F, sep=" ")

testing_data <- data.frame(testingSubject, testingY, testingX)
names(testing_data) <- c(c('Subject', 'Activity'), features)

## 1) Merge the training and testing datasets to create one data set

dataFull <- rbind(training_data, testing_data)

# 2)Extracts only the measurements on the mean and standard deviation 
## for each measurement. 

#If you check the names, you can see that some have "mean" and others "std"
names(dataFull)

mean_std <- grep("mean|std", features)

#Subset the data 

dataSubset <- dataFull[,c(1,2, mean_std)]

## 3) Uses descriptive activity names to name the activities in the data set

#In the data folder, there is an activity file 
#that associates a number with an action

activities <- read.table("FinalProject_GCD/unzipfolder/UCI HAR Dataset/activity_labels.txt", header = F, sep=" ")

activities <- as.character(activities[,2])

dataSubset$Activity <- activities[dataSubset$Activity]

## 4) Appropriately labels the data set with descriptive variable names. 

#Create a new object for the names

names_new <- names(dataSubset)

#Use the gsub function to change the different parts of the names

names_new <- gsub("[(][)]", "", names_new)
names_new <- gsub("Acc", "_Acceleration", names_new)
names_new <- gsub("Gyro", "_Gyroscope", names_new)
names_new <- gsub("Mag", "_Magnitude", names_new)
names_new <- gsub("^t", "TimeDomain_", names_new)
names_new <- gsub("^f", "FrequencyDomain_", names_new)
names_new <- gsub("-mean", "_Mean", names_new)
names_new <- gsub("-std", "_StandardDeviation", names_new)
names_new <- gsub("-", "_", names_new)

#Change names in the dataset

names(dataSubset) <- names_new

## 5) From the data set in step 4, creates a second, independent tidy data set 
## with the average of each variable for each activity and each subject.

tidyDataset <- aggregate(dataSubset[,3:81], by = list(Activity = dataSubset$Activity, Subject = dataSubset$Subject),FUN = mean)

#Save the dataset (as a RDS, csv or format of your choice)

saveRDS(tidyDataset, "FinalProject_GCD/tidyData.rds")
write.csv(tidyDataset, "FinalProject_GCD/tidyData.csv")
write.table(tidyDataset, "FinalProject_GCD/tidyData.txt", row.names = FALSE)

