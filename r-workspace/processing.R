library(tidyverse)
library(mongolite)
library(jsonlite)
library(anytime)

# conectando ao banco 
db <- mongo('logs', url = 'mongodb+srv://lima:st10900152@cluster0-6zng5.gcp.mongodb.net/test?retryWrites=true&w=majority')

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
  
  return(result)
}
