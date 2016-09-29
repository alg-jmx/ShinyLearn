library(shiny)
library(VennDiagram)
oneName = function() paste(sample(LETTERS,5,replace=TRUE),collapse="")
geneNames = replicate(1000, oneName())
A = sample(geneNames, 400, replace=FALSE)
B = sample(geneNames, 750, replace=FALSE)
C = sample(geneNames, 250, replace=FALSE)

function(input,output){
  dataSet <- reactive({
    switch(input$dataGroup,
           "all" = list(A = A,B = B,C = C),
           "AB" = list(A = A,B = B),
           "AC" = list(A = A,C = C),
           "BC" = list(B = B,C = C))
  })
  output$vennPlot <-renderPlot({
    # venn(dataSet(),intersections = T)
    T<-venn.diagram(dataSet(),filename=NULL,
                    col = 1:length(dataSet()),fill = 1:length(dataSet()),
                    cat.col = 1:length(dataSet()),cat.pos = 2,
                    rotation.degree=180)
    grid.draw(T)
  })
}
