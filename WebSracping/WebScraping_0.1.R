
library(rvest)
library(dplyr)

hot100page <- "https://www.billboard.com/charts/hot-100"
hot100 <- read_html(hot100page)
hot100
str(hot100)


body_nodes <- hot100 %>% html_node("body") %>% html_children()
body_nodes

body_nodes %>% html_children()

rank <- hot100 %>% rvest::html_nodes('body') %>% xml2::xml_find_all("//span[contains(@class, 'chart-element__rank__number')]") %>% rvest::html_text()

artist <- hot100 %>% rvest::html_nodes('body') %>% xml2::xml_find_all("//span[contains(@class, 'chart-element__information__artist')]") %>% rvest::html_text()

title <- hot100 %>% rvest::html_nodes('body') %>% xml2::xml_find_all("//span[contains(@class, 'chart-element__information__song')]") %>% rvest::html_text()

chart_df <- data.frame(rank, artist, title)
knitr::kable(chart_df  %>% head(10))
             
             
fl <- "https://www.footlocker.com/category/sport/running/mens/shoes.html?currentPage=0"
flpage <- read_html(fl)
flpage
str(flpage)

fl_body_nodes <- flpage %>% html_node("body") %>% html_children()

prodname <- flpage %>% html_node("body") %>% xml2::xml_find_all("//span[contains(@class, 'ProductName-primary')]") %>% rvest::html_text()
prodnamealt <- flpage %>% html_node("body") %>% xml2::xml_find_all("//span[contains(@class, 'ProductName-alt')]") %>% rvest::html_text()
productprice <- flpage %>% html_node("body") %>% xml2::xml_find_all("//div[contains(@class, 'ProductPrice')]") %>% rvest::html_text()

# productprice
prodpricefinal <- flpage %>% html_node("body") %>% xml2::xml_find_all("//div[contains(@class, 'ProductPrice-final')]") %>% rvest::html_text()
prodpriceoriginal <- flpage %>% html_node("body") %>% xml2::xml_find_all("//div[contains(@class, 'ProductPrice-original')]") %>% rvest::html_text()

flproddf <- data.frame(prodname,prodnamealt,productprice)



