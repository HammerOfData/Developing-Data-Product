
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)

shinyUI(fluidPage(

  # Application title
  titlePanel("Forecast of Univariate Time-Series"),

  # Sidebar with a slider input for number of bins
  sidebarLayout(
    sidebarPanel(
      h3('Documentation'),
      helpText("This app enables the user to apply various forecast models from the R package 'forecast' on different univariate time-series data sets.",
               br(),
               "The R package 'forecast' have been developed by Professor Rob J. Hyndman.",
               br(),
               br(),
               h4("Instructions:"),
               "1. Choose a data set of interest.",br(),
               "2. Choose a forecast model.",br(),
               "3. Select number of month to forecast."
      ),
      #hr(),
      # Selection box of data sets
      selectInput("ID_DatSet",h4("Choose Data Set"),c("Air Passengers"="air","Deaths in US"="usdeath","Milk Production"="milk","Unemployment Benefits"="dole")),
      #hr(),
      # Radio buttons of models
      radioButtons("ID_Models", label = h4("Choose Forecast Model"),
                   choices = list("LM (Linear Model)" = 1,"Season LM (Linear Model with season estimation)" = 2,  "ARIMA (Autoregressive Integrated Moving Average model)" = 3, "ETS (Exponential smoothing state space model)" = 4), 
                   selected = 1),
      #
      # Slider input determining the number of month to forecast
      sliderInput("ID_Nforecast",
                  h4("Number of Months to Forecast"),
                  min = 0,
                  max = 48,
                  value = 0),
    
      imageOutput("image_sidepanel",width = "100px", height = "150px")
    ),
  
    # Show a plot of the generated distribution
    mainPanel(
      plotOutput("timePlot"),
      
      h4("Data Set Description"),
      textOutput("DataSetDescription"),
      br(),
      h4("Brief Model Description"),
      textOutput("ModelDescription"),
      br(),
      # Download button
      h4("Download Forecasted Values"),
      "Download the forecasted values in a CSV file.",
      downloadButton('downloadData', 'Download')
    )
    
    
    
  )
))
