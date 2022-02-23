#############################################################################################
# Data : https://www.footlocker.com/, Nike
# Author : Gaurav Modi 
# Project : Webscraping POC 
# Reference : R Web Scraping Quick Start Guide By Olgun Aydin
#############################################################################################

library(rvest)
library(dplyr)

# https://www.footlocker.com/category/sport/running/mens/shoes.html

pages <- read_html("https://www.footlocker.com/category/sport/running/mens/shoes.html") %>% html_node("body") %>% xml2::xml_find_all("//li[contains(@class, 'col col-shrink Pagination-option Pagination-option--digit')]")
length(pages)  
allpagesdf <- NULL

for(i in seq_len(length(pages)+1)){
  fl <- paste0("https://www.footlocker.com/category/sport/running/mens/shoes.html?currentPage=",i-1)
  flpage <- read_html(fl)

prodname <- flpage %>% html_node("body") %>% xml2::xml_find_all("//span[contains(@class, 'ProductName-primary')]") %>% rvest::html_text()
prodnamealt <- flpage %>% html_node("body") %>% xml2::xml_find_all("//span[contains(@class, 'ProductName-alt')]") %>% rvest::html_text()
productprice <- flpage %>% html_node("body") %>% xml2::xml_find_all("//div[contains(@class, 'ProductPrice')]") %>% rvest::html_text()
flproddf <- data.frame(prodname,prodnamealt,productprice)

allpagesdf <- rbind(allpagesdf,flproddf)
}
#setwd("https://drive.google.com/drive/folders/1nfqseIhn8-2cUOnTRIkwQEtMahybqLJ2")
write.csv(allpagesdf, file = "MensRunning.csv")

########## Basket Ball #####

pages <- read_html("https://www.footlocker.com/category/sport/basketball/mens/shoes.html") %>% 
         html_node("body") %>% xml2::xml_find_all("//li[contains(@class, 'col col-shrink Pagination-option Pagination-option--digit')]")
#length(pages)  
 page_n <- pages[[length(pages)]] %>% rvest::html_text() %>% as.numeric() 
 allpagesdf <- NULL
 
for(i in seq_len(page_n)){
  fl <- paste0("https://www.footlocker.com/category/sport/basketball/mens/shoes.html?currentPage=",i-1) 
  flpage <- read_html(fl)
  
  prodname <- flpage %>% html_node("body") %>% xml2::xml_find_all("//span[contains(@class, 'ProductName-primary')]") %>% rvest::html_text()
  prodnamealt <- flpage %>% html_node("body") %>% xml2::xml_find_all("//span[contains(@class, 'ProductName-alt')]") %>% rvest::html_text()
  productprice <- flpage %>% html_node("body") %>% xml2::xml_find_all("//div[contains(@class, 'ProductPrice')]") %>% rvest::html_text()
  flproddf <- data.frame(prodname,prodnamealt,productprice)
  
  allpagesdf <- rbind(allpagesdf,flproddf)
}
#setwd("https://drive.google.com/drive/folders/1nfqseIhn8-2cUOnTRIkwQEtMahybqLJ2")
write.csv(allpagesdf, file = "BasketBall.csv")


########## Men's Casual Shoes #############

#https://www.footlocker.com/category/sport/casual/mens/shoes.html
pages <- read_html("https://www.footlocker.com/category/sport/casual/mens/shoes.html") %>% 
  html_node("body") %>% xml2::xml_find_all("//li[contains(@class, 'col col-shrink Pagination-option Pagination-option--digit')]")

length(pages)  
page_n <- pages[[length(pages)]] %>% rvest::html_text() %>% as.numeric() 
allpagesdf <- NULL
flproddf <- NULL

for(i in seq_len(page_n)){
  fl <- paste0("https://www.footlocker.com/category/sport/casual/mens/shoes.html?currentPage=",i-1) 
  flpage <- read_html(fl)
  
  prodname <- flpage %>% html_node("body") %>% xml2::xml_find_all("//span[contains(@class, 'ProductName-primary')]") %>% rvest::html_text()
  prodnamealt <- flpage %>% html_node("body") %>% xml2::xml_find_all("//span[contains(@class, 'ProductName-alt')]") %>% rvest::html_text()
  productprice <- flpage %>% html_node("body") %>% xml2::xml_find_all("//div[contains(@class, 'ProductPrice')]") %>% rvest::html_text()
  flproddf <- data.frame(prodname,prodnamealt,productprice)
  
  allpagesdf <- rbind(allpagesdf,flproddf)
}
#setwd("https://drive.google.com/drive/folders/1nfqseIhn8-2cUOnTRIkwQEtMahybqLJ2")
write.csv(allpagesdf, file = "Casual.csv")

############## Men's Shoes All #######################

#https://www.footlocker.com/category/mens/shoes.html

pages <- read_html("https://www.footlocker.com/category/mens/shoes.html") %>% 
  html_node("body") %>% xml2::xml_find_all("//li[contains(@class, 'col col-shrink Pagination-option Pagination-option--digit')]")

length(pages)
page_n <- pages[[length(pages)]] %>% rvest::html_text() %>% as.numeric() 
allpagesdf <- NULL
flproddf <- NULL

