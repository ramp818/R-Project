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

# Define UI for application that draws the dashboard
dashboardPage(skin = "black",
  dashboardHeader(title = "Titanic"),
  dashboardSidebar(
    radioButtons("gender", "Gender:",
                 c("Both" = "sex",
                   "Male" = "male",
                   "Female" = "female")),
    sidebarMenu(
      menuItem("Dashboard", tabName = "dashboard", icon = icon("dashboard")),
      menuItem("Tables", tabName = "tables")
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
                  title = "Age distribution by gender",
                  plotOutput("distPlot5"), collapsible = TRUE
                ),
                box(
                  status = "info", solidHeader = TRUE,
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
                box(
                  status = "info", solidHeader = TRUE,
                  title = "Gender and survival by class",
                  plotOutput("distPlot"), collapsible = TRUE
                )
              )
      )
    )
  )
)

