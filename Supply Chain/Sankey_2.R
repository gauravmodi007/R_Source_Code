

nodes1 <- data.frame(
  name=c(as.character(SupplyChainData$S), 
         as.character(SupplyChainData$D)) %>% unique()
)


SupplyChainData$IDsource <- match(SupplyChainData$S, nodes1$name)-1 
SupplyChainData$IDtarget <- match(SupplyChainData$D, nodes1$name)-1

SupplyChainData <- data.frame(SupplyChainData)

p <- sankeyNetwork(Links = SupplyChainData, Nodes = nodes1,
                   Source = "IDsource", Target = "IDtarget",
                   Value = "VALUE", NodeID = "name", 
                   sinksRight=FALSE)
p

#####################

SupplyChainData0513_1 <- SupplyChainData0513 %>% filter(S == 'FL')

SupplyChainData0513_1$percentage <- (SupplyChainData0513_1$VALUE/(sum(SupplyChainData0513_1$VALUE)/2))*100

nodes1 <- data.frame(
  name=c(as.character(SupplyChainData0513_1$S), 
         as.character(SupplyChainData0513_1$D)) %>% unique()
)


SupplyChainData0513_1$IDsource <- match(SupplyChainData0513_1$S, nodes1$name)-1 
SupplyChainData0513_1$IDtarget <- match(SupplyChainData0513_1$D, nodes1$name)-1

SupplyChainData0513_1 <- data.frame(SupplyChainData0513_1)

p <- sankeyNetwork(Links = SupplyChainData0513_1, Nodes = nodes1,
                   Source = "IDsource", Target = "IDtarget",
                   Value = "percentage", NodeID = "name", 
                   iterations = 10,
                   fontSize = 15, 
                   nodeWidth = 10,
                   sinksRight=TRUE)
p
