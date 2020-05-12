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
library(timeSeries)

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
  
  stamps <- seq(begin, endin, 1)
  
  times <- data.frame(stamps)
  # print(times)
  
  result <- left_join(times, data)
  result <- na_interpolation(result)
  
  return(result)
}

# suaviazação das formas de onda

smoothed_data <- function (from, to, f) {
  consumption <- query_date(from, to)
  stamps <- missing_stamps(consumption)
  
  # transformando os dados em uma série temporal
  series <- ts(stamps$watts, start = 0, frequency = 24 * 3600)
  smthed <- smoothLowess(as.timeSeries(series), f = f)
  smthed <- ts(smthed$lowess, start = 0, frequency = 24 * 3600)
  
  result <- data.frame(stamps$stamps, as.numeric(series), as.numeric(smthed))
  result <- as_tibble(result)
  result <- result %>% 
    mutate(stamps = anytime::anytime(stamps.stamps)) %>%
    mutate(watts = as.numeric.series.) %>%
    mutate(smoothed = as.numeric.smthed.) %>%
    select(stamps, watts, smoothed)
  return(result)
}

# como a ideia final é soltar uma base de dados com os padrões, serão amostrados
# os consumos suavizados a cada 30 minutos

half_hour_consumption <- function (data) {
  
  consumption <- data %>% mutate(stamps = as.numeric(paste0(as.integer(anytime::anytime(stamps))),''))
  stamps <- seq(consumption$stamps[1], consumption$stamps[1] + 84600, 1800)
  hours <- c('00:00:00','00:30:00','01:00:00','01:30:00',
             '02:00:00','02:30:00','03:00:00','03:30:00',
             '04:00:00','04:30:00','05:00:00','05:30:00',
             '06:00:00','06:30:00','07:00:00','07:30:00',
             '08:00:00','08:30:00','09:00:00','09:30:00',
             '10:00:00','10:30:00','11:00:00','11:30:00',
             '12:00:00','12:30:00','13:00:00','13:30:00',
             '14:00:00','14:30:00','15:00:00','15:30:00',
             '16:00:00','16:30:00','17:00:00','17:30:00',
             '18:00:00','18:30:00','19:00:00','19:30:00',
             '20:00:00','20:30:00','21:00:00','21:30:00',
             '22:00:00','22:30:00','23:00:00','23:30:00')
  
  sampler <- as_tibble(data.frame(stamps, hours))
  
  result <- inner_join(consumption, sampler) %>% select(smoothed, hours) %>% distinct(hours, .keep_all= TRUE)
  return(result)
}

# transposição para depois transformar tudo em uma tabela apenas

transpose <- function(data) {
  a <- half_hour_consumption(data)
  # print(a)
  cNames <- a$hours
  a <- a %>% select(smoothed)
  a <- t(a)
  colnames(a) <- cNames
  a <- as_tibble(a)
  return(a)
}
