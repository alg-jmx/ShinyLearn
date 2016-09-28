library(shiny)
source("KsValue.R")

Path <- dir("result/")
dataRsult <- data.frame()
for(path in Path){
  file = paste("result/",path,sep = "")
  dataRsult = rbind(dataRsult,read.csv(file,header = F,as.is = T,encoding = "UTF-8"))
}

test = read.csv("test.csv",header = T,as.is = T,encoding = "UTF-8")[,"label"] 

dataLabel = cbind(dataRsult,test)
colnames(dataLabel) = c("prediction","label")
function(input, output, session){
  output$'AUC-KS' <- renderPlot(
    {
      ksRsult = KsValue(dataLabel,input$group)
      ksValue = abs(ksRsult[,1] - ksRsult[,2])
      index = which.max(ksValue)
      value = round(ksValue[index],4)
      par(mfrow = c(1,2))
      roc(test, as.vector(dataRsult[,1]), auc = T,plot = T,print.auc=T)
      plot(ksRsult[,1],type = "l",col = 3,main = "KS plot")
      lines(ksRsult[,2],col = 2)
      segments(index,ksRsult[,2][index],index,ksRsult[,1][index],col = "blue")
      text((input$group+4)/2,0.4,paste("ksValue = ",value))
      par(mfrow = c(1,1))
    }
  )
  output$currentTime <- renderText({
    invalidateLater(1000, session)
    paste("The current time is", Sys.time())
  })
}




