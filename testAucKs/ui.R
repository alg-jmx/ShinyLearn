library(shiny)

shinyUI(
  fluidPage(
    titlePanel("model AUC_KS value plot"),
    sidebarLayout(
      sidebarPanel(
        textOutput("currentTime"),
        br(),
        sliderInput("group", "groups to cut", min = 10,max = 50,value = 20)
      ),
      
      mainPanel(
        plotOutput("AUC-KS")
      )
    )
  )
)