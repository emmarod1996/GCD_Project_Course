##Getting and cleaning data course project
library(dplyr)
library(tidyr)

#Loading all the datasets
features <- read.table("UCI HAR Dataset/features.txt",col.names = c("n","functions"))
activity_labels <- read.table("UCI HAR Dataset/activity_labels.txt",col.names = c("code","activity"))
x_test <- read.table("UCI HAR Dataset/test/X_test.txt",col.names = features$functions)
y_test <- read.table("UCI HAR Dataset/test/y_test.txt",col.names = "code")
x_train <- read.table("UCI HAR Dataset/train/X_train.txt",col.names = features$functions)
y_train <- read.table("UCI HAR Dataset/train/y_train.txt",col.names = "code")
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt",col.names = "subject")
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt",col.names = "subject")

#Merging training and test datasets
X_merged <- rbind(x_test,x_train) ; Y_merged <- rbind(y_test,y_train)
subject_merged <- rbind(subject_test,subject_train)
Data_merged <- cbind(subject_merged,Y_merged,X_merged)

#Extracting only the data that contains mean and std
tidy <- Data_merged [,grepl(pattern = ("code|subject|activity|mean|std"),colnames(Data_merged))]

#provinding activity names to dataset
tidy$code <- activity_labels[tidy$code,2]

#labeling appropiately the dataset varaiable names
colnames(tidy) <- tolower(colnames(tidy))
colnames(tidy) <- gsub("\\.","",colnames(tidy))
colnames(tidy) <- gsub("acc","Accelerometer",colnames(tidy))
colnames(tidy) <- gsub("gyr","Gyroscope",colnames(tidy))
colnames(tidy) <- gsub("mag","Magnitude",colnames(tidy))
colnames(tidy) <- gsub("^t","Time",colnames(tidy))
colnames(tidy) <- gsub("^f","Frecuency",colnames(tidy))
colnames(tidy) <- gsub("mean","MEAN",colnames(tidy))
colnames(tidy) <- gsub("std","STD",colnames(tidy))
colnames(tidy) <- gsub("jerk","Jerk",colnames(tidy))
colnames(tidy) <- gsub("body","Body",colnames(tidy))
colnames(tidy) <- gsub("gravity","Gravity",colnames(tidy))

#second data set with the average of each variable for each activity

Final_data <- tidy %>% 
  group_by(subject,code) %>%
  summarise_all(funs(mean))

#writing the final table

write.table(Final_data,"Final_Data.txt",row.names = F)

str(Final_data)
