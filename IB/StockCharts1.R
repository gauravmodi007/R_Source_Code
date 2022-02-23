library(quantmod)
library(xts)
library(rvest)
library(tidyverse)
library(stringr)
library(forcats)
library(lubridate)
library(plotly)
library(dplyr)
library(PerformanceAnalytics)


getSymbols("AMZN",from="2019-01-01",to="2021-05-30")
AMZN_log_returns<-AMZN%>%Ad()%>%dailyReturn(type='log')

AMZN%>%Ad()%>%chartSeries()
AMZN%>%chartSeries(TA='addBBands();addVo();addMACD();addSAR()',subset='2021')

AMZN%>%chartSeries(TA='addEMA(7,col = "green");addEMA(21,col = "red")',subset='2021',theme=chartTheme('white'))

data(ttrc)
sar <- SAR(ttrc[,c("High","Low")])

head(ttrc)

ttrc %>% mutate(SAR = SAR(ttrc[,c("High","Low")]))

ttrc$sar <- SAR(ttrc[,c("High","Low")])

?ADX
?SAR
?addEMA
?TTR

class(ttrc)
data(ttrc)
roc <- ROC(ttrc[,"Close"])
mom <- momentum(ttrc[,"Close"])

?MACD

macd  <- MACD(ttrc[,"Close"], 12, 26, 9, maType="EMA")



library(PerformanceAnalytics)
data<-cbind(diff(log(Cl(AMZN))),diff(log(Cl(FB))))
chart.Correlation(data)


mu<-AMZN_mean_log # mean of log returns
sig<-AMZN_sd_log # sd of log returns 
price<-rep(NA,252*4)
#start simulating prices
for(i in 2:length(testsim)){
  price[i]<-price[i-1]*exp(rnorm(1,mu,sig))
}
random_data<-cbind(price,1:(252*4))
colnames(random_data)<-c("Price","Day")
random_data<-as.data.frame(random_data)
random_data%>%ggplot(aes(Day,Price))+geom_line()+labs(title="Amazon (AMZN) price simulation for 4 years")+theme_bw()




N<-500
mc_matrix<-matrix(nrow=252*4,ncol=N)
mc_matrix[1,1]<-as.numeric(AMZN$AMZN.Adjusted[length(AMZN$AMZN.Adjusted),])
for(j in 1:ncol(mc_matrix)){
  mc_matrix[1,j]<-as.numeric(AMZN$AMZN.Adjusted[length(AMZN$AMZN.Adjusted),])
  for(i in 2:nrow(mc_matrix)){
    mc_matrix[i,j]<-mc_matrix[i-1,j]*exp(rnorm(1,mu,sig))
  }
}
name<-str_c("Sim ",seq(1,500))
name<-c("Day",name)
final_mat<-cbind(1:(252*4),mc_matrix)
final_mat<-as.tibble(final_mat)
colnames(final_mat)<-name
dim(final_mat) #1008 501
final_mat%>%gather("Simulation","Price",2:501)%>%ggplot(aes(x=Day,y=Price,Group=Simulation))+geom_line(alpha=0.2)+labs(title="Amazon Stock (AMZN): 500 Monte Carlo Simulations for 4 Years")+theme_bw()

