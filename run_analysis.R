library(dplyr)
library(data.table)

download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip",
              destfile="C:/Users/Matt/datasciencecoursera/Cleaning Data/")

setwd("C:/Users/Matt/datasciencecoursera/Cleaning Data/UCI HAR Dataset")

# Load all data into frames
features <- tbl_df(fread("features.txt", col.names = c("n", "name")))
activity <- tbl_df(fread("activity_labels.txt", col.names = c("code","activity")))
X_test <- fread("test/X_test.txt", col.names=features$name)
subject_test <-tbl_df(fread("test/subject_test.txt", col.names = "subject"))
y_test <- tbl_df(fread("test/y_test.txt",col.names = "code"))
X_train <- fread("train/X_train.txt", col.names=features$name)
subject_train <-tbl_df(fread("train/subject_train.txt", col.names = "subject"))
y_train <- tbl_df(fread("train/y_train.txt",col.names = "code"))

# stack test and train data columns
y <- rbind(y_test, y_train)
x <- rbind(X_test, X_train)
subject <- rbind(subject_test, subject_train)

# check for equal row numbers 
dim(x)[1] == dim(y)[1] & dim(x)[1] == dim(subject)[1]

# Bind all data into one frame
DF<-cbind(subject, y, x)

# Fix duplicate names by adding row index prefix, except for "subject" and "code"
colnames(DF)[-(1:2)]<-paste(seq_along(colnames(DF))[-(1:2)], colnames(DF)[-(1:2)], sep = "")

# Convert to tibble
DF<-tbl_df(DF)

# Extracts only mean and std. dev. measurements for each variable
DF <- select(DF, subject, code, contains("mean"), contains("std"))

# Add activity name into data set
DF<-merge(activity, DF, by="code")

# Renames variables for readability and clarity
names(DF) <- gsub("Acc", "Accelerometer", names(DF))
names(DF) <- gsub("Gyro", "Gyroscope", names(DF))
names(DF) <- gsub("^[0-9]([0-9])?([0-9])?", "", names(DF))
names(DF) <- gsub("mean", "Mean", names(DF))
names(DF) <- gsub("Mean", "_Mean", names(DF))
names(DF) <- gsub("gravityMean", "gravity_Mean", names(DF))
names(DF) <- gsub("()", "", names(DF), fixed=TRUE)
names(DF) <- gsub("-", "_", names(DF), fixed=TRUE)
names(DF) <- gsub("Mag", "Magnitude", names(DF), fixed=TRUE)
names(DF) <- gsub("Magnitude", "_Magnitude", names(DF))
names(DF) <- gsub("std", "STD", names(DF), fixed=TRUE)
names(DF) <- gsub("Freq", "Frequency", names(DF))
names(DF) <- gsub("^t", "Time_", names(DF))
names(DF) <- gsub("^f", "Frequency_", names(DF))
names(DF) <- gsub("tBody", "Time_Body", names(DF))
names(DF) <- gsub("Jerk", "_Jerk", names(DF))
names(DF) <- gsub("__", "_", names(DF))

# creates new table containing means of all variables in DF
DF5<-group_by(DF, subject, activity)
DF5<-summarize_all(DF5, funs(mean))

# Outputs DF5 to txt file
write.table(DF5, file = "./Final_Data.txt", row.names = FALSE, col.names = TRUE)