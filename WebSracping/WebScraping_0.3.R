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

flpage %>% html_node("body") %>% xml2::xml_find_all("//span[contains(@class, 'ProductName-primary')]") %>% rvest::html_text()


########## Basket Ball #####
#<li class="col col-shrink Pagination-option Pagination-option--digit"><a aria-current="false" aria-label="Go to page 2" class="Link" target="_self" href="/category/sport/basketball/mens/shoes.html?currentPage=1">2</a></li>

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

for(i in seq_len(page_n)){
  fl <- paste0("https://www.footlocker.com/category/mens/shoes.html?currentPage=",i-1) 
  flpage <- read_html(fl)
  
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










allpagesdf <- NULL