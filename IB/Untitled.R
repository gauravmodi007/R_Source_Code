library(IBrokers)

tws <- twsConnect()
isConnected(tws)
reqCurrentTime(tws)
reqAccountUpdates(tws)
?reqHistoricalData()

serverVersion(tws)
twsDisconnect(tws)

reqMktDataType(tws, 3)
reqMktData(tws, twsEquity("AAPL"))

?reqMktData
?reqMktDataType

#contract <- twsEquity("AAPL","SMART","ISLAND")
security <- twsSTK("AAPL")
reqHistoricalData(tws, security)


?twsEquity
?twsSTK
?reqHistoricalData
