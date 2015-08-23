## Course Project for "Getting & Cleaning Data"
## Curtis Kaminski

## install libraries

install.packages("reshape2")
library(reshape2)

## set working directory

setwd("D:/Document/RProgramming/getting&cleaningdata")

## read in data from web

webpage <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
data <- "Project Data"
download.file(webpage,data)

## uncompress data

unzip (data, exdir ="D:/Document/RProgramming/getting&cleaningdata")

## change directory to data directory

setwd("D:/Document/RProgramming/getting&cleaningdata/UCI HAR Dataset")

## Read in Train & Test Data

## read in train data
subject_train <- read.csv("D:/Document/RProgramming/getting&cleaningdata/UCI HAR Dataset/train/subject_train.txt", header= FALSE)
X_train <- read.csv("D:/Document/RProgramming/getting&cleaningdata/UCI HAR Dataset/train/X_train.txt", sep = "", header = FALSE)
Y_train <- read.csv("D:/Document/RProgramming/getting&cleaningdata/UCI HAR Dataset/train/Y_train.txt", header = FALSE)

## read in test data
subject_test <- read.csv("D:/Document/RProgramming/getting&cleaningdata/UCI HAR Dataset/test/subject_test.txt", header= FALSE)
X_test <- read.csv("D:/Document/RProgramming/getting&cleaningdata/UCI HAR Dataset/test/X_test.txt", sep = "", header = FALSE)
Y_test <- read.csv("D:/Document/RProgramming/getting&cleaningdata/UCI HAR Dataset/test/Y_test.txt", header = FALSE)

## ad column names to X_train and X_test

features <- read.csv("D:/Document/RProgramming/getting&cleaningdata/UCI HAR Dataset/features.txt", sep="", header = FALSE)
features <- features[,2]

## add column names to train & test

colnames(X_train) <- features
colnames(X_test) <- features

## add factor level labels to Y_train and Y_test

activity_labels <- read.csv("D:/Document/RProgramming/getting&cleaningdata/UCI HAR Dataset/activity_labels.txt", sep = "", header = FALSE)
activity_labels <- activity_labels[,2]

## Train 

colnames(Y_train) <- c("Activity")

## change to a factor

Y_train$Activity <- as.factor(Y_train$Activity)

## assign factor level names

levels(Y_train$Activity) <- activity_labels

## Test

colnames(Y_test) <- c("Activity")

## change to a factor

Y_test$Activity <- as.factor(Y_test$Activity)

## assign factor level names

levels(Y_test$Activity) <- activity_labels

## subset x_train and x_test for mean and sd

indices <- grep("mean\\(\\)|std\\(\\)", names(X_train))

X_train_sub <- X_train[,indices]
X_test_sub <- X_test[,indices]

## name column in subject data sets "Subject"

colnames(subject_train) <- c("Subject")
colnames(subject_test) <- c("Subject")

## combine trains 

Trains <- cbind(subject_train, Y_train, X_train_sub)

## combine tests

Tests <- cbind(subject_test, Y_test, X_test_sub)

## Combine tests and trains

Combine <- rbind(Trains, Tests)

## make Subject and Activity Variables as factors

Combine$Subject <- as.factor(Combine$Subject)

## measure variables

measures <- names(Combine)
measures <- measures[3:68]

## Melt 

Melt <- melt(Combine, id = c("Subject", "Activity"), measure.vars = measures)

## Cast

Cast <- dcast(Melt, Subject + Activity ~ variable, mean)

## assign results to tidy

tidy <- Cast

## write to output file

write.table(tidy, "tidy.txt", row.names=FALSE, sep=",")

