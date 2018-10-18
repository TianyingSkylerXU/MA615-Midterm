#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  
  library(tidyverse)
  library(readxl)
  library(stringr)  
  
  #Celtics
  a <- read.csv("basketdata.csv", sep = ",")
  output$celticsPlot <- renderPlot({
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
      geom_jitter() +
      ylab("Attendence rate") + xlab(z)
  })
  
  
  #Red Sox
  #baseball
  coltype <- c("numeric", "text", "text", "text", "text", "text", "text", "numeric", "numeric", "numeric", "text", "numeric", "text", "text", "text", "text", "text", "text", "numeric", "text", "text")
  RedSox_2012 <- read_excel("RedSox/RedSox_2012.xlsx", col_types = coltype)
  RedSox_2012$year <- "2012"
  RedSox_2013 <- read_excel("RedSox/RedSox_2013.xlsx", col_types = coltype)
  RedSox_2013$year <- "2013"
  RedSox_2014 <- read_excel("RedSox/RedSox_2014.xlsx", col_types = coltype)
  RedSox_2014$year <- "2014"
  RedSox_2015 <- read_excel("RedSox/RedSox_2015.xlsx", col_types = coltype)
  RedSox_2015$year <- "2015"
  RedSox_2016 <- read_excel("RedSox/RedSox_2016.xlsx", col_types = coltype)
  RedSox_2016$year <- "2016"
  RedSox_2017 <- read_excel("RedSox/RedSox_2017.xlsx", col_types = coltype)
  RedSox_2017$year <- "2017"
  RedSox <- rbind(RedSox_2012, RedSox_2013, RedSox_2014, RedSox_2015, RedSox_2016, RedSox_2017)
  
  #tidy RedSox date and attendance
  TidyDate <- RedSox$Date %>%
    str_remove("Monday ") %>%
    str_remove("Tuesday ") %>%
    str_remove("Wednesday ") %>%
    str_remove("Thursday ") %>%
    str_remove("Friday ") %>%
    str_remove("Saturday ") %>%
    str_remove("Sunday ") %>%
    str_remove(" \\(1\\)") %>%
    str_remove(" \\(2\\)") %>%
    paste(RedSox$year)
  RedSox$DATE <- as.Date(TidyDate, format = "%b %d %Y")
  
  #get canceled games
  RedSoxcg <- RedSox %>%
    filter(! is.na(`Orig. Scheduled`) & is.na(X__2)) %>%
    select(`Orig. Scheduled`) %>%
    mutate(DATE=as.Date(substr(`Orig. Scheduled`, 1, 10)), Attendance=0)
  
  RedSox_Tidy <- bind_rows(RedSox, RedSoxcg) %>%
    filter(is.na(X__2)) %>%
    select(DATE, Attendance)
  
  #import Weather data
  Weather <- read.csv("Weather/Weather_Data.csv")
  Weather$DATE <- Weather$DATE %>%
    str_remove(" 23:59") %>%
    as.Date("%Y/%m/%d")
  Weather$DAILYPrecip_num <- as.numeric(Weather$DAILYPrecip)
  
  #join
  RedSox_Join <- RedSox_Tidy %>%
    left_join(Weather, by = "DATE")
  
  
  output$scatterPlot <- renderPlot({
    
    RedSox_plot <- RedSox_Join %>%
      filter(DATE>min(input$dates) & DATE<max(input$dates))
    
    ggplot(data=RedSox_plot, mapping=aes(x=DATE, y=Attendance, color=DAILYPrecip_num)) +
      geom_point()
    
  })
  
  output$RedSoxPlot <- renderPlot({
    if (input$Temperature == "DAILYMaximumDryBulbTemp") {
      i <- RedSox_Join$DAILYMaximumDryBulbTemp
    }
    if (input$Temperature == "DAILYMinimumDryBulbTemp") {
      i <- RedSox_Join$DAILYMinimumDryBulbTemp
    }
    if (input$Temperature == "DAILYAverageDryBulbTemp") {
      i <- RedSox_Join$DAILYAverageDryBulbTemp
    }
    if (input$Temperature == "DAILYAverageWindSpeed") {
      i <- RedSox_Join$DAILYAverageWindSpeed
    }
    
    ggplot(data = RedSox_Join, mapping = aes(x = i, y = Attendance / max(Attendance))) +
      geom_point() +
      geom_smooth(se = FALSE, linetype = "dashed", color = "red")
    
  })
})
