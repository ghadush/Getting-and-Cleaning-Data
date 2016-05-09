

## Cran package easy to download files
library(downloader)

# Link of the zipped files 
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

download(url, dest="dataset.zip", mode="wb") 
# Unzip into under my current working directory "data" 
unzip ("dataset.zip", exdir = "./data")

# 1. Merges the training and the test sets to create one data set.
x.train <- read.table('./data/UCI HAR Dataset/train/X_train.txt')
x.test <- read.table('./data/UCI HAR Dataset/test/X_test.txt')
x <- rbind(x.train, x.test)


subj.train <- read.table('./data/UCI HAR Dataset/train/subject_train.txt')
subj.test <- read.table('./data/UCI HAR Dataset/test/subject_test.txt')
subj <- rbind(subj.train, subj.test)


y.train <- read.table('./data/UCI HAR Dataset/train/y_train.txt')
y.test <- read.table('./data/UCI HAR Dataset/test/y_test.txt')
y <- rbind(y.train, y.test)


# 2. Extracts only mean and standard deviation for each measurement. 
features <- read.table('./data/UCI HAR Dataset/features.txt')
mean.sd <- grep("-mean\\(\\)|-std\\(\\)", features[, 2])

x.mean.sd <- x[, mean.sd]

# 3. Uses descriptive activity names to name the activities in the data set
names(x.mean.sd) <- features[mean.sd, 2]
# change all to lower case for easy scripting and debuging 
names(x.mean.sd) <- tolower(names(x.mean.sd)) 
# remove the paranthesis 
names(x.mean.sd) <- gsub("\\(|\\)", "", names(x.mean.sd))

# Read activities, update the names to lower and remove "_" 
activities <- read.table('./data/UCI HAR Dataset/activity_labels.txt')
activities[, 2] <- tolower(as.character(activities[, 2]))
activities[, 2] <- gsub("_", "", activities[, 2])


y[, 1] = activities[y[, 1], 2]
colnames(y) <- 'activity'
colnames(subj) <- 'subject'

# 4. Appropriately labels the data set with descriptive activity names and export
# with file name merged.txt.
data <- cbind(subj, x.mean.sd, y)
str(data)
write.table(data, './data/merged.txt', row.names = F)

#5.  From the data set in step 4, creates a second, 
# independent tidy data set with the average of each variable 
# for each activity and each subject.

average.df <- aggregate(x=data, by=list(activities=data$activity, subj=data$subject), FUN=mean)
average.df <- average.df[, !(colnames(average.df) %in% c("subj", "activity"))]
str(average.df)
write.table(average.df, './data/average.txt', row.names = F)







# List of files after unzipped are 
# 1. activity_labels.txt            Folder: train and test 
# 2. features.txt
# 3. features_info.txt
# 4. README.txt


mergedData <- merge(gdpData, eduData, as.x = "CountryCode", as.y = "CountryCode")