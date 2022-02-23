#######################################################################
####
#### Custom Indicators
#### Wherever symbol is passed – must be object itself not name 
#### Avoide doing get(symbol) every time
########################################################################
########################################################################
#### ICHIMOKU CLOUD 
########################################################################
ichimoku <- function(HLC, nFast=9, nMed=26, nSlow=52) {
  conversionLine <- (runMax(Hi(HLC), nFast)+runMin(Lo(HLC), nFast))/2
  baseLine <- (runMax(Hi(HLC), nMed)+runMin(Lo(HLC), nMed))/2
  spanA <- lag((conversionLine+baseLine)/2, nMed)
  spanB <- lag((runMax(Hi(HLC), nSlow)+runMin(Lo(HLC), nSlow))/2, nMed)
  laggingSpan <- lag(Cl(HLC), nMed)
  out <- cbind(turnLine=conversionLine, baseLine=baseLine, spanA=spanA, spanB=spanB, laggingSpan=laggingSpan )
  colnames(out) <- c(“conversionLine”, “baseLine”, “spanA”, “spanB”, “laggingSpan” )
  return (out)
}
########################################################################
#### CONNORS RSI 
#### requires RSI (relative strength indicator) from TTR 
### see https://www.qmatix.com/ConnorsRSI-Pullbacks-guidebook.pdf
########################################################################
connorsRSI <- function(price, nRSI = 3, nStreak = 2, nPercentLookBack = 100 ) {
  priceRSI <- RSI(price, nRSI)
  streakRSI <- RSI(streakUpDn(price), nStreak)
  percents <- round(runPercentRank(x = diff(log(price)), n = 100,
                                   cumulative = FALSE, exact.multiplier = 1) * 100)
  ret <- (priceRSI + streakRSI + percents) / 3
  colnames(ret) <- “connorsRSI”
  return(ret)
}
########################################################################
#### STREAK UP / DOWN
#### computes consecutive up / down streaks 
### this version a lot better !! still not as good as R4Trading
########################################################################
streakUpDn <- function(datPrice ) { 
  df <- as.vector(sign(diff(datPrice)))
  df[1] = 0
  runLengthPriceDiff <- rle(df) ### using run length encoding!
  len = runLengthPriceDiff$lengths; val = runLengthPriceDiff$values
  val[val == 0] = 1 ## if same closing will consider as up streak
  mtx = matrix(c(len,val), nrow=2, byrow=T)
  return(unlist(apply(mtx, 2, function(x) seq(x[2], sign(x[2]) * x[1], x[2] ))) )
  ## use this if same close not considered as upstreak!! comment line above ” val[val == 0] = 1 “”
  #return(unlist(apply(mtx, 2, function(x) if (x[2] == 0) rep(x[2], x[1]) else seq(x[2], sign(x[2]) * x[1], x[2] )) ) )
}
########################################################################
#### ICHIMOKU CLOUD PLOTTING
########################################################################
require(ggplot2)
plotCloud <- function(symbol, from=NULL, to=Sys.Date()) {
  require(reshape2)
  data = get(symbol)
  ichi =ichimoku(HLC(data ))
  
  if ( is.null(from) ) from = index(ichi)[1]
  ichi = ichi[paste0(from,“::”, to)] ### just pick dates we want to plot
  ## to remove timestamp
  #index(ichi) = as.Date(unlist(lapply(strsplit(as.character(index(ichi)),” “),function(x) x[1])))
  df_ichi = data.frame ( Date = index(ichi),
                         conversionLine = ichi$conversionLine,
                         baseLine = ichi$ baseLine,
                         spanA = ichi$spanA ,
                         spanB= ichi$spanB,
                         laggingSpan = ichi$laggingSpan)
  colnames(df_ichi) <- c(“Date”, “conversionLine”, “baseLine”, “spanA”, “spanB”, “laggingSpan”)
  df_ichi <- cbind(df_ichi, minSpan_line = pmin(df_ichi$spanA, df_ichi$spanB) ) 
  melted_ichi = melt(df_ichi, id.vars = c(“Date”, “minSpan_line”),
                     measured.vars=c(“spanA”, “spanB”),variable.name=“spanType”, value.name=“IndicatorValue”, na.rm = T )
  ## 
  plot_ichi = melted_ichi[(melted_ichi$spanType %in% c(“spanA”, “spanB”)),]
  sp <- ggplot(data = plot_ichi, aes(x=Date, fill=spanType))
  sp <- sp + geom_ribbon(aes(ymax=IndicatorValue, ymin=minSpan_line))
  sp <- sp + scale_fill_manual(values=c(spanA =“green”, spanB = “red”))
  sp <- sp + theme(legend.position=c(0.2,.85), legend.justification=c(1,0))
  sp <- sp + ggtitle(paste0(“Ichimoku Cloud Plot for Ticker “, symbol) )
  plot(sp)
}

