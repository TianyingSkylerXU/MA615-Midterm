
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

shinyServer(
  pageWithSidebar(
    headerPanel("Celtics attendence against weather"),
    
    sidebarPanel(
      selectInput("Weather", "Please Select Weather factors", 
                  choices = c("Temperature", "Precipitation", "Snow"))
    ),
    mainPanel(
      plotOutput("scatterPlot")
      
    )
  )
)
