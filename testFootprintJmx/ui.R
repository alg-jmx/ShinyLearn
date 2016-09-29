library(shiny)

shinyUI(fluidPage(
  
    titlePanel("test shiny with footprint"),
    
    sidebarLayout(
      # sidebarPanel(),
      mainPanel(
        uiOutput("map")
      )
    )
  )
)