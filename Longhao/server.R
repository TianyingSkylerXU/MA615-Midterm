shinyServer(
  function(input, output, session) {
    a <- read.csv("basketdata.csv", sep = ",")
    library(shiny)
    library(stringr)
    library(dplyr)
    library(ggplot2)
    output$scatterPlot <- renderPlot({
      if (input$Weather == "Temperature") {
        i <- a$DAILYAverageDryBulbTemp
      }
      if (input$Weather == "Precipitation") {
        i <- a$DAILYPrecip
      }
      if (input$Weather == "Snow") {
        i <- a$DAILYSnowfall
      }
      ggplot(data = a, aes(x = i, y = a$P)) +
        geom_point() 
    })
  }
)
