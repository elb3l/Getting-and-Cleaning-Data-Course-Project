## You should find what is your Working directory?.. Use getwd()
## to change your Working directory. setwd("Path to your working directory")

##first step to obtain the raw data for the analysis
## if have manualy download & Extract the raw data skip this code snippet

        fileurl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
        download.file(fileurl,destfile="rawdata.zip")
        
        ## the folowing line will only work if you have unzip installed.
        try(system("unzip -o rawdata.zip", intern = TRUE))
        ## if you don't have unzip installed. do it manualy using any unzip programe you have.

## Make sure that extracted raw data in your working directory under folder "UCI HAR Dataset"


##[4] Appropriately labels the data set with descriptive activity names.
## load the features in R using read.table in to features df
        
        features_Path <- "./UCI HAR Dataset/features.txt"
        features <- read.table(features_Path, header = FALSE, sep = "")
        ##setting the names att for features
        names(features) <- c("col.index", "col.name")
        ##take a backup from features in to features.old, it will be useful later in creating the CodeBook
        features.Old <- features

        ##Transform Non Descriptive Activity Labels into Descriptive Activity Labels
        
        features$"col.name" <- gsub("\\()", "",features$"col.name")
        features$"col.name" <- gsub("std", "STD",features$"col.name")
        features$"col.name" <- gsub("meanFreq", "AVG.Frequency",features$"col.name")
        features$"col.name" <- gsub("mean", "AVG",features$"col.name")
        features$"col.name" <- gsub("fBodyBodyGyroJerkMag", "Frequency.Body.Body.Gyroscope.Jerk.Magnitude", features$"col.name")
        features$"col.name" <- gsub("fBodyBodyAccJerkMag", "Frequency.Body.Body.Accelerometer.Jerk.Magnitude", features$"col.name")
        features$"col.name" <- gsub("fBodyBodyGyroMag", "Frequency.Body.Body.Gyroscope.Magnitude", features$"col.name")
        features$"col.name" <- gsub("tBodyGyroJerkMag", "Time.Body.Gyroscope.Jerk.Magnitude", features$"col.name")
        features$"col.name" <- gsub("tBodyAccJerkMag", "Time.Body.Accelerometer.Jerk.Magnitude", features$"col.name")
        features$"col.name" <- gsub("tGravityAccMag", "Time.Gravity.Accelerometer.Magnitude", features$"col.name")
        features$"col.name" <- gsub("tBodyGyroJerk", "Time.Body.Gyroscope.Jerk", features$"col.name")
        features$"col.name" <- gsub("fBodyAccJerk", "Frequency.Body.Accelerometer.Jerk", features$"col.name")
        features$"col.name" <- gsub("tBodyAccJerk", "Time.Body.Accelerometer.Jerk", features$"col.name")
        features$"col.name" <- gsub("tBodyGyroMag", "Time.Body.Gyroscope.Magnitude", features$"col.name")
        features$"col.name" <- gsub("fBodyAccMag", "Frequency.Body.Accelerometer.Magnitude", features$"col.name")
        features$"col.name" <- gsub("tBodyAccMag", "Time.Body.Accelerometer.Magnitude", features$"col.name")
        features$"col.name" <- gsub("tGravityAcc", "Time.Gravity.Accelerometer", features$"col.name")
        features$"col.name" <- gsub("fBodyGyro", "Frequency.Body.Gyroscope", features$"col.name")
        features$"col.name" <- gsub("tBodyGyro", "Time.Body.Gyroscope", features$"col.name")
        features$"col.name" <- gsub("fBodyAcc", "Frequency.Body.Accelerometer", features$"col.name")
        features$"col.name" <- gsub("tBodyAcc", "Time.Body.Accelerometer", features$"col.name")
        features$"col.name" <- gsub("-", ".",features$"col.name")


## load the features in R using read.table in to activity_labels df
        activity_labels <- "./UCI HAR Dataset/activity_labels.txt"
        activity_labels <- read.table(activity_labels, header = FALSE, sep = "")
        ##setting the names att for activity_labels
        names(activity_labels) <- c("Activity.Id", "Activity.Labels")

##---------------------------------------------------------------------------------------------

## load the subject_train in R using read.table into subject_train df
        subject_train_Path <- "./UCI HAR Dataset/train/subject_train.txt"
        subject_train <- read.table(subject_train_Path, header = FALSE, sep = "")

## load the y_train in R using read.table into y_train df
        y_train_Path <- "./UCI HAR Dataset/train/y_train.txt"
        y_train <- read.table(y_train_Path, header = FALSE, sep = "")

