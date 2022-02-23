################################################################################################
# Project: Web Scrapping 
# Author: Gaurav Modi
# Description: Get Top Moving Stocks from Zacks.com and prepare watchlist for Tradingview
# Version:
# note: will use glue package instead of paste0 
#       To Automate the script, use crontab -e on terminal  
################################################################################################

library(rvest)
library(stringr)
#library(cronR)
#library(taskscheduleR)

zacks <- read_html("https://www.zacks.com/")

bull_of_the_day <- zacks %>% html_node(xpath = "//*[@id='bull_bear_of_the_day']") %>% html_children() %>% html_node("span") %>% html_attr("title")
bull_of_the_day <- str_extract_all(bull_of_the_day,  "(?<=\\().+?(?=\\))")

zacksList <-  NULL
for(i in 1:5)
  {
  for(j in 1:5)
    {
    zacksList <- paste0(zacks %>% html_node(xpath = paste0("/html/body/div[5]/div[2]/section[2]/div/section[1]/div[",i,"]/table/tbody/tr[",j,"]/td[1]/a")) %>% html_attr("rel"),",",zacksList)
    }
}
#/html/body/div[5]/div[2]/section[2]/div/section[2]/table/tbody/tr[1]/td[1]/a

zacksAddition <- NULL
for(k in 1:5)
{
  zacksAddition <- paste0(zacks %>% html_node(xpath = paste0("/html/body/div[5]/div[2]/section[2]/div/section[2]/table/tbody/tr[",k,"]/td[1]/a")) %>% html_attr("rel"),",",zacksAddition)
}

watchList <- gsub(",$", "", paste0(bull_of_the_day[[1]],",",zacksList,zacksAddition))
write.csv(watchList, paste0(format(Sys.time(), "%d-%b-%Y %H.%M"), "watchList.txt"), col.names = FALSE, row.names = FALSE, quote = FALSE)




