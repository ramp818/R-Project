#
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
      geom_bar(aes(x = sex,fill =sex))
  })
  
  #Render Male and female survived bar chart
  output$distPlot2 <- renderPlot({
    dist <- input$gender
    
    ggplot(titanic) + 
      geom_bar(aes(sex,fill=survival))
  })
  
  #Render table values
  output$table <- renderTable({
    d()
  })
  
  output$nGender <- renderTable({
    nPerGender
  })
  
  output$nGenderSurvival <- renderTable({
    nGenderSurvival
  })

})