plotCloudAndPrice <- function(symbol, from=NULL, to=Sys.Date()) {
  data = get(symbol)
  ichi =ichimoku(HLC(data ))
  require(reshape2)
  if ( is.null(from) ) from = index(ichi)[1]
  ichi = ichi[paste0(from,“::”, to)] ### just pick dates we want to plot
  clpr = Cl(data [paste0(from,“::”, to)]) 
  #df_clpr = data.frame ( Date = index(clpr), minSpan_line = 0, spanType = “ClosePrice”, Close = clpr[,1])
  df_clpr = data.frame ( Date = index(clpr), Close = clpr[,1])
  #df_clpr$spanType = “ClosePrice”
  #colnames(df_clpr) = c(“Date”, “minSpan_line”, “spanType”, “IndicatorValue”)
  colnames(df_clpr) = c(“Date”, “IndicatorValue”)
  ## to remove timestamp
  #index(ichi) = as.Date(unlist(lapply(strsplit(as.character(index(ichi)),” “),function(x) x[1])))
  df_ichi = data.frame ( Date = index(ichi), spanA = ichi$spanA, spanB= ichi$spanB)
  colnames(df_ichi) <- c(“Date”, “spanA”, “spanB”)
  df_ichi <- cbind(df_ichi, minSpan_line = pmin(df_ichi$spanA, df_ichi$spanB) ) 
  melted_ichi = melt(df_ichi, id.vars = c(“Date”, “minSpan_line”),
                     measured.vars=c(“spanA”, “spanB”),variable.name=“spanType”, value.name=“IndicatorValue”, na.rm = T )
  ## 
  ##melted_ichi = rbind( df_clpr ,melted_ichi)
  plot_ichi = melted_ichi[(melted_ichi$spanType %in% c(“spanA”, “spanB”)),]
  sp <- ggplot( plot_ichi) + geom_ribbon( aes(x=Date, fill=spanType, ymax=IndicatorValue, ymin=minSpan_line))
  sp <- sp + scale_fill_manual(values=c(spanA =“green”, spanB = “red”))
  sp <- sp + theme(legend.position=c(0.2,.85), legend.justification=c(1,0))
  sp <- sp + ggtitle(paste0(“Ichimoku Cloud Plot for Ticker “ , symbol)) 
  sp <- sp + geom_line(data=df_clpr, aes(x=Date,y = IndicatorValue ), colour=“black”) 
  plot(sp)
}
########################################################################
#### FIBONACCI SWING HIGH / LOW 
########################################################################
##### To get swing High / Low
### some say just take Hi & Lo over past 90 day period
### but the defn is max/min +/- 2days back & ahead
### Is referenced in the Fibonacci retracement etc.,
### also assume quantmod / xts etc., loaded
### symbol passed as object not char name
########################################################################
swingHighLow <- function( symbol, lookback = 90) {
  require (magrittr)
  tail90 <- last(symbol, lookback)
  cmp = “>=”
  fx<-function(x, cmp=cmp) ifelse( eval(parse(text=paste0(“x”, cmp, “0”)) ) , 1, 0 )
  ### need to test for case if swing point not present !!
  getSwingPoint <- function( dat, HiLo =c(“hi”, “lo“)) {
    switch(HiLo, 
           hi = { cmp = “>=”; prc = Hi(dat) },
           lo = { cmp = “<=”; prc = Lo(dat)}
    ) 
    prlag1 = diff(prc) %>% fx(.,cmp=cmp) 
    prlag2 = diff(prc,2) %>% fx(., cmp=cmp) 
    matches = which((prlag1+prlag2) == 2)
    
    #### To get the Swing High & Low we need do regular lag 
    ### But also to look ahead, in other do this backwards or in reverse /!!!
    ### and then find where both match definition of swing
    ### If none found, then null return
    ### reverse processing tricky – see notes below!
    
    rvlag2 = diff(rev(prc),2) %>% as.vector(.) %>% fx(.,cmp=cmp)
    rvlag1 = diff(rev(prc)) %>% as.vector(.) %>% fx(.,cmp=cmp)
    rvlag1 = c(0, rvlag1)
    rvlag2 = c(0, 0, rvlag2)
    RVL = rev(rvlag1 + rvlag2)
    FWL = as.vector(prlag1 + prlag2); FWL[(is.na(FWL))] = 0
    ### points of fwd i.e., cmp to previous prices 
    fwdpts = which(FWL ==2)
    ### points of rev , i.e., after prices
    ### note that revpts is indexd into thw fwdpts & not the input price data
    revpts = fwdpts[which(RVL[fwdpts] == 2) ]
    
    ### take the latest, i.e., max
    if (HiLo == “hi”) 
      pkpt = which(Hi(dat) == max(Hi(dat[revpts])) ) else
        pkpt = which(Lo(dat) == min(Lo(dat[revpts])) )
    if ( length(pkpt) == 0 ) return(NULL)
    swingpt = dat[index(prc)[pkpt],] 
    
    return(swingpt)
  }
  swingHigh = cbind(getSwingPoint( tail90, HiLo = “hi”), SwingPoint = 99)
  swingLo = cbind(getSwingPoint( tail90, HiLo = “lo”) , SwingPoint = 11)
  return(rbind(swingLo, swingHigh))
}
########################################################################
#### PLOT FIBONACCI RETRACEMENTS 
########################################################################
### lookback needs to be same as above
### fiboSwing contains Swing High / Low as above
### fiboSwing must be obtained as fiboSwing = swingHighLow(LUV)
### where LUV is object (SouthWest Airlines)
########################################################################
plotFiboRetracements <- function( symName, lookback=90, fiboSwing) {
  symbol = get(symName)
  tail90 <- last(symbol, lookback)
  tail90$Max <- as.vector(Hi(fiboSwing[(fiboSwing$SwingPoint == 99)]))
  tail90$Min <- as.vector(Lo(fiboSwing[(fiboSwing$SwingPoint == 11)]) )
  tail90$Lvl786 <- tail90$Max – (tail90$Max – tail90$Min) * 0.786;
  tail90$Lvl618 <- tail90$Max – (tail90$Max – tail90$Min) * 0.618;
  tail90$Lvl500 <- tail90$Max – (tail90$Max – tail90$Min) * 0.500;
  tail90$Lvl382 <- tail90$Max – (tail90$Max – tail90$Min) * 0.382;
  tail90$Lvl236 <- tail90$Max – (tail90$Max – tail90$Min) * 0.236;
  tail90$Lvl1236 <- tail90$Max + (tail90$Max – tail90$Min) * 0.236;
  
  chart_Series(tail90, theme=chart_theme())
  add_Series( tail90$Lvl786, on=1, legend = “0.786”)
  add_Series( tail90$Lvl618, on=1, legend = “0.618”)
  add_Series( tail90$Lvl500, on=1, legend = “0.500”)
  add_Series( tail90$Lvl382, on=1, legend = “0.382”)
  add_Series( tail90$Lvl236, on=1, legend = “0.236”)
  add_Series( tail90$Lvl1236, on=1, legend = “1.236”)
}