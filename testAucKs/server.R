library(shiny)
library(dplyr)
library(pROC)
source("KsValue.R")  # 加载辅助计算ks值函数

function(input, output, session){
  # 实现server端应用
  # 
  # Args:
  #   input: ui端定义的输入变量
  #   output：ui端定义的输出变量
  # 
  # Return:
  #   返回一个可交互的web页面
  dataLabel  = reactive({  #
    path1 = input$file1
    path2 = input$file2
    if(is.null(path1)|is.null(path2)){
      return(NULL)
    }
    dataRsult = read.csv(path1$datapath,header = F,as.is = T,encoding = "UTF-8")
    test = read.csv(path2$datapath,header = input$header,as.is = T,
                    sep = input$sep, quote = input$quote, encoding = "UTF-8")[,"label"]
    dataLabel = cbind(dataRsult,test)
    colnames(dataLabel) = c("prediction","label")
    dataLabel
  })
  output$'AUC-KS' <- renderPlot(
    {
      if(is.null(dataLabel())){
        return(NULL)
      }
      ksRsult = KsValue(dataLabel(),input$group)
      ksValue = abs(ksRsult[,1] - ksRsult[,2])
      index = which.max(ksValue)
      value = round(ksValue[index],4)
      par(mfrow = c(1,2))
      roc(dataLabel()[,2], as.vector(dataLabel()[,1]), auc = T,plot = T,print.auc=T)
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
  
  output$summary <- renderPrint({
    if(is.null(dataLabel())){
      return(NULL)
    }else{
      summary(dataLabel()[,1])
    }
  })
  
  output$view <- renderTable({
    head(dataLabel())
  })
  
  output$downloadData <- downloadHandler(
    filename = function() { 
      paste("dataLabel", '.csv', sep='') 
    },
    content = function(file) {
      write.csv(dataLabel(), file)
    }
  )
}




