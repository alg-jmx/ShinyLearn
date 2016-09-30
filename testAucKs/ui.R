library(shiny)

shinyUI(
  fluidPage(
    titlePanel("model AUC_KS value plot"),  # 设置UI名称
    sidebarLayout(  # 页面分层
      sidebarPanel(  # 辅助面板（主要包含各种控件）
        textOutput("currentTime"),  # 定义输出文本
        fileInput('file1', 'Choose One CSV File',  # 定义路径选择
                  accept=c('text/csv', 
                           'text/comma-separated-values,text/plain', 
                           '.csv')),
        fileInput('file2', 'Choose Another CSV File',
                  accept=c('text/csv', 
                           'text/comma-separated-values,text/plain', 
                           '.csv')),
        tags$hr(),
        checkboxInput('header', 'Header', TRUE), # 单选控件
        radioButtons('sep', 'Separator',  # 多选控件
                     c(Comma=',',
                       Semicolon=';',
                       Tab='\t'),
                     ','),
        radioButtons('quote', 'Quote',
                     c(None='',
                       'Double Quote'='"',
                       'Single Quote'="'"),
                     '"'),
        br(),  # 换行
        sliderInput("group", "groups to cut", min = 10,max = 50,value = 20),  # 滑条选择控件
        br(),
        submitButton("Update View"),  # 更新提交控件
        br(),
        downloadButton('downloadData', 'Download')  # 下载控件
      ),
      
      mainPanel(  # 主面板
        h4("AUC-KS Plot"),  # h4字体
        plotOutput("AUC-KS"),  # 定义输出图
        h4("summary"),
        verbatimTextOutput("summary"),  # 逐字输出文本
        h4("前6行"),
        tableOutput("view")  # 表格输出
      )
    )
  )
)