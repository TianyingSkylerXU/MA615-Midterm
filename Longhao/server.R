shinyServer(
  function(input, output, session) {
    a <- read.csv("basketdata.csv", sep = ",")
    library(shiny)
    library(stringr)
    library(dplyr)
    library(ggplot2)
    output$scatterPlot <- renderPlot({
      if (input$Weather == "Temperature") {
        i <- a$DAILYDeptFromNormalAverageTemp
        z <- "Temperature in Celsius"
      }
      if (input$Weather == "Precipitation") {
        i <- a$DAILYPrecip
        z <- "Precipitation in inch"
      }
      if (input$Weather == "Snow") {
        i <- a$DAILYSnowfall
        z <- "Daily Snow in inch"
      }
      if (input$Weather == "Matches") {
        i <- 1:245
        z <- "Date of Matches in order"
      }
      ggplot(data = a, aes(x = i, y = a$P)) +
        geom_point() +
        ylab("Attendence rate") + xlab(z)
    })
  }
)
