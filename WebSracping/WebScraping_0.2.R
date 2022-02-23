
library(rvest)
library(dplyr)

# https://www.footlocker.com/category/sport/running/mens/shoes.html
#col col-shrink Pagination-option Pagination-option--digit Pagination-option--active

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




allpagesdf <- NULL