
tickers <- c("FB", "AMZN", "AAPL", "NFLX", "GOOG") 

# Dowload the stock price data

multpl_stocks <- tq_get(tickers,
                        from = "2015-01-01",
                        to = "2021-05-30",
                        get = "stock.prices")

multpl_stocks %>%
  ggplot(aes(x = date, y = adjusted, color = symbol)) +
  geom_line() +
  ggtitle("Price chart for multiple stocks")


multpl_stocks %>%
  ggplot(aes(x = date, y = adjusted)) +
  geom_line() +
  facet_wrap(~symbol, scales = "free_y") +  # facet_wrap is used to make diff frames
  theme_classic() +       # using a new theme
  labs(x = "Date", y = "Price") +
  ggtitle("Price chart FAANG stocks")


#Calculating the daily returns for multiple stocks
multpl_stock_daily_returns <- multpl_stocks %>% group_by(symbol) %>% tq_transmute(select = adjusted, mutate_fun = periodReturn, period = 'daily', col_rename = 'returns')

#Calculating the weekly returns for multiple stocks
multpl_stock_weekly_returns <- multpl_stocks %>% group_by(symbol) %>% tq_transmute(select = adjusted, mutate_fun = periodReturn, period = 'weekly', col_rename = 'returns')

#Calculating the monthly returns for multiple stocks
multpl_stock_monthly_returns <- multpl_stocks %>% group_by(symbol) %>% tq_transmute(select = adjusted, mutate_fun = periodReturn, period = 'monthly', col_rename = 'returns')



multpl_stock_monthly_returns %>%
  mutate(returns = if_else(date == "2014-01-31", 0, returns)) %>%
  group_by(symbol) %>%  # Need to group multiple stocks
  mutate(cr = cumprod(1 + returns)) %>%
  mutate(cumulative_returns = cr - 1) %>%
  ggplot(aes(x = date, y = cumulative_returns, color = symbol)) +
  geom_line() +
  labs(x = "Date", y = "Cumulative Returns") +
  ggtitle("Cumulative returns for all since 2015") +
  scale_y_continuous(breaks = seq(0,20,2), labels = scales::percent) +
  scale_color_brewer(palette = "Set1",
                     name = "") +
  theme_bw()



