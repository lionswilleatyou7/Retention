# server.R
library(shiny)
library(DT)

server <- function(input, output, session) {
  
  data <- reactive({
    req(input$file)
    read.csv(
      input$file$datapath,
      header = input$header,
      sep = input$sep,
      stringsAsFactors = FALSE
    )
  })
  
  observeEvent(data(), {
    updateSelectInput(session, "x", choices = names(data()))
  })
  
  output$table <- renderDT({
    req(data())
    datatable(data(), options = list(pageLength = 10))
  })
  
  output$summary <- renderPrint({
    req(data(), input$x)
    input$go
    summary(data()[[input$x]])
  })
}