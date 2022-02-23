
library(rtweet)
library(httpuv)
library(syuzhet)
library(ggplot2)
#search_tweets2()

cvd19 <- search_tweets(q = "COVID19", n = 1000, lang = "en", include_rts = TRUE)

sa_value_date <- get_nrc_sentiment(cvd19$text)
scoredate <- colSums(sa_value_date[,])
score_df_date <- data.frame(scoredate)

result <- get_nrc_sentiment(as.character(cvd19$text))
result1<-data.frame(t(result))
new_result <- data.frame(rowSums(result1))
names(new_result)[1] <- "count"
new_result <- cbind("sentiment" = rownames(new_result), new_result)
rownames(new_result) <- NULL
qplot(sentiment, data=new_result[1:8,], weight=count, geom="bar",fill=sentiment)+ggtitle("CVOID19 Sentiments")
qplot(sentiment, data=new_result[9:10,], weight=count, geom="bar",fill=sentiment)+ggtitle("COVID19 Sentiments")


tweetdata <- search_tweets(q = "TSLA", n = 1000, lang = "en", include_rts = TRUE)
result <- get_nrc_sentiment(as.character(tweetdata$text))
result1<-data.frame(t(result))
new_result <- data.frame(rowSums(result1))
names(new_result)[1] <- "count"
new_result <- cbind("sentiment" = rownames(new_result), new_result)
rownames(new_result) <- NULL
qplot(sentiment, data=new_result[1:8,], weight=count, geom="bar",fill=sentiment)+ggtitle("CVOID19 Sentiments")
qplot(sentiment, data=new_result[9:10,], weight=count, geom="bar",fill=sentiment)+ggtitle("COVID19 Sentiments")

## Nike
tweetdata <- search_tweets(q = "Nike", n = 1000, lang = "en", include_rts = TRUE)
result <- get_nrc_sentiment(as.character(tweetdata$text))
result1<-data.frame(t(result))
new_result <- data.frame(rowSums(result1))
names(new_result)[1] <- "count"
new_result <- cbind("sentiment" = rownames(new_result), new_result)
rownames(new_result) <- NULL
qplot(sentiment, data=new_result[1:8,], weight=count, geom="bar",fill=sentiment)+ggtitle("CVOID19 Sentiments")
qplot(sentiment, data=new_result[9:10,], weight=count, geom="bar",fill=sentiment)+ggtitle("COVID19 Sentiments")

## finishline
## FinishLineYF

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

## NIKE AIR VAPORMAX PLUS
tweetdata <- search_tweets(q = "NIKE AIR VAPORMAX PLUS", n = 1000, lang = "en", include_rts = TRUE)
result <- get_nrc_sentiment(as.character(tweetdata$text))
result1<-data.frame(t(result))
new_result <- data.frame(rowSums(result1))
names(new_result)[1] <- "count"
new_result <- cbind("sentiment" = rownames(new_result), new_result)
rownames(new_result) <- NULL
qplot(sentiment, data=new_result[1:8,], weight=count, geom="bar",fill=sentiment)+ggtitle("NIKE AIR VAPORMAX PLUS Sentiments")
qplot(sentiment, data=new_result[9:10,], weight=count, geom="bar",fill=sentiment)+ggtitle("NIKE AIR VAPORMAX PLUS Sentiments")



libs <- c('dplyr', 'tibble',      # wrangling
          'stringr', 'rtweet',    # strings, tweets
          'knitr', 'kableExtra',  # table styling
          'lubridate',            # time
          'ggplot2', 'ggthemes')  # plots
invisible(lapply(libs, library, character.only = TRUE))

rt <- search_tweets(
  "rstats community", n = 1000, include_rts = FALSE
)

rt %>%
  select(tweeted = created_at,
         screen_name,
         followers = followers_count) %>%
  head(5) %>%
  kable() %>%
  column_spec(1:3, width = c("45%", "35%", "20%")) %>%
  kable_styling()


rt %>%
  mutate(date = date(created_at)) %>%
  count(date) %>%
  ggplot(aes(date, n)) +
  geom_line(col = "blue") +
  labs(x = "", y = "") +
  theme_fivethirtyeight() +
  theme(legend.position = "none") +
  ggtitle("Daily number of tweets about the 'rstats community'",
          subtitle = "Extracted using the rtweet package")

glimpse(tweetdata)

library(tidyquant)
library(tidytext)
library(SnowballC)
library(wordcloud)
library(tm)


class(tweetdata)

tidy_descr <- tweetdata %>%
  unnest_tokens(word, text) %>%
  mutate(word_stem = wordStem(word)) %>%
  anti_join(stop_words, by = "word") %>%
  filter(!grepl("\\.|http", word))

tidy_descr %>%
  count(word_stem) %>%
  mutate(word_stem = removeNumbers(word_stem)) %>%
  with(wordcloud(word_stem, n, max.words = 100, colors = palette_light()))

?wordcloud
?palette_light

