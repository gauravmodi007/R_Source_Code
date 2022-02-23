
libs <- c('dplyr', 'tibble',      # wrangling
          'stringr', 'rtweet',    # strings, tweets
          'knitr', 'kableExtra',  # table styling
          'lubridate',            # time
          'ggplot2', 'ggthemes')  # plots
invisible(lapply(libs, library, character.only = TRUE))

library(tidyverse)
library(rtweet)
library(httpuv)
library(syuzhet)
library(ggplot2)
#search_tweets2()
library(tidyquant)
library(tidytext)
library(SnowballC)
library(wordcloud)
library(tm)

## finishline
## FinishLineYF
## @PUMA, @adidasoriginals, @Nike, @newbalance, @Reebok, @brooksrunning
## @DICKS, @JDSports, @dsw_us
## NIKE AIR VAPORMAX PLUS

tweetdata <- search_tweets(q = "@FinishLineYF", n = 1000, lang = "en", include_rts = F)
tweetdata <- search_tweets(q = "@FinishLine", n = 1000, lang = "en", include_rts = F)
tweetdata <- search_tweets(q = "@footlocker", n = 1000, lang = "en", include_rts = F)
tweetdata <- search_tweets(q = "@Nike", n = 1000, lang = "en", include_rts = F)

result <- get_nrc_sentiment(as.character(tweetdata$text))
result1<-data.frame(t(result))
new_result <- data.frame(rowSums(result1))
names(new_result)[1] <- "count"
new_result <- cbind("sentiment" = rownames(new_result), new_result)
rownames(new_result) <- NULL
qplot(sentiment, data=new_result[1:8,], weight=count, geom="bar",fill=sentiment)+ggtitle("finishline Sentiments")
qplot(sentiment, data=new_result[9:10,], weight=count, geom="bar",fill=sentiment)+ggtitle("finishline Sentiments")


rt <- search_tweets("#FinishLine", n = 10000, include_rts = FALSE)

users_data(rt)
ts_plot(rt, by = "hours")
ts_plot(rt, by = "days")

rt %>%
  select(tweeted = created_at, screen_name, followers = followers_count) %>% head(20) %>% kable() %>% column_spec(1:3, width = c("45%", "35%", "20%")) %>% kable_styling()


rt %>%
  mutate(date = date(created_at)) %>%
  count(date) %>%
  ggplot(aes(date, n)) +
  geom_line(col = "blue") +
  labs(x = "", y = "") +
  theme_fivethirtyeight() +
  theme(legend.position = "none") +
  ggtitle("Daily number of tweets about the 'FinishLine'")

glimpse(tweetdata)

tidy_descr <- tweetdata %>%
  unnest_tokens(word, text) %>%
  mutate(word_stem = wordStem(word)) %>%
  anti_join(stop_words, by = "word") %>%
  filter(!grepl("\\.|http", word))

tidy_descr %>%
  count(word_stem) %>%
  mutate(word_stem = removeNumbers(word_stem)) %>%
  with(wordcloud(word_stem, n, max.words = 100, colors = palette_light()))


trends_avail <- trends_available()
glimpse(trends_avail)

us <- get_trends("united states")
glimpse(us)

rstats <- search_tweets("#rstats", n=300) # pull 300 tweets that used the "#rstats" hashtag
glimpse(rstats)
select(rstats,hashtags) %>% unnest(cols = c(hashtags)) %>% mutate(hashtags = tolower(hashtags)) %>% count(hashtags, sort=TRUE) %>% filter(hashtags != "rstats") %>% top_n(10)


rstats <- search_tweets("@FinishLine", n=10000) 
glimpse(rstats)
select(rstats,hashtags) %>% unnest(cols = c(hashtags)) %>% mutate(hashtags = tolower(hashtags)) %>% count(hashtags, sort=TRUE) %>% filter(hashtags != "rstats") %>% top_n(20)


search_tweets("@FinishLine -filter:retweets") %>% select(text)

filter(rstats, retweet_count > 0) %>% 
  select(text, mentions_screen_name, retweet_count) %>% 
  mutate(text = substr(text, 1, 30)) %>% 
  unnest()


filter(rstats, str_detect(text, "(RT|via)((?:[[:blank:]:]\\W*@\\w+)+)")) %>% 
  select(text, mentions_screen_name, retweet_count) %>% 
  mutate(extracted = str_match(text, "(RT|via)((?:[[:blank:]:]\\W*@\\w+)+)")[,3]) %>% 
  mutate(text = substr(text, 1, 30)) %>% 
  unnest()

library(rlang)
library(rtweet)
library(igraph)
library(systemfonts)
library(hrbrthemes)
library(ggplot2)
library(ggraph)

library(tidyverse)
library(rtweet)
library(igraph)
library(extrafont)
extrafont::loadfonts(quiet=TRUE)
library(systemfonts)
library(hrbrthemes)
library(ggraph)

rstats <- search_tweets("@FinishLine", n=1500)
# same as previous recipe
filter(rstats, retweet_count > 0) %>% 
  select(screen_name, mentions_screen_name) %>%
  unnest(mentions_screen_name) %>% 
  filter(!is.na(mentions_screen_name)) %>% 
  graph_from_data_frame() -> rt_g

V(rt_g)$node_label <- unname(ifelse(degree(rt_g)[V(rt_g)] > 20, names(V(rt_g)), "")) 
V(rt_g)$node_size <- unname(ifelse(degree(rt_g)[V(rt_g)] > 20, degree(rt_g), 0)) 


ggraph(rt_g, layout = 'linear', circular = TRUE) + 
  geom_edge_arc(edge_width=0.125, aes(alpha=..index..)) +
  geom_node_label(aes(label=node_label, size=node_size),
                  label.size=0, fill="#ffffff66", segment.colour="springgreen",
                  color="slateblue", repel=TRUE, family=font_rc, fontface="bold") +
  coord_fixed() +
  scale_size_area(trans="sqrt") +
  labs(title="Retweet Relationships", subtitle="Most retweeted screen names labeled. Darkers edges == more retweets. Node size == larger degree") +
  theme_graph(base_family=font_rc) +
  theme(legend.position="none")
