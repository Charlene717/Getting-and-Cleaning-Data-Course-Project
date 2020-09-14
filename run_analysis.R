#FINAL PROYECT

# --------  Step1 ---------------- 
#Merges the training and the test sets to create one data set. 

## Fist we have to download the zip file an then unzip it.

if(!file.exists("./data")){dir.create("./data")} #We create a new directory if doesn´t exist called data where we will save the files

tf <-"./data/dataset.zip" ; td <- "./data"
Urlzip<- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file( Urlzip , tf , mode = "wb" )
files.data <- unzip( tf , exdir = td )

## Now we are going to read each txt file listed and paste them to build a single data

setwd("./data/UCI HAR Dataset")
namestrain<-list.files( "train", full.names = TRUE )[-1]
namestest<-list.files( "test" , full.names = TRUE )[-1]

Train<-lapply(namestrain,read.table,header=FALSE )
Test<-lapply(namestest,read.table,header=FALSE )

data1<- mapply ( rbind, Train, Test )#Paste below the train dat, the test data

data<-cbind(data1[[1]],data1[[2]],data1[[3]]) #Unique data


# ------ Step2 ------------------
#Extracts only the measurements on the mean and standard deviation for each measurement.

## First we have to name each column between 2:562 because the fisrt one is the subject column and the last one is the activity
## The names of these columns is in is alredy part of a list so we only have to assign them to the column

library(data.table)

columnsnames <- fread( list.files()[2], header = FALSE, stringsAsFactor = FALSE )
setnames(data,c(1:563),c("subject", columnsnames$V2,"activity"))

## We use regular expression to extract the columns that contains the word std or mean followed by (), nad we start in teh second column, because the first one is alredy taken

dataf<-data[,c(1,grep( "std|mean\\(\\)", columns$V2 ) + 1,563)]
str(dataf) # Chhecking the data


# ------ Step3 ----------
#Uses descriptive activity names to name the activities in the data set

namesact <- fread( list.files()[1], header = FALSE, stringsAsFactor = FALSE )
dataf$activity <- namesact$V2[ match( dataf$activity, namesact$V1 ) ]

# ------ Step4 --------
#From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

tidydata<-aggregate(dataf[,2:67],by=list(dataf$subject,dataf$activity),FUN=mean)

# ----- Step5 ------
#Write the new data in a txt file

write.table(tidydata,"tidydat.txt",row.name=FALSE)
#Extraemos los datos del zip file

