
library(rvest)

pages <- read_html("https://www.zacks.com/") %>% html_node("body") 

zacks <- read_html("https://www.zacks.com/")



pages <- read_html("https://www.zacks.com/") %>% html_node("body") %>% xml2::xml_find_all("//div[contains(@id, 'topmovers_growth')]")

?html_nodes

temp <- read_html("https://www.zacks.com/") %>% html_node("body") %>% html_nodes("div") %>% html_attr("id")

temp1 <- read_html("https://www.zacks.com/") %>% html_node("body") %>% html_nodes('.ui-tabs-panel ui-corner-bottom ui-widget-content')


# topmovers_vgm
# topmovers_value
# topmovers_growth
# topmovers_momentum
# topmovers_income

bull_of_the_day <- read_html("https://www.zacks.com/") %>% html_node("body") %>% xml2::xml_find_all("//div[contains(@class, 'bull_of_the_day')]")

#/html/body/div[5]/div[2]/section[2]/section/article[1]

bull_of_the_day <- read_html("https://www.zacks.com/") %>% html_node(xpath = "/html/body/div[5]/div[2]/section[2]/section/article[1]")

bull_of_the_day

bull_of_the_day <- read_html("https://www.zacks.com/") %>% html_node(xpath = "/html/body/div[5]/div[2]/section[2]/section/article[1]/span") %>% html_attr("title")

bull_of_the_day

?html_attr

#//*[@id="zacks_number_one_rank_additions"]
# /html/body/div[5]/div[2]/section[2]/div/section[2]/table/tbody/tr[1]/td[1]/a/span
zacks_1_addition <- read_html("https://www.zacks.com/") %>% 
                    html_node(xpath = "//*[@id='zacks_number_one_rank_additions']") %>% 
                    html_node("tbody")  %>% html_children() %>% 
                    html_node("a") %>% html_attr("rel")


#html_children(zacks_1_addition)[1]
zacks_1_addition


#####  08/16 
#==========
zacks <- read_html("https://www.zacks.com/")

bull_of_the_day <- zacks %>% html_node(xpath = "//*[@id='bull_bear_of_the_day']") %>% html_children() %>% html_node("span") %>% html_attr("title")
str_extract_all(bull_of_the_day,  "(?<=\\().+?(?=\\))")



##/html/body/div[5]/div[2]/section[2]/div/section[1]/div[4]/table

tenp <- zacks %>% html_node(xpath = "/html/body/div[5]/div[2]/section[2]/div/section[1]/div[4]/table/tbody/tr[1]/td[1]/a") %>% html_attr("rel")

temp <- zacks %>% html_node(xpath = "/html/body/div[5]/div[2]/section[2]/div/section[1]/div[4]/table/tbody/tr[2]/td[1]/a") %>% html_attr("rel")

##tenp <- zacks %>% html_node(xpath = "/html/body/div[5]/div[2]/section[2]/div/section[1]/div[4]/table/tbody")


vector = c()

vector <- c(vector, values[i])
### Top Mover Value
vector <- c(vector, zacks %>% html_node(xpath = "/html/body/div[5]/div[2]/section[2]/div/section[1]/div[1]/table/tbody/tr[1]/td[1]/a") %>% html_attr("rel"))
vector <- c(vector, zacks %>% html_node(xpath = "/html/body/div[5]/div[2]/section[2]/div/section[1]/div[1]/table/tbody/tr[2]/td[1]/a") %>% html_attr("rel"))
vector <- c(vector, zacks %>% html_node(xpath = "/html/body/div[5]/div[2]/section[2]/div/section[1]/div[1]/table/tbody/tr[3]/td[1]/a") %>% html_attr("rel"))
vector <- c(vector, zacks %>% html_node(xpath = "/html/body/div[5]/div[2]/section[2]/div/section[1]/div[1]/table/tbody/tr[4]/td[1]/a") %>% html_attr("rel"))
vector <- c(vector, zacks %>% html_node(xpath = "/html/body/div[5]/div[2]/section[2]/div/section[1]/div[1]/table/tbody/tr[5]/td[1]/a") %>% html_attr("rel"))

