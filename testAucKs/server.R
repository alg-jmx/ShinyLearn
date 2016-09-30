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
  dataLabel  = reactive({  # reactive限定在render*函数体外使用input输入数据
    # 获取预测数据+真实label
    #
    # Return:
    #   返回一个函数体
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
    # 输出AUC-KS图
    {
      if(is.null(dataLabel())){
        return(NULL)
      }
      ksRsult = KsValue(dataLabel(),input$group)  # 计算KS值函数
      ksValue = abs(ksRsult[,1] - ksRsult[,2])
      index = which.max(ksValue)
      value = round(ksValue[index],4)
      par(mfrow = c(1,2))  # 限定图形是一行两列
      roc(dataLabel()[,2], as.vector(dataLabel()[,1]), auc = T,plot = T,print.auc=T)
      plot(ksRsult[,1],type = "l",col = 3,main = "KS plot")
      lines(ksRsult[,2],col = 2)
      segments(index,ksRsult[,2][index],index,ksRsult[,1][index],col = "blue")  # 添加KS值区间线段
      text((input$group+4)/2,0.4,paste("ksValue = ",value))
      par(mfrow = c(1,1))
    }
  )
  output$currentTime <- renderText({
    # 输出字符串
    # 
    # Return:
    #   返回系统当前时间
    invalidateLater(1000, session)
    paste("The current time is", Sys.time())
  })
  
  output$summary <- renderPrint({
    # 任何打印输出
    # 
    # Return:
    #   返回数据集的统计信息
    if(is.null(dataLabel())){
      return(NULL)
    }else{
      summary(dataLabel()[,1])
    }
  })
  
  output$view <- renderTable({
    # 输出数据框、矩阵以及其他表格形式
    # 
    # Return:
    #   返回数据集的前六列
    head(dataLabel())
  })
  
  output$downloadData <- downloadHandler(
    # 下载数据集
    # 
    # Return:
    #   无返回值，直接给出路径选择弹窗
    filename = function() { 
      paste("dataLabel", '.csv', sep='') 
    },
    content = function(file) {
      write.csv(dataLabel(), file)
    }
  )
}




