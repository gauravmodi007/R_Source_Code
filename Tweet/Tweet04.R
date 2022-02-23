##########################################################################
## Project: Twitter Analysis in R
## Description: Connect to Twitter and do analysis on twitter data

## @FinishLine, @FinishLineYF, @FinishLineHelp
## @PUMA, @adidasoriginals, @Nike, @newbalance, @Reebok, @brooksrunning
## @DICKS, @JDSports, @dsw_us
## NIKE AIR VAPORMAX PLUS

##########################################################################


library(tidyverse)
library(rtweet)
library(httpuv)
library(syuzhet)
library(ggplot2)
library(tidyquant)
library(tidytext)
library(SnowballC)
library(wordcloud)
library(tm)
library(knitr)
library(kableExtra)

############ Trends #############
globaltrends <- trends_available()
glimpse(globaltrends)

ustrends <- get_trends("united states")
glimpse(ustrends)
##################################

############ Tweet over Time  #############
tweetdata <- search_tweets(q = "@FinishLine", n = 10000, lang = "en", include_rts = F)
users_data(tweetdata)
ts_plot(tweetdata, by = "hours")
ts_plot(tweetdata, by = "days")
##################################


############ Word Cloud  #############
tidy_descr <- tweetdata %>% unnest_tokens(word, text) %>% mutate(word_stem = wordStem(word)) %>% anti_join(stop_words, by = "word") %>% filter(!grepl("\\.|http", word))
tidy_descr %>% count(word_stem) %>% mutate(word_stem = removeNumbers(word_stem)) %>% with(wordcloud(word_stem, n, max.words = 100, colors = palette_light()))

library(reshape2)
tidy_descr_sentiment %>%
  count(word, bing, sort = TRUE) %>%
  acast(word ~ bing, value.var = "n", fill = 0) %>%
  comparison.cloud(colors = palette_light()[1:2],
                   max.words = 100)

tidy_descr_sentiment <- tidy_descr %>%
  left_join(select(bigrams_separated, word1, word2), by = c("word" = "word2")) %>%
  inner_join(get_sentiments("nrc"), by = "word") %>%
  inner_join(get_sentiments("bing"), by = "word") %>%
  rename(nrc = sentiment.x, bing = sentiment.y) %>%
  mutate(nrc = ifelse(!is.na(word1), NA, nrc),
         bing = ifelse(!is.na(word1) & bing == "positive", "negative", 
                       ifelse(!is.na(word1) & bing == "negative", "positive", bing)))
########################################


############ Top 10 # tag along with @FinishLine  #############
rstats <- search_tweets("@FinishLine", n=10000) 
glimpse(rstats)
select(rstats,hashtags) %>% unnest(cols = c(hashtags)) %>% mutate(hashtags = tolower(hashtags)) %>% count(hashtags, sort=TRUE) %>% filter(hashtags != "rstats") %>% top_n(20)
##################################


############ Top n Followers  #############
rt <- search_tweets("#FinishLine", n = 10000, include_rts = FALSE)
rt %>% select(tweeted = created_at, screen_name, followers = followers_count) %>% head(20) %>% kable() %>% column_spec(1:3, width = c("45%", "35%", "20%")) %>% kable_styling()
############################################

############ Sentiment Analysis  #############
result <- get_nrc_sentiment(as.character(tweetdata$text))
result1<-data.frame(t(result))
new_result <- data.frame(rowSums(result1))
names(new_result)[1] <- "count"
new_result <- cbind("sentiment" = rownames(new_result), new_result)
rownames(new_result) <- NULL
qplot(sentiment, data=new_result[1:8,], weight=count, geom="bar",fill=sentiment)+ggtitle("finishline Sentiments")
qplot(sentiment, data=new_result[9:10,], weight=count, geom="bar",fill=sentiment)+ggtitle("finishline Sentiments")
#################################################

############ Geocoding ##########################
library(rtweet)
library(ggmap)
library(tidyverse)

?register_google 
has_google_key()
google_key()

rstats_us <- search_tweets("#rstats", 3000)

user_info <- lookup_users(unique(rstats_us$user_id))

discard(user_info$location, `==`, "") %>% ggmap::geocode() -> coded
coded$location <- discard(user_info$location, `==`, "")
user_info <- left_join(user_info, coded, "location")

#################################################


################## Streaming ###################

stream_tweets(
  lookup_coords("usa"), # handy helper function in rtweet
  verbose = FALSE,
  timeout = (60 * 1),
) -> usa

count(usa, place_full_name, sort=TRUE)

unnest(usa, hashtags) %>% 
  count(hashtags, sort=TRUE) %>% 
  filter(!is.na(hashtags))

count(usa, source, sort=TRUE)
#################################################


############## Twitter Analytics ################
#https://analytics.twitter.com/about
#################################################



install.packages("remotes")
remotes::install_github("JohnCoene/twinetverse")
library(twinetverse)

# COLLECT
tweets <- search_tweets("@FinishLine")

# BUILD
net <- tweets %>% 
  gt_edges(screen_name, mentions_screen_name) %>% 
  gt_nodes() %>% 
  gt_collect() 

c(edges, nodes) %<-% net # unpack

# prepare for sigmajs
nodes <- nodes2sg(nodes)
edges <- edges2sg(edges)

# VISUALISE
sigmajs() %>% 
  sg_nodes(nodes, id, size) %>% 
  sg_edges(edges, id, source, target)


# Refine Tweet Search
tweets <- search_tweets("@FinishLine", n = 1000, include_rts = FALSE)

net <- tweets %>% 
  gt_edges(screen_name, mentions_screen_name) %>% 
  gt_nodes() %>% 
  gt_collect()

c(edges, nodes) %<-% net

nodes <- nodes2sg(nodes)
edges <- edges2sg(edges)


sigmajs("webgl") %>% 
  sg_nodes(nodes, id, label, size) %>% 
  sg_edges(edges, id, source, target) %>% 
  sg_layout(layout = igraph::layout_components) %>% 
  sg_cluster(
    colors = c(
      "#0075a0",
      "#0084b4",
      "#00aced",
      "#1dcaff",
      "#c0deed"
    )
  ) %>% 
  sg_settings(
    minNodeSize = 1,
    maxNodeSize = 2.5,
    edgeColor = "default",
    defaultEdgeColor = "#d3d3d3"
  )

# Retweet 
tweets <- search_tweets("@FinishLine", n = 1000, include_rts = TRUE)
net <- tweets %>% gt_edges(screen_name, retweet_screen_name) %>% gt_nodes() %>% gt_collect() # collect
c(edges, nodes) %<-% net

nodes <- nodes2sg(nodes)
edges <- edges2sg(edges)

sigmajs() %>% 
  sg_nodes(nodes, id, label, size) %>% 
  sg_edges(edges, id, source, target) %>% 
  sg_layout(layout = igraph::layout_components) %>% 
  sg_cluster(
    colors = c(
      "#0084b4",
      "#00aced",
      "#1dcaff",
      "#c0deed"
    )
  ) %>% 
  sg_settings(
    minNodeSize = 1,
    maxNodeSize = 2.5,
    edgeColor = "default",
    defaultEdgeColor = "#d3d3d3"
  )


install.packages("graphTweets") # CRAN release v0.4
devtools::install_github("JohnCoene/graphTweets") # dev version

library(graphTweets)
library(igraph) # for plot

tweets <- rtweet::search_tweets("@FinishLine", n=50)
tweets %>% 
  gt_edges(text, screen_name, status_id) %>% 
  gt_graph() %>% 
  plot()
