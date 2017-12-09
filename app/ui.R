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
               column(12, h3(""), dygraphOutput("plot_seasonality"))
               #column(12, h3("Data"), dataTableOutput("data_table"))
               #column(12, h3("Summary"), verbatimTextOutput("data_summary"))
               
               
               )
             )
           )
          ),

  tabPanel("Information",
           h3(strong("Introduction")),
           br(),
           p("This App can be used as a simple tool to test when should a specific smoothing forecasting technique be implemented. Seven models are embeded within App",align="Justify"),
           p("The first part presents the summary of data you choose to analyze. The user can either upload his/her own data or use the demo data inside the R package 'fma' (airpass). Then the user should choose the column of data frame that contains the data requiring analysis. The frequency of data and the beginning/ending periods of both fitting sample and hold out sample can be set afterward. ",align="Justify"),
           p("Then the user can compare different forecasting techniques by switching to different tab panels. You can creat your own training and testing set in the data summary panel by yourself, and explore the in-sample and out-sample accuracies of the model.",align="Justify"),
           
           p("In case users want to upload their own data set, the suggested form of data frame is that time in the first column and observation in the second column. However, once the location of observations is consistent with the column input, the app will definitely work. (Do not forget to set the frequency in case you want to test Holt winter model!)",align="Justify"),
           br(),
           h3(strong("Author")),
           p("Author: Thomas L. Vincent, Ph.D."),
           p("Senior Data Science Engineer @ DigitalOcean"),
           HTML('<Left><img src="https://www.digitalocean.com/assets/media/logos-badges/png/DO_Logo_icon_white-edbadfef.png" width="50" height="50"></Left>'),
           h5("Linkedin"),
           p(strong('If you are interested in the orginal code of this app, you can find it on my Github page. Link is presented below.')),
           a(h5("Code Here"), href="https://github.com/tlfvincent/rental-predictor", target="_blank")
  )

))
