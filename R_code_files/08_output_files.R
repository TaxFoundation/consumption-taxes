#Revenue Output Table
consumption_revenue<-read_csv(paste(revenues,"revenue_final.csv",sep=""))
write.csv(consumption_revenue,file = paste(final_outputs,"revenue.csv",sep=""),row.names=F)

###Reduced Rates Output Table
reduced_rates<-read_csv(paste(intermediate_outputs,"consumption_data.csv",sep=""))
#keep latest year
reduced_rates<-subset(reduced_rates,reduced_rates$year==2020)

#drop unnecessary variables
reduced_rates<-reduced_rates[-c(4:7,14:49)]

#melt and rename
reduced_rates <- melt(reduced_rates,id.vars=c("iso_2","iso_3","country"))
colnames(reduced_rates)[colnames(reduced_rates)=="value"] <- "reduced_rate"

#drop NA values
reduced_rates<-subset(reduced_rates,reduced_rates$value!="NA")

#merge with reduced rates base

#####Excise Tables
#Alcohol
alcohol<-read_csv(paste(intermediate_outputs,"consumption_data.csv",sep=""))
#keep latest year
alcohol<-subset(alcohol,alcohol$year==2020)

#drop unnecessary variables
alcohol<-alcohol[-c(4:24,32:49)]
alcohol<-alcohol[-c(5,8,10)]

#hectoliters to liters
alcohol$beer<-alcohol$beer_excise_hl_usd/100
alcohol$wine_still<-alcohol$still_wine_excise_hl_usd/100
alcohol$wine_sparkling<-alcohol$sparkling_wine_excise_hl_usd/100
alcohol$spirits<-alcohol$alc_excise_hl_usd/100

#drop hectoliters
alcohol<-alcohol[-c(4:7)]

#melt
alcohol <- melt(alcohol,id.vars=c("iso_2","iso_3","country"))

#average
magic_for(silent = TRUE)
variables<-print(unique(alcohol$variable))

for(variable in variables){
  average<-mean(alcohol$value[alcohol$variable==variable],na.rm = T)
  put(average)
}
average<-magic_result_as_dataframe() 

#merge average with alcohol
alcohol<-merge(alcohol,average, by="variable", all=T)

#reorder and rename
col_order <- c("iso_2", "iso_3", "country",
               "variable", "value", "average")
alcohol <- alcohol[, col_order]
colnames(alcohol)<-c("iso_2","iso_3","country","alcohol_type","excise_liter_usd","oecd_avg_liter_usd")

#write
write.csv(alcohol,file = paste(final_outputs,"alcohol.csv",sep=""),row.names=F)


#Fuel
fuel<-read_csv(paste(intermediate_outputs,"consumption_data.csv",sep=""))
#keep latest year
fuel<-subset(fuel,fuel$year==2019)

#drop unnecessary variables
fuel<-fuel[-c(4:43)]
fuel<-fuel[-c(5,7,9)]

#melt
fuel <- melt(fuel,id.vars=c("iso_2","iso_3","country"))

#average
magic_for(silent = TRUE)
variables<-print(unique(fuel$variable))

for(variable in variables){
  average<-mean(fuel$value[fuel$variable==variable],na.rm = T)
  put(average)
}
average<-magic_result_as_dataframe() 

#merge average with fuel
fuel<-merge(fuel,average, by="variable", all=T)

#reorder and rename
col_order <- c("iso_2", "iso_3", "country",
               "variable", "value", "average")
fuel <- fuel[, col_order]
colnames(fuel)<-c("iso_2","iso_3","country","fuel_type","total_tax_pct","oecd_avg_total_tax_pct")

#write
write.csv(fuel,file = paste(final_outputs,"fuel.csv",sep=""),row.names=F)
