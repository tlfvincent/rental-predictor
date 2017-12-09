library(xts)
#library(shiny)
library(bsts)
library(readr)
library(dplyr)
source("utils.R")

# extract data
rawdata <- list()
rawdata[['Studio']] <- read_csv('./data/Neighborhood_MedianRentalPrice_Studio.csv')
rawdata[['OneBedroom']] <- read_csv('./data/Neighborhood_MedianRentalPrice_1Bedroom.csv')
rawdata[['TwoBedrooms']] <- read_csv('./data/Neighborhood_MedianRentalPrice_2Bedroom.csv')
rawdata[['ThreeBedrooms']] <- read_csv('./data/Neighborhood_MedianRentalPrice_3Bedroom.csv')


server <- function(input, output) {

  output$Neighborhoods <- renderUI({
      rents <- rawdata[[input$size]]
      neighborhoods <- getCityNeighborhoods(rents, input$city)
      selectizeInput(inputId = "neighborhood", 
                     label = "Neighborhood of Interest",
                     choices = neighborhoods)
  })

  data <- reactive({

    validate(
      need(input$city != "", "Please select a city and neighborhood")
    )

    rents <- rawdata[[input$size]]
    dat <- getTimeSeries(rents, input$city, input$neighborhood)
    hw <- HoltWinters(dat)
    pred <- predict(hw,
                    n.ahead = 24, 
                    prediction.interval = TRUE,
                    level = 0.9)

    all <- cbind(dat, pred)
    #transform to xts
    all
    # ss <- AddLocalLinearTrend(list(), vec)
    # ss <- AddSeasonal(ss, vec, nseasons = 12)
    # fit <- bsts(ts,
    #             state.specification = ss,
    #             niter = 1000)
  })

  title_plot <- reactive({
    title <- sprintf("Median Rental Prices for %s in %s",
                     input$neighborhood,
                     input$city)
    title

  })

  seasonality <- reactive({
      validate(
        need(input$city != "", "")
      )

      rents <- rawdata[[input$size]]
      dat <- getTimeSeries(rents, input$city, input$neighborhood)
      fit_decompose <- decompose(dat, type='multiplicative')
      fit_decompose$seasonal-1
  })

  title_plot_seasonality <- reactive({
    title <- sprintf("Seasonal Rental Variations %s in %s",
                     input$neighborhood,
                     input$city)
    title

  })

  output$plot_fit <- renderDygraph({

        dygraph(data(),
                main = title_plot(),
                ylab = "Median Rental Price (in $)") %>%
                dySeries("dat", label = "Actual", color = "white", strokeWidth=1.5) %>%
                dySeries(c("pred.lwr", "pred.fit", "pred.upr"),
                         label = "Forecasted", color = "white", strokeWidth=1.5) %>%
                dyOptions(drawGrid = TRUE, axisLineColor = "white", drawPoints = TRUE, pointSize = 2) %>%
                #dyAxis("x", drawGrid = TRUE) %>%
                dyLegend(show = "never") %>%
                dyRangeSelector(height = 60) %>%
                dyCSS("./static/dygraph.css")

  })

  output$plot_seasonality <- renderDygraph({

        dygraph(seasonality(),
                main = title_plot_seasonality(),
                ylab = "Median Rental Price (in $)") %>%
                dySeries("V1", color = "white", strokeWidth=1.5) %>%
                dyOptions(drawGrid = TRUE, drawPoints = TRUE, pointSize = 2) %>%
                dyAxis("x", drawGrid = TRUE) %>%
                dyLegend(show = "never") %>%
                dyRangeSelector(height = 60)

  })

}