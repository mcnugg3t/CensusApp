library(shiny)

source("helpers.R")
library(maps)
library(mapproj)
counties <- readRDS("data/counties.rds")

ui <- fluidPage (
  titlePanel("census visualizer"),
  
  sidebarLayout(
    sidebarPanel(
      
      helpText("Create chloropleth maps to visualize ethnicity data from the US 2010 census"),
      
      selectInput("var",
                  label = "Choose an Ethnicity to Map",
                  choices = c("Percent White", "Percent Black",
                              "Percent Hispanic", "Percent Asian"),
                  selected = "Percent White"),
      
      sliderInput("range", label = "Range to Visualize:",
                  min = 0, max = 100, value=c(0,100))
      
    ),
    
    mainPanel(plotOutput("map"))
  )
)

server <- function(input, output) {
  
  output$map <- renderPlot({
    
    data <- switch(input$var,
                   "Percent White" = counties$white,
                   "Percent Black" = counties$black,
                   "Percent Hispanic" = counties$hispanic,
                   "Percent Asian" = counties$asian)
    
    color <- switch(input$var,
                    "Percent White" = "darkblue",
                    "Percent Black" = "purple",
                    "Percent Hispanic" = "darkgreen",
                    "Percent Asian" = "darkred")
    
    
    percent_map(data, color, 
                legend.title = paste(input$var, "by Census Designated Area"), 
                input$range[1], 
                input$range[2])
  })
  
}

shinyApp(ui = ui, server = server)