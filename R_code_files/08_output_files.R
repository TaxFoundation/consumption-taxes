#Revenue Output Table####
consumption_revenue<-read_csv(paste(revenues,"revenue_final.csv",sep=""))
write.csv(consumption_revenue,file = paste(final_outputs,"revenue.csv",sep=""),row.names=F)

#merge with reduced rates base
#USE CONSUMPTION TAX TRENDS ANNEX TABLE 2.A.2
#####Excise Tables####
#Alcohol
alcohol<-read_csv(paste(intermediate_outputs,"consumption_data.csv",sep=""))
#keep latest year
alcohol<-subset(alcohol,alcohol$year==2020)

#drop unnecessary variables
alcohol<-alcohol[-c(5:24,32:49)]
alcohol<-alcohol[-c(6,9,11)]

#hectoliters to liters
alcohol$beer<-alcohol$beer_excise_hl_usd/100
alcohol$wine_still<-alcohol$still_wine_excise_hl_usd/100
alcohol$wine_sparkling<-alcohol$sparkling_wine_excise_hl_usd/100
alcohol$spirits<-alcohol$alc_excise_hl_usd/100

#drop hectoliters
alcohol<-alcohol[-c(5:8)]

#melt
alcohol <- melt(alcohol,id.vars=c("iso_2","iso_3","country","year"))

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
col_order <- c("iso_2", "iso_3", "country","year",
               "variable", "value", "average")
alcohol <- alcohol[, col_order]
colnames(alcohol)<-c("iso_2","iso_3","country","year","alcohol_type","excise_liter_usd","oecd_avg_liter_usd")

#write
write.csv(alcohol,file = paste(final_outputs,"alcohol.csv",sep=""),row.names=F)


#Fuel
fuel<-read_csv(paste(intermediate_outputs,"consumption_data.csv",sep=""))
#keep latest year
fuel<-subset(fuel,fuel$year==2019)

#drop unnecessary variables
fuel<-fuel[-c(5:43)]
fuel<-fuel[-c(6,8,10)]

#melt
fuel <- melt(fuel,id.vars=c("iso_2","iso_3","country","year"))
fuel$value<-as.numeric(fuel$value)
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
col_order <- c("iso_2", "iso_3", "country","year",
               "variable", "value", "average")
fuel <- fuel[, col_order]
colnames(fuel)<-c("iso_2","iso_3","country","year","fuel_type","total_tax_pct","oecd_avg_total_tax_pct")

#write
write.csv(fuel,file = paste(final_outputs,"fuel.csv",sep=""),row.names=F)

#tobacco
tobacco<-read_csv(paste(intermediate_outputs,"consumption_data.csv",sep=""))
#keep latest year
tobacco<-subset(tobacco,tobacco$year==2020)

#drop unnecessary variables
tobacco<-tobacco[-c(5:31,38:49)]
tobacco_ad_valorem<-tobacco[-c(5,7,9)]
tobacco_excise<-tobacco[-c(6,8,10)]

#melt
tobacco_excise <- melt(tobacco_excise,id.vars=c("iso_2","iso_3","country","year"))
tobacco_ad_valorem <- melt(tobacco_ad_valorem,id.vars=c("iso_2","iso_3","country","year"))

#average excise
magic_for(silent = TRUE)
variables<-print(unique(tobacco_excise$variable))

for(variable in variables){
  average<-mean(tobacco_excise$value[tobacco_excise$variable==variable],na.rm = T)
  put(average)
}
average_excise<-magic_result_as_dataframe() 

#merge average with tobacco_excise
tobacco_excise<-merge(tobacco_excise,average_excise, by="variable", all=T)

#average ad valorem
magic_for(silent = TRUE)
variables<-print(unique(tobacco_ad_valorem$variable))

for(variable in variables){
  average<-mean(tobacco_ad_valorem$value[tobacco_ad_valorem$variable==variable],na.rm = T)
  put(average)
}
average_ad_valorem<-magic_result_as_dataframe() 

#merge average with tobacco_ad_valorem
tobacco_ad_valorem<-merge(tobacco_ad_valorem,average_ad_valorem, by="variable", all=T)

#rbind all tobacco
tobacco<-rbind(tobacco_excise,tobacco_ad_valorem)

#reorder and rename
col_order <- c("iso_2", "iso_3", "country","year",
               "variable", "value", "average")
tobacco <- tobacco[, col_order]
colnames(tobacco)<-c("iso_2","iso_3","country","year","tobacco_excise_type","tobacco_excise","oecd_avg_excise")

#write
write.csv(tobacco,file = paste(final_outputs,"tobacco.csv",sep=""),row.names=F)
