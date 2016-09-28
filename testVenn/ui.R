library(shiny)

shinyUI(fluidPage(
  titlePanel("test Venn plot"),
  sidebarLayout(
    sidebarPanel(
      selectInput("dataGroup","choose a data group",
                  choices = c("all","AB","AC","BC"))
    ),
    mainPanel(
      plotOutput("vennPlot")
    )
  )
))



