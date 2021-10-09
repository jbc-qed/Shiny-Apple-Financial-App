# Jordan Carouth's apple financial app.R file

library(shiny)
library(ggplot2)
library(lubridate)
library(dplyr)
library(haven)
library(ggthemes)


ui <- fluidPage(
  
  titlePanel("Apple Financials"),
  
  sidebarLayout(
    sidebarPanel(
      width = 3,
      fileInput("dt", "Upload SAS Data:"),
      selectInput("xvar",
                  "X-Axis Variable:",
                  choices = c("Sales", 
                              "Cash",
                              "Assets",
                              "Profits",
                              "R&D",
                              "SG&A")),
      selectInput("yvar",
                  "Y-Axis Variable:",
                  choices = c("Sales", 
                              "Cash",
                              "Assets",
                              "Profits",
                              "R&D",
                              "SG&A"),
                  selected = "R&D"),
      selectInput("scaling",
                  "Choose the Scale:",
                  choices = c("Levels", 
                              "Log 10")),
      radioButtons("model",
                   "Choose the Model:",
                   choices = c("Linear Model",
                               "LOESS",
                               "None"),
                   selected = "LOESS"),
      checkboxInput("ribbon",
                    "Standard Error Ribbon",
                    value = T)
    ),
    mainPanel(plotOutput("plot"))
  )
)

server <- function(input, output){
  
  output$plot <- renderPlot({
    input_message <- c("Please upload a SAS data file (sas7bdat extension)
Make sure that it has the following variables:
SALEQ, CHEQ, ATQ, OIADPQ, XRDQ, XSGAQ")
    validate(need(input$dt != "", input_message))
    
    aapl <- read_sas(input$dt$datapath)
    
    xvar <- switch(input$xvar,
                   "Sales" = "SALEQ",
                   "Cash" = "CHEQ",
                   "Assets" = "ATQ",
                   "Profits" = "OIADPQ",
                   "R&D" = "XRDQ",
                   "SG&A" = "XSGAQ")
    
    yvar <- switch(input$yvar,
                   "Sales" = "SALEQ",
                   "Cash" = "CHEQ",
                   "Assets" = "ATQ",
                   "Profits" = "OIADPQ",
                   "R&D" = "XRDQ",
                   "SG&A" = "XSGAQ")
    
    xtitle <- switch(input$xvar,
                     "Sales" = "Sales (million $)",
                     "Cash" = "Cash (million $)",
                     "Assets" = "Assets (million $)",
                     "Profits" = "Profits (million $)",
                     "R&D" = "R&D (million $)",
                     "SG&A" = "SG&A (million $)")
    
    ytitle <- switch(input$yvar,
                     "Sales" = "Sales (million $)",
                     "Cash" = "Cash (million $)",
                     "Assets" = "Assets (million $)",
                     "Profits" = "Profits (million $)",
                     "R&D" = "R&D (million $)",
                     "SG&A" = "SG&A (million $)")
    
    mill <- function(x){x/10^6}
    imill <- function(x){x*10^6}
    scaling <- switch(input$scaling,
                      "Levels" = scales::trans_new("mill", mill, imill),
                      "Log 10" = "log10")
    
    lmethod <- switch(input$model,
                      "Linear Model" = "lm",
                      "LOESS" = "loess",
                      "None" = NULL)
    
    if (is.null(lmethod)) {
      ggplot(aapl, aes_string(xvar, yvar)) +
        geom_point() +
        labs(x = xtitle, y = ytitle) +
        scale_x_continuous(trans = scaling) +
        scale_y_continuous(trans = scaling) +
        theme_gdocs()
    } else {
      ggplot(aapl, aes_string(xvar, yvar)) +
        geom_point() +
        geom_smooth(method = lmethod, se = input$ribbon) +
        labs(x = xtitle, y = ytitle) +
        scale_x_continuous(trans = scaling) +
        scale_y_continuous(trans = scaling) +
        theme_gdocs()
    }
  })
}


shinyApp(ui = ui, server = server)
