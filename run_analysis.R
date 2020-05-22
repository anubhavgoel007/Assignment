filename <- "samsung.zip"

## Check if THE archieve already exists.
if (!file.exists(filename)){
  URL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
  download.file(URL, filename)
}  

## Check if the folder already exists.
if (!file.exists("Dataset")) { 
  unzip(filename) 
}

##Assign all the data frames.
features <- read.table("Dataset/features.txt", col.names = c("n","functions"))

activities <- read.table("Dataset/activity_labels.txt", col.names = c("code", "activity"))

subject_test <- read.table("Dataset/test/subject_test.txt", col.names = "subject")

x_test <- read.table("Dataset/test/X_test.txt", col.names = features$functions)

y_test <- read.table("Dataset/test/y_test.txt", col.names = "code")

subject_train <- read.table("Dataset/train/subject_train.txt", col.names = "subject")

x_train <- read.table("Dataset/train/X_train.txt", col.names = features$functions)

y_train <- read.table("Dataset/train/y_train.txt", col.names = "code")

## 1. Merge test and train datasets to create one dataset.
X <- rbind(x_train, x_test)

Y <- rbind(y_train, y_test)

Subject <- rbind(subject_train, subject_test)

Merdged <- cbind(Subject, Y, X)

## 2. Extract the measurements on the mean and sd for each measurement
Tidy <- Merged %>% select(subject, code, contains("mean"), contains("std"))

## 3. Use descriptive activity names to name the activities in the data set

Tidy$code <- activities[Tidy$code, 2]

## 4. Label the data set with descriptive variable names

names(Tidy)[2] = "activity"

names(Tidy)<-gsub("Acc", "Accelerometer", names(Tidy))

names(Tidy)<-gsub("Gyro", "Gyroscope", names(Tidy))

names(Tidy)<-gsub("BodyBody", "Body", names(Tidy))

names(Tidy)<-gsub("Mag", "Magnitude", names(Tidy))

names(TidyData)<-gsub("^t", "Time", names(Tidy))

names(Tidy)<-gsub("^f", "Frequency", names(Tidy))

names(Tidy)<-gsub("tBody", "TimeBody", names(Tidy))

names(Tidy)<-gsub("-mean()", "Mean", names(Tidy), ignore.case = TRUE)

names(Tidy)<-gsub("-std()", "STD", names(Tidy), ignore.case = TRUE)

names(Tidy)<-gsub("-freq()", "Frequency", names(Tidy), ignore.case = TRUE)

names(Tidy)<-gsub("angle", "Angle", names(Tidy))

names(Tidy)<-gsub("gravity", "Gravity", names(Tidy))

## 5. create a second, independent tidy data set with the average of each variable for each activity and each subject

Final <- Tidy %>%
  group_by(subject, activity) %>%
  summarise_all(funs(mean))
write.table(Final, "Final.txt", row.name=FALSE)










