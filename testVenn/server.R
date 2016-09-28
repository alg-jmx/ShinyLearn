library(shiny)
library(gplots)
oneName = function() paste(sample(LETTERS,5,replace=TRUE),collapse="")
geneNames = replicate(1000, oneName())
A = sample(geneNames, 400, replace=FALSE)
B = sample(geneNames, 750, replace=FALSE)
C = sample(geneNames, 250, replace=FALSE)

function(input,output){
  dataSet <- reactive({
    switch(input$dataGroup,
           "all" = list(A,B,C),
           "AB" = list(A,B),
           "AC" = list(A,C),
           "BC" = list(B,C))
  })
  output$vennPlot <-renderPlot({
    venn(dataSet(),intersections = T)
  })
}
