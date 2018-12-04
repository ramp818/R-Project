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

# Define UI for application that draws the dashboard
dashboardPage(skin = "black",
  dashboardHeader(title = "Titanic"),
  dashboardSidebar(
    radioButtons("gender", "Gender:",
                 c("Both" = "sex",
                   "Male" = "male",
                   "Female" = "female")),
    sidebarMenu(
      menuItem("Descriptive", tabName = "descriptive", icon = icon("chart-bar")),
      menuItem("Multivariate", tabName = "multivariate", icon = icon("filter")),
      menuItem("Data", tabName = "data", icon = icon("database"))
    )
  ),
  dashboardBody(
    tabItems(
      tabItem(tabName = "descriptive",
              fluidRow(
                # A static valueBox
                valueBox("466", "Female", icon = icon("female"),color = "red"),
                valueBox("843", "Male", icon = icon("male"))
              ),
              fluidRow(
                box(
                  status = "info", solidHeader = FALSE,
                  title = "Age distribution by gender",
                  plotOutput("distPlot5"), collapsible = TRUE
                ),
                box(
                  status = "info", solidHeader = FALSE,
                  title = "Fare distribution by class",
                  plotOutput("distPlot6"), collapsible = TRUE
                )
              ),
              fluidRow(
                #distplot2,3 y 4
                tabBox(
                  title = "Survival by gender",
                  # The id lets us use input$tabset1 on the server to find the current tab
                  id = "tabset1",
                  tabPanel("Absolute", plotOutput("distPlot2")),
                  tabPanel("Relative", plotOutput("distPlot3")),
                  tabPanel("Mosaic", plotOutput("distPlot4"))
                ),
                tabBox(
                  title = "Proportion survival",
                  # The id lets us use input$tabset2 on the server to find the current tab
                  id = "tabset2",
                  tabPanel("United", plotOutput("distPlot7")),
                  tabPanel("Separated", plotOutput("distPlot8"))
                )
              ),
              fluidRow(
                tabBox(
                  title = "By class and Families",
                  # The id lets us use input$tabset3 on the server to find the current tab
                  id = "tabset3",  height = "500px",
                  tabPanel("Class", plotOutput("distPlot")),
                  tabPanel("Families", plotOutput("distPlot11"))
                ),
                box(
                  status = "info", solidHeader = FALSE, height = "500px",
                  title = "Probability of survival by gender and age",
                  plotOutput("distPlot9"), collapsible = TRUE
                )
              ),
              fluidRow(
                box(
                  status = "info", solidHeader = FALSE, width = 6,
                  title = "Probability of survival by gender,class and age",
                  plotOutput("distPlot10"), collapsible = TRUE
                ),
                tabBox(
                  title = "Summary Survived",
                  # The id lets us use input$tabset3 on the server to find the current tab
                  id = "tabset4",  width = 6,
                  tabPanel("Age", verbatimTextOutput("summary")),
                  tabPanel("Sex", verbatimTextOutput("summary2")),
                  tabPanel("Class", verbatimTextOutput("summary3"))
                )
              )
      ),
      tabItem(tabName = "multivariate",
              fluidRow(
                box(
                  status = "info", solidHeader = FALSE,
                  title = "Variable Correlation",
                  plotOutput("distPlot12"), collapsible = TRUE
                ),
                box(
                  status = "info", solidHeader = FALSE,
                  title = "Hexagonal Binning",
                  plotOutput("distPlot13"), collapsible = TRUE
                )
              ),
              fluidRow(
                box(
                  status = "info", solidHeader = FALSE, width = 12,
                  title = "3D Plot",
                  rglwidgetOutput("distPlot14")
                )
              )
      ),
      tabItem(tabName = "data",
              tableOutput("dataset")
      )
    )
  )
)

