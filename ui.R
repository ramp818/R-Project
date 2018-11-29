#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#
library(shiny)
library(shinydashboard)

# Define UI for application that draws a histogram
dashboardPage(
  dashboardHeader(title = "Titanic"),
  dashboardSidebar(
    radioButtons("gender", "Gender:",
                 c("Both" = "sex",
                   "Male" = "male",
                   "Female" = "female")),
    sidebarMenu(
      menuItem("Dashboard", tabName = "dashboard")
    )
  ),
  dashboardBody(
    tabItems(
      tabItem("dashboard",
              fluidRow(
                # A static valueBox
                valueBox("466", "Female", icon = icon("female"),color = "red"),
                valueBox("843", "Male", icon = icon("male"))
              ),
              fluidRow(
                box(
                  status = "info", solidHeader = TRUE,
                  title = "Number of men and woman in the Titanic",
                  plotOutput("distPlot")
                ),
                box(
                  status = "info", solidHeader = TRUE,
                  title = "Number of men and woman that survived",
                  plotOutput("distPlot2")
                )
              ),
              fluidRow(
                box(
                  status = "info", solidHeader = TRUE,
                  title = "Proportion",
                  plotOutput("distPlot3")
                ),
                box(
                  status = "info", solidHeader = TRUE,
                  title = "Proportion",
                  plotOutput("distPlot4")
                )
              )
      )
    )
  )
)

