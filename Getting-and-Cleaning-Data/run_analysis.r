# import the data files to make the analysis
library(devtools)
source_gist("4466237")
dirURL <- "https://raw.githubusercontent.com/Pinheiro72/Data-Science-Course/master/Getting-and-Cleaning-Data/"

# for whom that don't have devtools package installed, can use the following statements to download and load into the R environment the files for making the analysis
#download.file(paste(dirURL, "features.txt", sep=""), destfile="your directory/features.txt")
#features <- read.table("your directory/features.txt")

features <- read.table(paste(dirURL, "features.txt", sep=""))
activ <- read.table(paste(dirURL, "activity_labels.txt", sep=""))
train <- read.table(paste(dirURL, "X_train.txt", sep=""))
test <- read.table(paste(dirURL, "X_test.txt", sep=""))
subject1 <- read.table(paste(dirURL, "subject_train.txt", sep=""))
subject2 <- read.table(paste(dirURL, "subject_test.txt", sep=""))
labels1 <- read.table(paste(dirURL, "y_train.txt", sep=""))
labels2 <- read.table(paste(dirURL, "y_test.txt", sep=""))

# create an data set based on the training and the test sets
rawdata <- rbind(train, test)

# label the data set with descriptive variable names
names(rawdata) <- features$V2

# select only the measurements on the mean and standard deviation for each measurement
cols_mean <- grep("mean", features$V2)
cols_std <- grep("std", features$V2)
cols_meanfreq <- grep("meanFreq", features$V2)
cols_rm <- match(cols_meanfreq, cols_mean)
cols <- sort(c(cols_mean[-cols_rm], cols_std))
rawdata <- rawdata[ , cols]

# name the activities and subjects in the data set
subject <- rbind(subject1, subject2)
rawdata <- cbind(subject, rawdata)
names(rawdata)[1] <- "Subject"
labels <- rbind(labels1, labels2)
rawdata <- cbind(labels, rawdata)
rawdata <- merge(activ, rawdata, by="V1")
names(rawdata)[2] <- "Activity"
tidydata <- rawdata[ , -1] # ensure that it meets the tidy data principles 

rm(features, activ, train, test, subject1, subject2, labels1, labels2, rawdata, subject, labels, cols_mean, cols_std, cols_meanfreq, cols_rm, cols) 

# calculate the average of each variable for each activity and each subject
avgdata <- as.data.frame(tapply(tidydata[ , "tBodyAcc-mean()-X"], list(tidydata$Subject, tidydata$Activity), mean))
avgdata$Subject <- 1:30
avgdata$Variable <- names(tidydata)[3]

avgdata <- as.data.frame(table(tidydata$Activity, tidydata$Subject))
names(avgdata) <- c("Group.1", "Group.2")
avgdata <- avgdata[ , 1:2]
for(i in 3:length(tidydata)){
  temp <- aggregate(tidydata[ , i], by=list(tidydata$Activity, tidydata$Subject), FUN=mean, na.rm=T)
  names(temp)[length(temp)] <- names(tidydata)[i]
  avgdata <- merge(avgdata, temp, by=c("Group.1", "Group.2"), all.x=T)
}
names(avgdata)[1:2] <- c("Activity", "Subject")
rm(temp, i)
write.table(avgdata, "./avg_HAR_dataset.txt", row.name=F)