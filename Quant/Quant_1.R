# Load libraries
library(tidyquant)
library(dplyr)
library(ggplot2)



AAPL <- tq_get("AAPL", from = "2020-01-01", to = "2021-12-10")

# SMA
AAPL %>%
  ggplot(aes(x = date, y = adjusted)) +
  geom_line() +                                   # Plot stock price
  geom_ma(ma_fun = SMA, n = 50) +                 # Plot 50-day SMA
  geom_ma(ma_fun = SMA, n = 200, color = "red") + # Plot 200-day SMA
  coord_x_date(xlim = c("2019-01-01", "2021-12-10"), ylim = c(10, 200) # Zoom in
               )             

# EVWMA
AAPL %>%
  ggplot(aes(x = date, y = adjusted)) +
  geom_line() +                                                   # Plot stock price
  geom_ma(aes(volume = volume), ma_fun = EVWMA, n = 50) +         # Plot 50-day EVWMA
  coord_x_date(xlim = c("2019-01-01", "2021-12-10"),
               ylim = c(10, 200))                                  # Zoom in


AAPL %>%
  ggplot(aes(x = date, y = close)) +
  geom_candlestick(aes(open = open, high = high, low = low, close = close), colour_up = "darkgreen", colour_down = "darkred", fill_up  = "darkgreen", fill_down  = "darkred") +
  labs(title = "AAPL Candlestick Chart", subtitle = "Zoomed in, Experimenting with Formatting", y = "Closing Price", x = "") + 
  coord_x_date(xlim = c(end - weeks(8), end), ylim = c(10, 200)) + 
  theme_tq()


AAPL_key_ratios <- tq_get("AAPL", get = "key.ratios")
AAPL_key_ratios


FANG %>% group_by(symbol) %>% tq_mutate_xy(x = close, y = volume, mutate_fun = EVWMA, col_rename = "EVWMA")

temp <- FANG %>% group_by(symbol) %>% tq_mutate(select = close, mutate_fun = MACD, col_rename = c("MACD", "Signal"))

###https://bookdown.org/kochiuyu/technical-analysis-with-r-second-edition2/custom-indicators.html

temp <- tq_get("AAPL", get = "stock.prices") %>% 
  tq_mutate(select=close,mutate_fun=RSI) %>%
  tq_mutate(select=c(high,low,close),mutate_fun=ATR, n=14) %>%
  tq_mutate(select=c(high,low,close),mutate_fun=CLV) %>%
  tq_mutate(select=c(high,low,close),mutate_fun=ADX)%>% 
  tq_mutate(select=c(high,low,close),mutate_fun=ultimateOscillator) %>%
  tq_mutate(select=close,mutate_fun=aroon)%>%
  tq_mutate(select=c(high,low,close),mutate_fun=CCI) %>%
  tq_mutate(select=c(high,low),mutate_fun=chaikinVolatility) %>% 
  tq_mutate(select=c(high,low),mutate_fun=SAR) %>% 
  tq_mutate(select=close,mutate_fun=SMA, n = 50) %>%
  tq_mutate(select=close,mutate_fun=SMA, n = 100) %>%
  tq_mutate(select=close,mutate_fun=SMA, n = 200) %>%
  tq_mutate(select=close,mutate_fun=HMA, n = 20) %>%
  tq_mutate(select = close,mutate_fun=MACD, nFast=12, nSlow=26, nSig=9, maType=SMA)

temp <- NULL

data(ttrc)
atr <- ATR(ttrc[,c("High","Low","Close")], n=14)
atr


chartSeries(AAPL,
            subset='2007-05::2008-01',
            theme=chartTheme('white'))
addMACD(fast=12,slow=26,signal=9,type="EMA")

#### Alpha Vantage
####==============
#JH1ZW3XUUK6EG433
library(alphavantager)
av_api_key("JH1ZW3XUUK6EG433")
alpha.aapl <- c("AAPL") %>% tq_get(get = "alphavantager", av_fun="TIME_SERIES_DAILY_ADJUSTED") 
alpha.aapl.id <- c("AAPL") %>% av_get(get = "alphavantager", av_fun="TIME_SERIES_INTRADAY",interval="1min") 

# https://www.alphavantage.co/query?function=TIME_SERIES_INTRADAY&symbol=AAPL&interval=5min&apikey=JH1ZW3XUUK6EG433


install.packages("IBrokers")
library(IBrokers)
IBrokersRef()

# To establish a connection to TWS
tws = twsConnect()
# To check the connection to TWS
isConnected(tws)
# To disconnect 
twsDisconnect(tws)


  
