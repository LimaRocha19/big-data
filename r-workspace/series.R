library(timeSeries)

# executar o script processing.R primeiro

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



