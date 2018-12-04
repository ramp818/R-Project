# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#
#options(rgl.useNULL=TRUE)
library(shiny)
library(shinydashboard)
library("data.table")
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
library(RColorBrewer) 
library(corrplot)
library(rgl)

#Start Data load
# Load static trip and shape data
titanic  <- readRDS("Data/rds/titanic.rds")
titanic2 <- readRDS("Data/rds/titanic2.rds")
survivorsperboat  <- readRDS("Data/rds/survivorsperboat.rds")
nPerGender <- readRDS("Data/rds/nPerGender.rds")
nGenderSurvival  <- readRDS("Data/rds/nGenderSurvival.rds")
maleData <- readRDS("Data/rds/maleData.rds")
femaleData  <- readRDS("Data/rds/femaleData.rds")
families <- readRDS("Data/rds/families.rds")
titanicage<-subset(titanic,!is.na(titanic$age))
AGE<-mean(titanicage$age)
titanic$age<-ifelse(is.na(titanic$age),AGE,titanic$age)
titanicfare<-subset(titanic,!is.na(titanic$fare))
fare<-mean(titanicfare$fare)
titanic$fare<-ifelse(is.na(titanic$fare),fare,titanic$fare)
titanic3<-titanic[,c(1,2,4,5,9,12)]
titanic3$sex<-ifelse(titanic3$sex=="female",1,0)
titanic3$sex<-as.numeric(titanic3$sex)
titanic3$boat<-ifelse(is.na(titanic3$boat),0,1)
core<-titanic3
a<-cor(core)
bin<-hexbin(core[,4],core[,5], xbins=10, xlab="Norm 1", ylab="Norm 2")
correla<-kde2d(core[,4], core[,5], n = 100)

# Define server logic required to draw dashboard components
shinyServer(function(input, output) {
   
  #Switch to react to radio buttons
  d <- reactive({
    dist <- switch(input$gender,
                   sex = titanic,
                   male = maleData,
                   female = femaleData,
                   titanic)
  })
  
###########Start of render descriptive analytics ################################
  output$distPlot <- renderPlot({
    
    ggplot(d()) +
      geom_bar(aes(sex,fill = survival), position = "fill") +
      facet_wrap( ~ passengerclass) +
      labs(y="Survived/lived")
  })
  
  #Render Male and female survived bar chart
  output$distPlot2 <- renderPlot({
    
    ggplot(d()) + 
      geom_bar(aes(sex,fill=survival))
  })
  
  output$distPlot3 <- renderPlot({
    
    ggplot(d()) +
      geom_bar(aes(sex,fill = survival),position = "fill")
  })
  
  output$distPlot4 <- renderPlot({
    
    ggplot(d()) +
      geom_mosaic(aes(x = product(sex),fill = survival)) +
      labs(x = "Gender",y = "Proportion that survived")
  })
  
  output$distPlot5 <- renderPlot({
    
    ggplot(d()) +
      geom_histogram(aes(x = age,fill = sex), bins = 35,na.rm = TRUE)
  })
  
  output$distPlot6 <- renderPlot({
    
    ggplot(d()) + 
      geom_histogram(aes(x = fare,fill = passengerclass), bins = 25,na.rm = TRUE)
  })
  
  output$distPlot7 <- renderPlot({
    
    d() %>%
      filter(!is.na(age)) %>%
      ggplot() + 
      geom_jitter(aes(survived, age, color = sex), width = 0.1, alpha = 0.5) 
  })
  
  output$distPlot8 <- renderPlot({
    
    d() %>%
      filter(!is.na(age)) %>% 
      ggplot() +
      geom_jitter(aes(survival, age, color = sex), width = 0.1, alpha = 0.5) +
      facet_wrap(~sex)
  })
  
  output$distPlot9 <- renderPlot({
    
    d() %>%
      filter(!is.na(age)) %>%
      ggplot(aes(x = age, y = survived, color = sex)) + 
      geom_jitter(height = 0.05, alpha = 0.35) + 
      geom_smooth(method="glm", method.args = list(family="binomial"))  + 
      facet_wrap(~sex) + 
      labs(x = "Age", y = "Probability of survival") 
  })
  
  output$distPlot10 <- renderPlot({
    
    d() %>%
      filter(!is.na(age)) %>%
      ggplot(aes(x = age, y = survived, color = sex)) + 
      geom_jitter(height = 0.05, alpha = 0.35) + 
      geom_smooth(method="glm", method.args = list(family="binomial"))  + 
      facet_grid(passengerclass~sex) + 
      labs(x = "Age", y = "Probability of survival")
  })
  
  output$distPlot11 <- renderPlot({
    
    scatter.smooth(families$surv,families$count)
  })
##################### End of descriptive analytics 
##################### Start of multivariate and depth analysis #########################
  output$distPlot12 <- renderPlot({
    
    corrplot(a,method = "number", type="upper", order="hclust", col=brewer.pal(n=8, name="RdYlBu"))
  })
  
  output$distPlot13 <- renderPlot({
    
    plot(bin, main="Hexagonal Binning")
  })
  
  output$distPlot14 <- renderRglwidget({
    rgl.open(useNULL=T)
    persp3d(correla,col="red")
    rglwidget()
  })

})
