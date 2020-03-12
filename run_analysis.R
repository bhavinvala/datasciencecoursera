
#setwd("C:/Desktop/Coursera_R_Programming")

# Create directory named GnCD(abbreviated Getting and Cleaning Data)
if (!dir.exists("./GnCD")) {
   dir.create('./GnCD')
}

#Download data
#download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip",destfile = "gncd.zip")

#UNZIP the file manually to GnCD directory.

#Load dplyr package
library(dplyr)

#Reading 'activity_labels.txt'
act_lbl<-read.table("./GnCD/UCI HAR Dataset/activity_labels.txt") %>% 
         rename(activity.n=V1)%>%
         rename(activity=V2)
#Reading 'features.txt'
features<-read.table("./GnCD/UCI HAR Dataset/features.txt")%>%
          rename(Vorder.n=V1)%>%
          rename(feature_stat_dim=V2)%>%
  mutate(feature=unlist(lapply(strsplit(as.character(feature_stat_dim), "-"),'[',1)))%>% 
 mutate(stat=unlist(lapply(strsplit(as.character(feature_stat_dim), "-"),'[',2)))%>% 
  mutate(dimension=unlist(lapply(strsplit(as.character(feature_stat_dim), "-"),'[',3)))

#Keeping only mean and Standard deviation statistics
features<-filter(features,stat=='mean()'|stat=='std()')

#Read X Data
X_test<-read.table("./GnCD/UCI HAR Dataset/test/X_test.txt")
X_train<-read.table("./GnCD/UCI HAR Dataset/train/X_train.txt")
X_test<-tbl_df(X_test)
X_train<-tbl_df(X_train)
X_all<-union_all(X_test,X_train)

rm(X_test)
rm(X_train)


#Read Y Data
Y_test<-read.table("./GnCD/UCI HAR Dataset/test/Y_test.txt")
Y_train<-read.table("./GnCD/UCI HAR Dataset/train/Y_train.txt")
Y_test<-tbl_df(Y_test)
Y_train<-tbl_df(Y_train)
Y_all<- union_all(Y_test,Y_train) %>% rename(activity.n=V1)
Y_all<-merge(Y_all,act_lbl,by.x="activity.n",by.y="activity.n")
rm(Y_test)
rm(Y_train)

#Read Subject Data
subject_test<-read.table("./GnCD/UCI HAR Dataset/test/subject_test.txt")
subject_train<-read.table("./GnCD/UCI HAR Dataset/train/subject_train.txt")
subject_test<-tbl_df(subject_test) %>% rename(subject=V1)
subject_train<-tbl_df(subject_train) %>% rename(subject=V1)
subject_all<-union_all(subject_test,subject_train)
rm(subject_test)
rm(subject_train)
#combine X, Y and Subject data
subject_X_Y_all<-cbind(subject_all,X_all,Y_all)

library(tidyr)
#transpose the data to merge with features data
trans1<-gather(subject_X_Y_all,"Vorder","Value",V1:V561)
#creating common variable to merge trans1 to feature
trans1$Vorder.n<-as.numeric(substr(trans1$Vorder,start=2,stop=10))
comb1<-merge(trans1,features,by.x="Vorder.n",by.y="Vorder.n")

#order the comb1 data
comb1<-arrange(comb1,subject,activity.n,activity,feature_stat_dim)
#Creating activitysequence number since 1 subject has multiple assessment for same activity.
U<-comb1%>% distinct(subject,activity.n,activity,feature)%>% mutate(activity.seq=seq_along(feature))
comb2<-merge(comb1,U)

#Final dataset
final<-select(comb2,subject,activity.n, activity,activity.seq,feature,stat,dimension,Value)
head(final)

#create .txt file to upload
write.table(final,file="GnCD_final_assignment.txt",row.names = FALSE)

#Creating summary dataset with average for each parameter
f<-tbl_df(final)
f<-group_by(f,subject,activity.n, activity,activity.seq,feature,stat,dimension)
avg<-summarize(f,avg=mean(Value))
