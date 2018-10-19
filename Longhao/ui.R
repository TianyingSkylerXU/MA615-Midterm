library(shiny)

shinyServer(
  pageWithSidebar(
    headerPanel("Celtics attendence against weather"),

    sidebarPanel(
      selectInput("Weather", "Please Select Weather factors",
        choices = c("Temperature", "Precipitation", "Snow", "Matches")
      )
    ),
    mainPanel(
      plotOutput("scatterPlot")
    )
  )
)
