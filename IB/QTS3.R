
library(tidyverse)
library(tidyquant)


data("FANG")

FANG


FANG_annual_returns <- FANG %>% group_by(symbol) %>% tq_transmute(select = adjusted, mutate_fun = periodReturn, period = "yearly", type = "arithmetic")
FANG_annual_returns

FANG_daily_log_returns <- FANG %>% group_by(symbol) %>% tq_transmute(select = adjusted, mutate_fun = periodReturn, period = "daily", type = "log", col_rename = "monthly.returns")
FANG_daily_log_returns


#https://cran.r-project.org/web/packages/tidyquant/vignettes/TQ02-quant-integrations-in-tidyquant.html


FANG_macd <- FANG %>% group_by(symbol) %>% 
                      tq_mutate(select = close, mutate_fun = MACD, nFast = 12, nSlow = 26, nSig = 9, maType = SMA) %>% 
                      mutate(diff = macd - signal) %>% select(-(open:volume))
head(FANG_macd,100)

FANG_rsi <- FANG %>% group_by(symbol) %>% 
                      tq_mutate(select = close, mutate_fun = RSI, n = 14, maType = SMA) %>% 
                      select(-(open:volume))

FANG_adx <- FANG %>% group_by(symbol) %>% 
            tq_mutate(select = c("high","low","close"), mutate_fun = ADX, n = 14, maType = SMA) %>% 
            select(-(open:volume))


FANG_roc <- FANG %>% group_by(symbol) %>% 
            tq_mutate(select = close, mutate_fun = ROC, n = 1, type = c("continuous", "discrete"), na.pad = TRUE) %>% 
            select(-(open:volume))

FANG_momentun <- FANG %>% group_by(symbol) %>% 
                 tq_mutate(select = close, mutate_fun = momentum, n = 1, na.pad = TRUE) %>% 
                 select(-(open:volume))

FANG_hma <- FANG %>% group_by(symbol) %>% 
                 tq_mutate(select = close, mutate_fun = HMA, n = 20) %>% 
                 select(-(open:volume))

FANG_sar <- FANG %>% group_by(symbol) %>% 
            tq_mutate(select = c("high","low"), mutate_fun = SAR, accel = c(0.02, 0.2)) %>% 
            select(-(open:volume))



RSI(price, n = 14, maType, ...)

tickers <- c("FB") 

# Dowload the stock price data

multpl_stocks <- tq_get(tickers, from = "2019-01-01", to = "2020-08-21", get = "stock.prices")

class(multpl_stocks)
head(multpl_stocks)

multpl_stocks %>% group_by(symbol) %>% tq_mutate(select = close, mutate_fun = MACD, nFast = 12, nSlow = 26, nSig = 9, maType = SMA) %>% mutate(diff = macd - signal) %>% select(-(open:volume))


# https://www.r-bloggers.com/quantitative-trading-strategies-using-quantmod/

install.packages("quantstrat")

library(dplyr)
library(quantmod)
library(tidyquant)
library(TTR)
library(timetk)
library(tidyr)
library(ggplot2) 
library(directlabels)
library(data.table)
library(quantstrat)
library(purrr)
library(kableExtra)

install.packages("devtools")
require(devtools)
install_github("braverock/blotter") # dependency
install_github("braverock/quantstrat")



start_date <- "2018-01-01"
end_date <- "2020-08-21"
symbols <- c("AAPL", "AMD", "ADI",  "ABBV", "A",  "APD", "AA", "CF", "NVDA", "HOG", "WMT", "AMZN"
             #,"MSFT", "F", "INTC", "ADBE", "AMG", "AKAM", "ALB", "ALK"
)

getSymbols(symbols, from = start_date, to = end_date)

chartSeries(NVDA,theme = chartTheme("white"),TA = c(addBBands(n = 20, sd = 2, ma = "SMA", draw = 'bands', on = -1))) 
chartSeries(AMZN,theme = chartTheme("white"),TA = c(addBBands(n = 20, sd = 2, ma = "SMA", draw = 'bands', on = -1))) 

rm.strat("BollingerBandsStrat")
currency('USD')

stock(symbols, currency = 'USD', multiplier = 1)


init_date = as.Date(start_date) - 1
init_equity = 1000
portfolio.st <- account.st <- 'BollingerBandsStrat'


initPortf(portfolio.st, symbols = symbols, initDate = init_date)
initAcct(account.st, portfolios = 'BollingerBandsStrat', initDate = init_date)
initOrders(portfolio = portfolio.st, initDate = init_date)

BBands_Strategy <- strategy("BollingerBandsStrat")

#### Adding indicators:

# Add indicators
BBands_Strategy <- add.indicator(strategy = BBands_Strategy, name = "BBands",arguments = list(HLC = quote(HLC(mktdata)),maType = 'SMA'),label = 'BollingerBands_Label')

# Adding signals:

BBands_Strategy <- add.signal(BBands_Strategy, name = "sigCrossover", arguments = list(columns = c("Close","up"), relationship = "gt"), label = "Close.gt.UpperBBand")
BBands_Strategy <- add.signal(BBands_Strategy, name = "sigCrossover", arguments = list(columns = c("Close","dn"), relationship = "lt"), label = "Close.lt.LowerBBand")
BBands_Strategy <- add.signal(BBands_Strategy, name = "sigCrossover", arguments = list(columns = c("High","Low","mavg"), relationship = "op"), label = "Cross.MiddleBBand")

# Add rules

BBands_Strategy <- add.rule(BBands_Strategy, name = 'ruleSignal', arguments = list(sigcol = "Close.gt.UpperBBand", sigval = TRUE, orderqty = -100, ordertype = 'market',orderside = NULL, threshold = NULL), type = 'enter')
BBands_Strategy <- add.rule(BBands_Strategy, name = 'ruleSignal', arguments = list(sigcol = "Close.lt.LowerBBand", sigval = TRUE, orderqty = 100, ordertype = 'market', orderside = NULL, threshold = NULL), type = 'enter')
BBands_Strategy <- add.rule(BBands_Strategy, name = 'ruleSignal', arguments = list(sigcol = "Cross.MiddleBBand", sigval = TRUE, orderqty = 'all', ordertype = 'market', orderside = NULL, threshold = NULL), type = 'exit')


# Apply the strategy and update the portfolio

out <- applyStrategy(strategy = BBands_Strategy, portfolios = 'BollingerBandsStrat', parameters = list( 
    sd = 1.6, # number of standard deviations
    n = 20) # MA periods
)

updatePortf(Portfolio = 'BollingerBandsStrat', Dates = paste('::',as.Date(Sys.time()),sep=''))

tradeStats(portfolio.st) %>% tibble::rownames_to_column("ticker") %>% t() %>% kable() %>% kable_styling(bootstrap_options = c("striped", "hover", "condensed", "responsive"))


for(sym in symbols){
  chart.Posn(Portfolio = 'BollingerBandsStrat', Symbol = sym)
  plot(add_BBands(on = 1, sd = 1.6, n = 20))
  
  perf <- tradeStats(portfolio.st) %>% 
    tibble::rownames_to_column("ticker") %>% 
    filter(ticker == sym) %>% 
    t() %>% 
    kable() %>%
    kable_styling(bootstrap_options = c("striped", "hover", "condensed", "responsive"))
}



### ADX: Directional Movement Index






