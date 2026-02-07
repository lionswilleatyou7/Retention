# ui.R
library(shiny)
library(DT)

ui <- fluidPage(
  titlePanel("Retention Dashboard"),
  
  sidebarLayout(
    sidebarPanel(
      fileInput("file", "Upload a CSV file", accept = c(".csv")),
      checkboxInput("header", "Header row", TRUE),
      radioButtons(
        "sep", "Separator",
        choices = c(Comma = ",", Semicolon = ";", Tab = "\t"),
        selected = ","
      ),
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