#for(i in seq_len(page_n-20))
for(i in 2:10){
  fl <- paste0("https://www.footlocker.com/category/mens/shoes.html?currentPage=",i-1) 
  flpage <- read_html(fl)
  
  detailurl <- flpage %>% html_node("body") %>% xml2::xml_find_all("//a[contains(@class, 'ProductCard-link ProductCard-content')]") %>% rvest::html_attr("href")
  detailurl <- paste0("https://www.footlocker.com",detailurl)
  print(detailurl)
  start_time <- lubridate::now()
  naptime(start_time + lubridate::minutes(1))
  prodname <- flpage %>% html_node("body") %>% xml2::xml_find_all("//span[contains(@class, 'ProductName-primary')]") %>% rvest::html_text()
  prodnamealt <- flpage %>% html_node("body") %>% xml2::xml_find_all("//span[contains(@class, 'ProductName-alt')]") %>% rvest::html_text()
  productprice <- flpage %>% html_node("body") %>% xml2::xml_find_all("//div[contains(@class, 'ProductPrice')]") %>% rvest::html_text()
  flproddf <- data.frame(prodname,prodnamealt,productprice)
  
  allpagesdf <- rbind(allpagesdf,flproddf)
}
#setwd("https://drive.google.com/drive/folders/1nfqseIhn8-2cUOnTRIkwQEtMahybqLJ2")
write.csv(allpagesdf, file = "AllMensShoes.csv")


############ Nike Mens Running ########

nike <- read_html("https://www.nike.com/w/mens-shoes-nik1zy7ok")

prodname <- nike %>% html_node("body") %>% xml2::xml_find_all("//div[contains(@class, 'product-card__title')]") %>% rvest::html_text()
prodnamealt <- nike %>% html_node("body") %>% xml2::xml_find_all("//div[contains(@class, 'product-card__subtitle')]") %>% rvest::html_text()
productprice <- nike %>% html_node("body") %>% xml2::xml_find_all("//div[contains(@class, 'product-card__price')]") %>% rvest::html_text()

proddf <- data.frame(prodname,prodnamealt,productprice)
write.csv(proddf, file = "NikeShoes.csv")

############## RSelenium #############

library(RSelenium)
rD <- rsDriver()
remDr <- rD[["client"]]

remDr$navigate("http://devveri.com/")

rD[["server"]]$stop()

library(rvest)
#start RSelenium
checkForServer()
startServer()
remDr <- remoteDriver()
remDr$open()

#navigate to your page
remDr$navigate("http://www.linio.com.co/tecnologia/celulares-telefonia-gps/")

#scroll down 5 times, waiting for the page to load at each time
for(i in 1:5){      
  remDr$executeScript(paste("scroll(0,",i*10000,");"))
  Sys.sleep(3)    
}

#get the page html
page_source<-remDr$getPageSource()

#parse it
html(page_source[[1]]) %>% html_nodes(".product-itm-price-new") %>%
  html_text()



################# Barcode ###################
library("jsonlite")

addidas <- read_html("https://www.footlocker.com/product/adidas-ultraboost-20-mens/EG0755.html")
str(addidas)
addidas %>% html_nodes('body')

temp <- addidas %>% html_nodes('body') %>% html_nodes('script')

temp[1]%>% html_text()

json <- addidas %>% html_nodes('script') %>% html_text()  %>%  jsonlite::fromJSON()



class(json)

ctx <- v8()
#parse the html content from the js output and print it as text
read_html(ct$eval(gsub('document.write','',json))) %>% html_text()

library(rvest)
library(stringi)
library(V8)
library(tidyverse)

temp2 <- temp[1] %>% stri_split_lines() %>% flatten_chr() %>% keep(stri_detect_regex, "^\tvar") %>% ctx$eval()

jsonlite::fromJSON(temp[1])
# https://stackoverflow.com/questions/46823199/scraping-a-javascript-object-and-converting-to-json-within-r-rvest

toString(temp[1])

jsonstring <- temp[1] %>% stri_split_lines()

temp2 <- temp[1]%>% html_text() %>% toString() %>% jsonlite::toJSON()
class(temp2)

temp2

str(temp2)
jsonlite::validate(temp2)

head(temp2)
yelp <- stream_in(temp2)
yelp_flat <- flatten(temp2)


regex 
#{([\s\S]*?)};

############# 04122020 #######
library(tidyverse)
library(rvest)
library(stringi)
library(V8)
library("jsonlite")
library("rjson")
library(naptime)

nike <- read_html("https://www.footlocker.com/product/nike-zoom-gravity-mens/Q3202004.html")
scripts <- nike %>% html_nodes('body') %>% html_nodes('script') %>% .[[1]] %>% html_text()
class(scripts)
scripts <- toString(scripts)


json <- str_extract_all(scripts, "\\{.+\\}")[1]

data1 <- rjson::fromJSON(json[[1]],simplify=TRUE)

write_json(data1,paste0("Q3202004", format(Sys.time(), "%d_%b_%Y_%H.%M.%S"), ".json"))
naptime(lubridate::seconds(1))

### 1 Day has 1440 Minutes ####
repeat{
  start_time <- lubridate::now()
  # Do processing
  naptime(start_time + lubridate::minutes(1))
}



