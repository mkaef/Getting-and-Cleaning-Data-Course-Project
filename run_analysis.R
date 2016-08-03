#Download file
if(!file.exists("./data")){dir.create("./data")}
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl,destfile="./data/Dataset.zip")

#Unzip the file
unzip(zipfile="./data/Dataset.zip",exdir="./data")
#file path
path <- file.path("./data" , "UCI HAR Dataset")
files<-list.files(path, recursive=TRUE)
#Reading from files to variables
ActivityTest  <- read.table(file.path(path, "test" , "Y_test.txt" ))
ActivityTrain <- read.table(file.path(path, "train", "Y_train.txt"))

SubjectTrain <- read.table(file.path(path, "train", "subject_train.txt"))
SubjectTest  <- read.table(file.path(path, "test" , "subject_test.txt"))

FeaturesTest  <- read.table(file.path(path, "test" , "X_test.txt" ))
FeaturesTrain <- read.table(file.path(path, "train", "X_train.txt"))

#1.Merges the training and the test sets to create one data set
#Get data table by rows
Subject <- rbind(SubjectTrain, SubjectTest)
Activity<- rbind(ActivityTrain, ActivityTest)
Features<- rbind(FeaturesTrain, FeaturesTest)
#Assign namea to variables
names(Subject)<-c("subject")
names(Activity)<- c("activity")
FeaturesNames <- read.table(file.path(path, "features.txt"),head=FALSE)
names(Features)<- FeaturesNames$V2
#Merging Data
Combine <- cbind(Subject, Activity)
Data <- cbind(Features, Combine)

#2.Extracts only the measurements on the mean and standard deviation for each measurement.
#Names of Features with mean() or std()
subFeaturesNames<-FeaturesNames$V2[grep("mean\\(\\)|std\\(\\)",FeaturesNames$V2)]
#Dataframe selection
selectedNames<-c(as.character(subFeaturesNames), "subject", "activity" )
Data<-subset(Data,select=selectedNames)

#3.Uses descriptive activity names to name the activities in the data set
activityLabels <- read.table(file.path(path, "activity_labels.txt"))
head(Data$activity,30)

#4.Appropriately labels the data set with descriptive variable names.
names(Data)<-gsub("^t", "time", names(Data))
names(Data)<-gsub("^f", "frequency", names(Data))
names(Data)<-gsub("Acc", "Accelerometer", names(Data))
names(Data)<-gsub("Gyro", "Gyroscope", names(Data))
names(Data)<-gsub("Mag", "Magnitude", names(Data))
names(Data)<-gsub("BodyBody", "Body", names(Data))
#Check data names
names(Data)

#5.creates a second, independent tidy data set with the average of each variable 
#for each activity and each subject.
Data2<-aggregate(. ~subject + activity, Data, mean)
Data2<-Data2[order(Data2$subject,Data2$activity),]
write.table(Data2, file = "tidydataset.txt",row.name=FALSE)