### Top Mover Growth
zacks %>% html_node(xpath = "/html/body/div[5]/div[2]/section[2]/div/section[1]/div[2]/table/tbody/tr[1]/td[1]/a") %>% html_attr("rel")
zacks %>% html_node(xpath = "/html/body/div[5]/div[2]/section[2]/div/section[1]/div[2]/table/tbody/tr[2]/td[1]/a") %>% html_attr("rel")
zacks %>% html_node(xpath = "/html/body/div[5]/div[2]/section[2]/div/section[1]/div[2]/table/tbody/tr[3]/td[1]/a") %>% html_attr("rel")
zacks %>% html_node(xpath = "/html/body/div[5]/div[2]/section[2]/div/section[1]/div[2]/table/tbody/tr[4]/td[1]/a") %>% html_attr("rel")
zacks %>% html_node(xpath = "/html/body/div[5]/div[2]/section[2]/div/section[1]/div[2]/table/tbody/tr[5]/td[1]/a") %>% html_attr("rel")

### Top Mover Momentum
zacks %>% html_node(xpath = "/html/body/div[5]/div[2]/section[2]/div/section[1]/div[3]/table/tbody/tr[1]/td[1]/a") %>% html_attr("rel")
zacks %>% html_node(xpath = "/html/body/div[5]/div[2]/section[2]/div/section[1]/div[3]/table/tbody/tr[2]/td[1]/a") %>% html_attr("rel")
zacks %>% html_node(xpath = "/html/body/div[5]/div[2]/section[2]/div/section[1]/div[3]/table/tbody/tr[3]/td[1]/a") %>% html_attr("rel")
zacks %>% html_node(xpath = "/html/body/div[5]/div[2]/section[2]/div/section[1]/div[3]/table/tbody/tr[4]/td[1]/a") %>% html_attr("rel")
zacks %>% html_node(xpath = "/html/body/div[5]/div[2]/section[2]/div/section[1]/div[3]/table/tbody/tr[5]/td[1]/a") %>% html_attr("rel")

### Top Mover VGM
zacks %>% html_node(xpath = "/html/body/div[5]/div[2]/section[2]/div/section[1]/div[4]/table/tbody/tr[1]/td[1]/a") %>% html_attr("rel")
zacks %>% html_node(xpath = "/html/body/div[5]/div[2]/section[2]/div/section[1]/div[4]/table/tbody/tr[2]/td[1]/a") %>% html_attr("rel")
zacks %>% html_node(xpath = "/html/body/div[5]/div[2]/section[2]/div/section[1]/div[4]/table/tbody/tr[3]/td[1]/a") %>% html_attr("rel")
zacks %>% html_node(xpath = "/html/body/div[5]/div[2]/section[2]/div/section[1]/div[4]/table/tbody/tr[4]/td[1]/a") %>% html_attr("rel")
zacks %>% html_node(xpath = "/html/body/div[5]/div[2]/section[2]/div/section[1]/div[4]/table/tbody/tr[5]/td[1]/a") %>% html_attr("rel")

### Top Mover Income
zacks %>% html_node(xpath = "/html/body/div[5]/div[2]/section[2]/div/section[1]/div[5]/table/tbody/tr[1]/td[1]/a") %>% html_attr("rel")
zacks %>% html_node(xpath = "/html/body/div[5]/div[2]/section[2]/div/section[1]/div[5]/table/tbody/tr[2]/td[1]/a") %>% html_attr("rel")
zacks %>% html_node(xpath = "/html/body/div[5]/div[2]/section[2]/div/section[1]/div[5]/table/tbody/tr[3]/td[1]/a") %>% html_attr("rel")
zacks %>% html_node(xpath = "/html/body/div[5]/div[2]/section[2]/div/section[1]/div[5]/table/tbody/tr[4]/td[1]/a") %>% html_attr("rel")
zacks %>% html_node(xpath = "/html/body/div[5]/div[2]/section[2]/div/section[1]/div[5]/table/tbody/tr[5]/td[1]/a") %>% html_attr("rel")


zacksList <-  NULL

for(i in 1:5)
  {
  for(j in 1:5)
    {
    zacksList <- paste0(zacks %>% html_node(xpath = paste0("/html/body/div[5]/div[2]/section[2]/div/section[1]/div[",i,"]/table/tbody/tr[",j,"]/td[1]/a")) %>% html_attr("rel"),",",zacksList)
    }
}

class(zacksList)
len(zacksList)
write.csv(zacksList, paste0(format(Sys.time(), "%d-%b-%Y %H.%M"), "zacksList.txt"), col.names = FALSE, row.names = FALSE, quote = FALSE)

?write.csv2()
