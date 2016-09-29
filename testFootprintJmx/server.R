library(shiny)
library(REmap)


function(input,output){
  data<-read.csv('D:\\Rworkspace\\Footprint-of-jmx\\Footprint-of-jmx.csv',encoding='utf-8')
  output$map <- renderUI({
    remap(data,title = 'Footprint-of-jmx in recent years',subtitle = '足迹',theme = get_theme('Dark'))
  }
  )
}
