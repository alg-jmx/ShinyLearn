library(shiny)

shinyUI(
  fluidPage(
    titlePanel("model AUC_KS value plot"),
    sidebarLayout(
      sidebarPanel(
        textOutput("currentTime"),
        fileInput('file1', 'Choose One CSV File',
                  accept=c('text/csv', 
                           'text/comma-separated-values,text/plain', 
                           '.csv')),
        fileInput('file2', 'Choose Another CSV File',
                  accept=c('text/csv', 
                           'text/comma-separated-values,text/plain', 
                           '.csv')),
        tags$hr(),
        checkboxInput('header', 'Header', TRUE),
        radioButtons('sep', 'Separator',
                     c(Comma=',',
                       Semicolon=';',
                       Tab='\t'),
                     ','),
        radioButtons('quote', 'Quote',
                     c(None='',
                       'Double Quote'='"',
                       'Single Quote'="'"),
                     '"'),
        br(),
        sliderInput("group", "groups to cut", min = 10,max = 50,value = 20),
        br(),
        submitButton("Update View"),
        br(),
        downloadButton('downloadData', 'Download')
      ),
      
      mainPanel(
        h4("AUC-KS Plot"),
        plotOutput("AUC-KS"),
        h4("summary"),
        verbatimTextOutput("summary"),
        h4("前6行"),
        tableOutput("view")
      )
    )
  )
)