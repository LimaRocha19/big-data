library(tidyverse)
library(mongolite)
library(jsonlite)
library(anytime)
library(astsa, quietly=TRUE, warn.conflicts=FALSE)
library(knitr)
library(printr)
library(lubridate)
library(gridExtra)
library(reshape2)
library(TTR)
library(tseries)
library(mgcv)
library(imputeTS)

# conectando ao banco 
db <- mongo('logs', url = 'mongodb+srv://lima:st10900152@cluster0-6zng5.gcp.mongodb.net/test?retryWrites=true&w=majority')

# realiza a query e retorna os dados com tempos em unixtime
query_date <- function(from, to) {
  query <- list(
    created = list(
      "$gte" = list(
        "$date" = list("$numberLong" = paste0(as.integer(anytime::anytime(from)),'000'))
      ),
      "$lte" = list(
        "$date" = list("$numberLong" = paste0(as.integer(anytime::anytime(to)),'000'))
      )
    )
  )
  
  query_json <- toJSON(query, auto_unbox = TRUE, pretty = TRUE)
  
  result <- db$find(query_json)
  result <- as_tibble(result)
  
  result <- result %>% mutate(stamps = as.numeric(paste0(as.integer(anytime::anytime(created))),'')) %>% select(watts, stamps)
  
  return(result)
}

# como trataremos como uma série temporal, é necessário tratar irregularidades
# para resolver possíveis irregularidades, adicionaremos as lacunas de tempo que foram 'puladas' como valores vazios
# os valores vazios serão interpolados pelas extremidades

missing_stamps <- function (data) {
  
  n <- nrow(data)
  
  # converting to unix time
  begin <- data$stamps[1]
  endin <- data$stamps[n]
  
  stamps <- seq(begin, endin, 1) # step de 4s é o mais observado nas análises
  
  times <- data.frame(stamps)
  # print(times)
  
  result <- left_join(times, data)
  result <- na_interpolation(result)
  
  return(result)
}

