setwd("~/Documents/GitHub/Titanic")
rm(list =ls()) #remove all objects

#load libraries
library(ggplot2) 
library(readr)
library(dplyr)
library(tidyr)
library(forcats)
library(ggmosaic)
library(shiny)
library(hexbin)
library(MASS)
library(depth)

titanic = read.csv("titanic.csv",header = TRUE,sep = ";") #read the datafile
titanic = titanic[-nrow(titanic),] #remove last line that is only NA


titanic$age = as.vector(titanic$age) #make age to a vector
titanic$age[titanic$age == ""] = NA #remove the empty strings for age and replace with NA
titanic$age = gsub(",",".",titanic$age) #change the seperator to . instead of ,
titanic$age = as.numeric(titanic$age) #change the vector to numeric
titanic$age = round(titanic$age) #round up


titanic$fare = gsub(",",".",titanic$fare) #change seperator
titanic$fare = as.vector(titanic$fare) #make into a vector
titanic$fare[titanic$fare == ""] = NA #make missing values NA
titanic$fare = as.numeric(titanic$fare) #make numeric
class(titanic$fare)

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
levels(titanic$boat)
table(titanic$boat)
###SURVIVORS PER BOAT 
survivorsperboat<-tapply(titanic$survived,titanic$boat,sum)
survivorsperboat<-as.data.frame(survivorsperboat)
survivorsperboat$boat<-table(titanic$boat)
survivorsperboat$deads<-as.numeric(survivorsperboat$boat-survivorsperboat$survivorsperboat)
frequency<-sum(survivorsperboat$deads)/sum(survivorsperboat$boat)


#some of the data that actually is categorical is coded as numeric, this code adds them ass categorical
titanic = mutate(titanic,passengerclass = fct_recode(as.factor(pclass),
                                             "1st" = "1", "2nd" = "2", "3rd" = "3"),
                 survival = fct_recode(as.factor(survived),
                                       "died"="0","survived" = "1"))

dim(titanic) #we now have 16 variables
names(titanic) #see the names

count(titanic,passengerclass) #count the number of passengers in each class
count(titanic,survival) #count the number of survived and died
nPerGender <-count(titanic,sex) #count the number of men and women
tapply(titanic$fare, titanic$passengerclass, range,na.rm = TRUE)

summary(titanic$fare)
hist(titanic$fare)
View(titanic)


#barplot of men and women
ggplot(titanic) +
  geom_bar(aes(x = sex,fill =sex))
#twice as much men as women

nGenderSurvival <- count(titanic,sex,survival) #how many men survived/died and how many women survived/died


#plot of men and women and if the died or not
ggplot(titanic) + 
  geom_bar(aes(sex,fill=survival))

#for proportions instead
ggplot(titanic) +
  geom_bar(aes(sex,fill = survival),position = "fill")

#mosaic plot 
ggplot(titanic) +
  geom_mosaic(aes(x = product(sex),fill = survival)) +
  labs(x = "Gender",y = "Proportion that survived")

#one of the interesting things to check if wether the survival is different in the classes
ggplot(titanic) +
  geom_bar(aes(sex,fill = survival), position = "fill") +
  facet_wrap( ~ passengerclass) +
  labs(y="Survived/lived", title = "Gender and survival by class")

#easy to see that the passengerclass greatly influenced the survival for men and women
#more so between the 1st and 2,3 for men and 1,2 and 3 for women.

#age distribution by sex
ggplot(titanic) +
     geom_histogram(aes(x = age,fill = sex), bins = 35,na.rm = TRUE)

#fare distribution by class
ggplot(titanic) + 
  geom_histogram(aes(x = fare,fill = passengerclass), bins = 25,na.rm = TRUE)

#https://bio304-class.github.io/bio304-fall2017/data-story-titanic.html

#
titanic %>%
  filter(!is.na(age)) %>%
     ggplot() + 
       geom_jitter(aes(survived, age, color = sex), width = 0.1, alpha = 0.5) 

#died and survived by age and gender
titanic %>%
     filter(!is.na(age)) %>% 
     ggplot() +
     geom_jitter(aes(survival, age, color = sex), width = 0.1, alpha = 0.5) +
     facet_wrap(~sex)

#probability of surviving by age and gender
titanic %>%
      filter(!is.na(age)) %>%
      ggplot(aes(x = age, y = survived, color = sex)) + 
      geom_jitter(height = 0.05, alpha = 0.35) + 
      geom_smooth(method="glm", method.args = list(family="binomial"))  + 
      facet_wrap(~sex) + 
      labs(x = "Age", y = "Probability of survival")

#probability of surviving by age and gender broken down by passenger class
titanic %>%
   filter(!is.na(age)) %>%
   ggplot(aes(x = age, y = survived, color = sex)) + 
   geom_jitter(height = 0.05, alpha = 0.35) + 
   geom_smooth(method="glm", method.args = list(family="binomial"))  + 
   facet_grid(passengerclass~sex) + 
   labs(x = "Age", y = "Probability of survival")

#### create a data frame to identify families
library("data.table")
titanic2<-titanic[,c(2,6,7,9,8)]
unique(titanic$ticket)
titanic2<-as.data.table(titanic2)
families<-titanic2[,.(count=.N,price=sum(fare),surv=sum(survived)),by="ticket"]
##plot to see how the people was traveling
families$count<-as.numeric(families$count)
families$surv<-as.numeric(families$surv)
families<-subset(families,families$count>1)
scatter.smooth(families$surv,families$count)

maleData <- titanic[  titanic$sex=="male" , ]
femaleData <- titanic[  titanic$sex=="female" , ]
###################################end of the descriptive model###############################
############################Multivariate and depth analysis###################################
scatter.smooth(titanic$fare,titanic$age)
class(titanic$fare)
class(titanic$age)
titanicage<-subset(titanic,!is.na(titanic$age))
AGE<-mean(titanicage$age)
titanic$age<-ifelse(is.na(titanic$age),AGE,titanic$age)
summary(titanic$age)
titanicfare<-subset(titanic,!is.na(titanic$fare))
fare<-mean(titanicfare$fare)
titanic$fare<-ifelse(is.na(titanic$fare),fare,titanic$fare)
summary(titanic$fare)
core<-titanic[,c(5,9)]
cor(core)
bin<-hexbin(core[,2],core[,1], xbins=10, xlab="Norm 1", ylab="Norm 2") 
plot(bin, main="Hexagonal Binning")
correla<-kde2d(core[,2], core[,1], n = 100)
persp3d(correla,col="red")
colMeans(core)
depth(c(33.29548,29.93940),core)


