#Initial data load
titanic = read.csv("Data/titanic.csv",header = TRUE,sep = ";") #read the datafile
titanic = titanic[-nrow(titanic),] #remove last line that is only NA

#Initiate data cleansing routines
titanic$age = as.vector(titanic$age) #make age to a vector
titanic$age[titanic$age == ""] = NA #remove the empty strings for age and replace with NA
titanic$age = gsub(",",".",titanic$age) #change the seperator to . instead of ,
titanic$age = as.numeric(titanic$age) #change the vector to numeric
titanic$age = round(titanic$age) #round up


titanic$fare = gsub(",",".",titanic$fare) #change seperator
titanic$fare = as.vector(titanic$fare) #make into a vector
titanic$fare[titanic$fare == ""] = NA #make missing values NA
titanic$fare = as.numeric(titanic$fare) #make numeric

#cleaning the mistakes in boats
titanic$boat<-gsub("13 15","13",titanic$boat)
titanic$boat<-gsub("13 15 B","13",titanic$boat)
titanic$boat<-gsub("13 B","13",titanic$boat)
titanic$boat<-gsub("5 7","5",titanic$boat)
titanic$boat<-gsub("5 9","9",titanic$boat)
titanic$boat<-gsub("15 16","15",titanic$boat)
titanic$boat<-gsub("8 10","8",titanic$boat)
#i am changing the columns A,B,C,D for numbers so it will be easy to plot
titanic$boat<-gsub("C D","C",titanic$boat)
titanic$boat<-gsub("A","17",titanic$boat)
titanic$boat<-gsub("B","18",titanic$boat)
titanic$boat<-gsub("C","19",titanic$boat)
titanic$boat<-gsub("D","20",titanic$boat)
titanic$boat<-ifelse(titanic$boat=="","NA",titanic$boat)
titanic$boat<-as.numeric(titanic$boat)
###SURVIVORS PER BOAT 
survivorsperboat<-tapply(titanic$survived,titanic$boat,sum)
survivorsperboat<-as.data.frame(survivorsperboat)
survivorsperboat$boat<-table(titanic$boat)
survivorsperboat$deads<-as.numeric(survivorsperboat$boat-survivorsperboat$survivorsperboat)
frequency<-sum(survivorsperboat$deads)/sum(survivorsperboat$boat)

titanic = mutate(titanic,passengerclass = fct_recode(as.factor(pclass),
                                                     "1st" = "1", "2nd" = "2", "3rd" = "3"),
                 survival = fct_recode(as.factor(survived),
                                       "died"="0","survived" = "1"))
nPerGender <-count(titanic,sex)
nGenderSurvival <- count(titanic,sex,survival)

titanic2<-titanic[,c(2,6,7,9,8)]
titanic2<-as.data.table(titanic2)
families<-titanic2[,.(count=.N,price=sum(fare),surv=sum(survived)),by="ticket"]
families$count<-as.numeric(families$count)
families$surv<-as.numeric(families$surv)
families<-subset(families,families$count>1)
maleData <- titanic[  titanic$sex=="male" , ]
femaleData <- titanic[  titanic$sex=="female" , ]

#Start saving rds
saveRDS(titanic,"Data/rds/titanic.rds")
saveRDS(titanic2,"Data/rds/titanic2.rds")
saveRDS(survivorsperboat,"Data/rds/survivorsperboat.rds")
saveRDS(nPerGender,"Data/rds/nPerGender.rds")
saveRDS(nGenderSurvival,"Data/rds/nGenderSurvival.rds")
saveRDS(maleData,"Data/rds/maleData.rds")
saveRDS(femaleData,"Data/rds/femaleData.rds")
saveRDS(families,"Data/rds/families.rds")
