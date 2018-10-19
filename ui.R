#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)

# Define UI for application that draws a histogram
shinyUI(
  navbarPage("Attendance",
    tabPanel("Celtics",
      pageWithSidebar(
        headerPanel("Celtics attendence against weather"),
        sidebarPanel(
          selectInput("Weather", "Please Select Weather factors", 
                      choices = c("Temperature", "Precipitation", "Snow", "Matches"))
        ),
        mainPanel(
          plotOutput("celticsPlot")
        )
      )
    ),
    
    tabPanel("Red Sox I",
      titlePanel("RedSox attendance against weather"),
      sidebarPanel(
        selectInput("Temperature", "Please Select Weather factors", 
                    choices = c("Daily Maximum Temperature", "Daily Minimum Temperature", "Daily Average Temperature", "Daily Average Windspeed"))
      ),
      mainPanel(
        plotOutput("RedSoxPlot")
      )
    ),
    
    tabPanel("Red Sox II",
      # Application title
      titlePanel("Red Sox Attendance"),
      # Sidebar with a slider input for number of bins 
      sidebarLayout(
        sidebarPanel(
          sliderInput("dates",
                      "Date Interval:",
                      min = as.Date("2012-01-01", "%Y-%m-%d"),
                      max = as.Date("2017-12-31", "%Y-%m-%d"),
                      value = c(as.Date("2012-01-01", "%Y-%m-%d"), as.Date("2017-12-31", "%Y-%m-%d")))
        ),
        # Show a plot of the generated distribution
        mainPanel(
          plotOutput("scatterPlot")
        )
      )
    )
  )
)
