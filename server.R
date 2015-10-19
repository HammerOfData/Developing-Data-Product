
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

## Load relevant Packages
library(shiny)
library(forecast)
library(fma)
library(wq)

## Load data sets
data_air <- airpass
data_usdeath <- usdeaths
data_milk <- milk 
data_dole <- dole

## Shiny Server function
shinyServer(function(input, output) {

  # Render a image based on the selected data set
  output$image_sidepanel <- renderImage({
    filename <- normalizePath(file.path('./images',
                                        paste('image_', input$ID_DatSet, '.jpg', sep='')))
    
    # Return a list containing the filename and alt text
    list(src = filename,
         alt = paste("Image number", input$ID_DatSet))
    
  }, deleteFile = FALSE)
  
  output$DataSetDescription <- renderText({ 
    "The classic Box & Jenkins airline data. Monthly totals of international airline passengers (1949 to
    1960)."
  })
  "Monthly accidental deaths in USA"

  # Render the time-series plot
  output$timePlot <- renderPlot({
    
    # Get the selected data set
    data <- get(paste0('data_',input$ID_DatSet)) 
    
    if (input$ID_Nforecast > 0){ # Only build model if a number of periods for forecasting is selected
      
      # ARIMA Model
      if(input$ID_Models==3){
        #fit <- arima(data, c(0, 1, 1),seasonal = list(order = c(0, 1, 1), period = 12))
        fit <-auto.arima(data)
        fcast <- forecast(fit,h = input$ID_Nforecast)
        plot(fcast,fcol = 2,plot.conf=TRUE,flty=2,xlab="Time",main="")
        FcastCol <- 2
      }
      
      # ETS Model
      if(input$ID_Models==4){
        fit <- ets(data)
        fcast <- forecast(fit,h = input$ID_Nforecast)
        plot(fcast,fcol = 4,plot.conf=TRUE,flty=2,xlab="Time",main="")
        FcastCol <- 4
      }
      
      # LM 
      if(input$ID_Models==1){
        fit<- tslm(data ~ trend)
        fcast <- forecast(fit,h = input$ID_Nforecast)
        plot(fcast,fcol = 6,plot.conf=TRUE,flty=2,xlab="Time",main="")
        FcastCol <- 6
      }
      
      # LM + season
      if(input$ID_Models==2){
        fit<- tslm(data ~ trend+season)
        fcast <- forecast(fit,h = input$ID_Nforecast)
        plot(fcast,fcol = 7,plot.conf=TRUE,flty=2,xlab="Time",main="")
        FcastCol <- 7
      }
      # Add legend to charts
      legend("topleft",c("Historic Data","Forecast","80% Confidence Interval","95% Confidence Interval"),lty=c(1,2,1,1),lwd=c(2,2,12,12),col=c(1,FcastCol,rgb(177,181,206,maxColorValue = 255),rgb(219,219,223,maxColorValue = 255)))
    } 
    else {
      plot(get(paste0('data_',input$ID_DatSet)),ylab="")
    }
    
    ## Label the plot with proper text based on the data set selected and provide data set description
    if (input$ID_DatSet=="air"){ 
      title(main="Airpassenger Time Series", ylab="Number of passengers (in thousands)" )
      
      output$DataSetDescription <- renderText({ 
        "Monthly totals of international airline passengers (1949 to
        1960)."
      })
    }
              
    if (input$ID_DatSet=="usdeath"){ 
      title(main="Accidental deaths in US", ylab="People died by accident")
      
      output$DataSetDescription <- renderText({ 
        "Monthly accidental deaths in USA."
      })
    }
    
    if (input$ID_DatSet=="milk"){ 
      title(main="Average monthly milk production per cow", ylab="Pounds of Milk")
      
      output$DataSetDescription <- renderText({ 
        "Average monthly milk production per cow over 14 years."
      })
    }
    
    if (input$ID_DatSet=="dole"){ 
      title(main="People on unemployment benefits in Australia", ylab="Number of People")
      
      output$DataSetDescription <- renderText({ 
        "Monthly total of people on unemployment benefits in Australia (Jan 1965 to Jul 1992)."
      })
    }
    
   ## Provide Model Description
    if (input$ID_Models==1){ 
      output$ModelDescription<- renderText({ 
        "Simple Linear Model."
      })
    }
    if (input$ID_Models==2){ 
      output$ModelDescription<- renderText({ 
        "Linear Model including seasonality as a component."
      })
    }
    if (input$ID_Models==3){ 
      output$ModelDescription<- renderText({ 
        "Autoregressive Integrated Moving Average model. The function conducts a
search over possible models within the default order of constraints provided and return the best possible using the Aikido Information  Criterion. "
      })
    }
    if (input$ID_Models==4){ 
      output$ModelDescription<- renderText({ 
        "Exponential smoothing state space model.
        The function applies a framework that automatically select the best method of different exponential smoothing models and Holt-Winters methods."
        })
    }
    
    # Format output data
    if (input$ID_Nforecast > 0){
    ForecastData <- fcast
    ForecastData$mean <-round(ForecastData$mean,digits = 2)
    ForecastData$lower<-round(ForecastData$lower,digits = 2)
    ForecastData$upper<-round(ForecastData$upper,digits = 2)
    }
    # Download dataset
    output$downloadData <- downloadHandler(
           filename = function() {
             paste('data-', Sys.Date(), '.csv', sep='')
           },
          content = function(file) {
             write.csv(ForecastData, file)
      }
      )
    
  })

})




### OLD CODE ###
#par(mfrow = c(1, 1))
#plot(get(paste0('data_',input$ID_DatSet)),ylab="")
#plot(paste('data_',input$ID_DatSet))
## generate bins based on input$bins from ui.R
#x    <- faithful[, 2]
#bins <- seq(min(x), max(x), length.out = input$bins + 1)

## draw the histogram with the specified number of bins
#hist(x, breaks = bins, col = 'darkgray', border = 'white')
