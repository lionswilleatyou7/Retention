library(shiny)
library(DT)

ui <- fluidPage(
  titlePanel("Retention Dashboard"),
  
  sidebarLayout(
    sidebarPanel(
      fileInput("file", "Upload a CSV file", accept = c(".csv")),
      checkboxInput("header", "Header row", TRUE),
      radioButtons("sep", "Separator",
                   choices = c(Comma = ",", Semicolon = ";", Tab = "\t"),
                   selected = ","),
      hr(),
      selectInput("x", "Pick a column for a quick summary", choices = NULL),
      actionButton("go", "Run")
    ),
    
    mainPanel(
      tabsetPanel(
        tabPanel("Data", DTOutput("table")),
        tabPanel("Summary", verbatimTextOutput("summary"))
      )
    )
  )
)

server <- function(input, output, session) {
  # Read data reactively when a file is uploaded
  data <- reactive({
    req(input$file)
    read.csv(
      input$file$datapath,
      header = input$header,
      sep = input$sep,
      stringsAsFactors = FALSE
    )
  })
  
  # Update column choices once data exists
  observeEvent(data(), {
    updateSelectInput(session, "x", choices = names(data()))
  })
  
  # Show table
  output$table <- renderDT({
    req(data())
    datatable(data(), options = list(pageLength = 10))
  })
  
  # Example "run" action: produce a simple summary
  output$summary <- renderPrint({
    req(data())
    req(input$x)
    input$go  # makes this wait for the button
    summary(data()[[input$x]])
  })
}

shinyApp(ui, server)