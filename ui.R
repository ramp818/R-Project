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
                  title = "Gender and survival by class",
                  plotOutput("distPlot"), collapsible = TRUE
                ),
                box(
                  status = "info", solidHeader = TRUE,
                  title = "Men and woman survival",
                  plotOutput("distPlot2"), collapsible = TRUE
                )
              ),
              fluidRow(
                box(
                  status = "info", solidHeader = TRUE,
                  title = "Survival Proportion",
                  plotOutput("distPlot3"), collapsible = TRUE
                ),
                box(
                  status = "info", solidHeader = TRUE,
                  title = "Proportion that survived mosaic",
                  plotOutput("distPlot4"), collapsible = TRUE
                )
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
              )
      )
    )
  )
)

