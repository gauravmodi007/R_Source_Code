##########################################################################
## Project: BigQuery in R
## Description: Connect to Google BigQuery and perform data analysis 


##########################################################################

install.packages('devtools')
devtools::install_github("r-dbi/bigrquery")

library(bigrquery)
library(DBI)
library(dplyr)

con <- dbConnect(
  bigrquery::bigquery(),
  project = "finl-1067321-eds-dm",
  dataset = "finance_dm"
)
con 
dbListTables(con)

tlog_sales <- tbl(con, "tlog_sales")
class(tlog_sales)
str(tlog_sales)

df <- tlog_sales %>% head(10) %>% collect()
glimpse(df)

#natality %>% select(year, month, day, weight_pounds) %>% head(10) %>% collect()


USACPBB52O220C