## load the X_train in R using read.table into X_train df
        X_train_Path <- "./UCI HAR Dataset/train/X_train.txt"
        X_train <- read.table(X_train_Path, header = FALSE, sep = "")

        ##setting the names att for X_train using features$"col.name"
        names(X_train) <- features$"col.name"

        ## compine subject_train , y_train and new column indicate the source dataset
        Subject.Activity <- cbind(subject_train, y_train, "Train")
        ##setting the names att for Subject.Activity
        names(Subject.Activity) <- c("Subject.Id","Activity.Id", "Train.Test.Group")
        ## compine Subject.Activity , X_train into X_train_Full df
        X_train_Full <- cbind(Subject.Activity, X_train)



##---------------------------------------------------------------------------------------------

## load the subject_test in R using read.table into subject_test df
        subject_test_Path <- "./UCI HAR Dataset/test/subject_test.txt"
        subject_test <- read.table(subject_test_Path, header = FALSE, sep = "")

## load the y_test in R using read.table into y_test df
        y_test_Path <- "./UCI HAR Dataset/test/y_test.txt"
        y_test <- read.table(y_test_Path, header = FALSE, sep = "")

## load the X_test in R using read.table into X_test df
        X_test_Path <- "./UCI HAR Dataset/test/X_test.txt"
        X_test <- read.table(X_test_Path, header = FALSE, sep = "")

        ##setting the names att for X_test using features$"col.name"
        names(X_test) <- features$"col.name"

        ## compine subject_test , y_test and new column indicate the source dataset
        Subject.Activity <- cbind(subject_test, y_test, "test")
        ##setting the names att for Subject.Activity
        names(Subject.Activity) <- c("Subject.Id","Activity.Id", "Train.Test.Group")
        ## compine Subject.Activity , X_test into X_test_Full df
        X_test_Full <- cbind(Subject.Activity, X_test)

##---------------------------------------------------------------------------------------------

##[1] Merges the training and the test sets to create one data set.
        train_test <- rbind(X_train_Full,X_test_Full)


##[2] Extracts only the measurements on the mean and standard deviation for each measurement.
##create character vector to filter only mean and standard deviation measurements.

        col.index <- names(train_test)
        ##create logical vector to filter only mean and standard deviation measurements.
        filter_features <- grepl("Subject.Id", col.index) | grepl("Activity.Id", col.index) | grepl("Train.Test.Group", col.index) | grepl("AVG", col.index) | grepl("STD", col.index)
        train_test_Filtered <- train_test[,filter_features]

##[3] Uses descriptive activity names to name the activities in the data set
        Tidy_Data <- merge(train_test_Filtered,activity_labels,by="Activity.Id")
        Tidy_Data <- Tidy_Data[,c(2,3,83,4:82),]


##[5] Creates a second, independent tidy data set with the average of each variable for each activity and each subject.

        ## the below function will create a second data set for averages
        create_AGG_Tidy_Data <- function()
        {
                ## create empty data frame to insert our calcuation per subject & Activity
                AGG_Tidy_Data <<- data.frame() ## genral defind df
                ## Split the data into list by subject & Activity note the length of this list 180 (30 subject, 6 activies)
                Split_Tidy_Data <- split(Tidy_Data, Tidy_Data[,c(1,3)])
                ##for each subset data frame in the list we will calculate the averages and append it into AGG_Tidy_Data df 
                for(i in 1:length(Split_Tidy_Data))
                {
                        ## using colMeans, rbind we will append the results of each subset into AGG_Tidy_Data
                        AGG_Tidy_Data <<- rbind(AGG_Tidy_Data,as.data.frame(c(unique(Split_Tidy_Data[[i]][,1:3]), colMeans(Split_Tidy_Data[[i]][,4:82]))))        
                }
                
        }
        create_AGG_Tidy_Data()

## compare old Non.Descriptive.Activity.Labels to new Descriptive.Activity.Labels 
        CodeBook <- merge(features.Old,features,by="col.index")
        CodeBook <- CodeBook[grepl("AVG", CodeBook[,3]) | grepl("STD", CodeBook[,3]),]
        names(CodeBook) <- c("Raw.Data.Column.Index", "Non.Descriptive.Activity.Labels", "Descriptive.Activity.Labels")

##Extract our findings
        write.table(CodeBook, file = "CodeBook.txt", sep = ",",quote = FALSE, row.names = FALSE)
        write.table(Tidy_Data, file = "Tidy_Data.txt", sep = ",",quote = FALSE, row.names = FALSE)
        write.table(AGG_Tidy_Data, file = "AGG_Tidy_Data.txt", sep = ",",quote = FALSE, row.names = FALSE)
