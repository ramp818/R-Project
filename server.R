# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#
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
  
  #Render Male and female bar chart
  output$distPlot <- renderPlot({
    dist <- input$gender
    
    ggplot(d()) +
      geom_bar(aes(sex,fill = survival), position = "fill") +
      facet_wrap( ~ passengerclass) +
      labs(y="Survived/lived")
  })
  
  #Render Male and female survived bar chart
  output$distPlot2 <- renderPlot({
    dist <- input$gender
    
    ggplot(d()) + 
      geom_bar(aes(sex,fill=survival))
  })
  
  output$distPlot3 <- renderPlot({
    dist <- input$gender
    
    ggplot(d()) +
      geom_bar(aes(sex,fill = survival),position = "fill")
  })
  
  output$distPlot4 <- renderPlot({
    dist <- input$gender
    
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

})
