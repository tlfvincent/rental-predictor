library(shiny)
library(shinythemes)
library(readr)
library(dplyr)
library(dygraphs)

# extract list of available cities
cities <- read_csv('./data/Neighborhood_MedianRentalPrice_1Bedroom.csv') %>%
          distinct(City) %>%
          select(City) %>%
          unlist(use.names = FALSE)

shinyUI(navbarPage(
  theme = shinytheme("superhero"),
  strong("Neighborhood Rental Predictor"),
  tabPanel("Data Summary",
          sidebarLayout(
             sidebarPanel(
                width=3,
                radioButtons(inputId = "size",
                            label=strong("Bedroom size"),
                            choices = list("Studio" = "Studio",
                                           "1 bedroom" = "OneBedroom",
                                           "2 bedrooms" = "TwoBedrooms",
                                           "3 bedrooms" = "ThreeBedrooms"),
                            selected = "OneBedroom"),
 
                selectizeInput(
                        inputId = "city", 
                        label = "City of Interest",
                        choices = cities,
                        selected = 'New York'
                ),

                uiOutput("Neighborhoods")

             ),
             
             mainPanel(fluidRow(
               
               column(12, h3(""), dygraphOutput("plot_fit")),
               column(12, h3(""), dygraphOutput("plot_seasonality")),
               column(12, h3(""), plotOutput("plot_boxplots"))
               #column(12, h3("Data"), dataTableOutput("data_table"))
               #column(12, h3("Summary"), verbatimTextOutput("data_summary"))
               
               
               )
             )
           )
          ),

  tabPanel("Information",
           h3(strong("Summary")),
           br(),
           p("This App can be used as a simple tool to visualize and forecast
              median rental prices in different neighborhoods of US cities.", align="Justify"),
           p("The first graph shows median rental priceds for the last five years, and shows expected
              values for the next 12 months. In addition, we also display the 90% confidence interval
              of the forecats. The forecasts are obtained using the Holt-Winters methods available in the
              R stats package. The second plot displays the seasonality of the median rental prices in
              different neighborhoods of US cities. Finally, the third plot shows the rank of the
              neighborhood with respect to other neighborhoods in the same city.",align="Justify"),
           
           br(),
           h3(strong("Author")),
           p("Author: Thomas L. Vincent, Ph.D."),
           p("Senior Data Science Engineer @ DigitalOcean"),
           HTML('<Left><img src="https://www.digitalocean.com/assets/media/logos-badges/png/DO_Logo_icon_white-edbadfef.png" width="50" height="50"></Left>'),
           h5("Linkedin"),
           p(strong('If you are interested in the orginal code of this app, you can find it on the Github page linked below.')),
           a(h5("Click here to see the code"), href="https://github.com/tlfvincent/rental-predictor", target="_blank")
  )

))
