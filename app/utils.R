library(readr)
library(dplyr)

getCityNeighborhoods <- function(rents, city) {
    neighborhoods <- rents %>%
                        dplyr::filter(City==city) %>%
                        dplyr::select(RegionName) %>%
                        unlist(use.names = FALSE)

    return(neighborhoods)
}

getTimeSeries <- function(rents, city, neighborhood) {
    time_series <- rents %>%
                      dplyr::filter(City==city) %>%
                      dplyr::filter(RegionName==neighborhood) %>%
                      dplyr::select(starts_with("20")) %>%
                      unlist(use.names = TRUE) %>%
                      na.omit()

    min_date <- min(names(time_series))
    max_date <- max(names(time_series))
    min_year <- as.numeric(substr(min_date, 0, 4))
    min_month <- as.numeric(substr(min_date, 6, 7))
    max_year <- as.numeric(substr(max_date, 0, 4))
    max_month <- as.numeric(substr(max_date, 6, 7))

    dat <- ts(time_series,
              frequency = 12,
              start=c(min_year, min_month),
              end=c(max_year, max_month))

    return(dat)
}

