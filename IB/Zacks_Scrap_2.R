

library(rvest)
library(stringr)
#library(tidytext)
#library(tidyverse)

setwd("/Users/0327409/Documents/Projects/IB")
getwd()

#####  08/16 
#==========

## Read The RDS
zacksData <- readRDS(file = "data.Rds")
zacks <- read_html("https://www.zacks.com/")

bull_of_the_day <- zacks %>% html_node(xpath = "//*[@id='bull_bear_of_the_day']") %>% html_children() %>% html_node("span") %>% html_attr("title") %>% str_extract_all("(?<=\\().+?(?=\\))")
zacks_1_addition <- zacks %>% 
                    html_node(xpath = "//*[@id='zacks_number_one_rank_additions']") %>% 
                    html_node("tbody")  %>% html_children() %>% 
                    html_node("a") %>% html_attr("rel")

zacks_stocks <- append(toString(Sys.Date()),c(zacks_1_addition, bull_of_the_day[[1]],bull_of_the_day[[2]]),1)
zacksdf <- data.frame(t(zacks_stocks))

colnames(zacksdf) = c("Date","Stock1","Stock2","Stock3","Stock4","Stock5","Bull_Of-The_Day","Bear_Of_The_Day")
zacksData <- rbind(zacksData,zacksdf)

## Write Data
saveRDS(zacksData, file = "data.Rds")




