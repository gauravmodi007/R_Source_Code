
library(rvest)
setwd("/Users/0327409/Documents/Projects/IB")
getwd()

#####  08/16 
#==========
zacks <- read_html("https://www.zacks.com/")

bull_of_the_day <- zacks %>% html_node(xpath = "//*[@id='bull_bear_of_the_day']") %>% html_children() %>% html_node("span") %>% html_attr("title") %>% str_extract_all("(?<=\\().+?(?=\\))")

str_extract_all(bull_of_the_day,  "(?<=\\().+?(?=\\))")

zacks_1_addition <- zacks %>% 
                    html_node(xpath = "//*[@id='zacks_number_one_rank_additions']") %>% 
                    html_node("tbody")  %>% html_children() %>% 
                    html_node("a") %>% html_attr("rel")

zacks_stocks <- append(as.String(Sys.Date()),c(zacks_1_addition, bull_of_the_day[[1]],bull_of_the_day[[2]]),1)


zacksdf <- data.frame(t(zacks_stocks))
colnames(zacksdf) = c("Date","Stock1","Stock2","Stock3","Stock4","Stock5","Stock6","Stock7")

#write.csv(zacksdf, file = "zacks.csv", append = TRUE)

write.table(zacksdf, file = "zacks.csv", append = TRUE, quote = F, sep = ',')

########## 

#//*[@id="full_one_list_table_growth"]
zacks_growth <- read_html("https://www.zacks.com/stocks/buy-list/?adid=zp_topnav_1list&icid=home-home-nav_tracking-zacks_premium-main_menu_wrapper-zacks_1_rank") 
zacks_all_growth <- zacks_growth %>% html_node(xpath = "//*[@id = 'full_one_list_table_growth']")

zacks_growth %>% html_node("body") %>% html_node("div") %>% xml2::xml_find_all("//div[contains(@class, 'top_value_wrapper')]")

zacks_growth %>% html_node(xpath = "/html/body/div[5]")

#/html/body/div[5]/div[2]/section/div[3]/div[2]/div[2]


link<-paste0("http://www.fas.nus.edu.sg/ecs/", "people/staff.html")
webpage <- read_html(link)

data <- html_nodes(zacks_growth,"tbody")
content <-html_text(data)