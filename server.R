# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#
library(shiny)
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

})
