#Combine files####
consumption_revenue<-read_csv(paste(revenues,"revenue_final.csv",sep=""))
vat_rates <- read_csv(paste(rates,"vat_rates_1967_2020.csv",sep=""))
vat_thresholds<-read_csv(paste(thresholds,"vat_thresholds.csv",sep=""))
vat_base <- read_csv(paste(base,"vat_base_1976_2019.csv",sep=""))

consumption_data <- merge(vat_rates, vat_thresholds, by=c("iso_2","iso_3","country","year"),all=T)
consumption_data <- merge(consumption_data, vat_base, by=c("iso_2","iso_3","country","year"),all=T)
consumption_data <- merge(consumption_data, consumption_revenue,by=c("iso_2","iso_3","country","year"),all=T)

write.csv(consumption_data,file = paste(intermediate_outputs,"consumption_data.csv",sep=""),row.names=F)

#Combine trend files####
consumption_pct_gdp<-read_csv(paste(revenues,"consumption_pct_gdp.csv",sep=""))
consumption_pct_rev<-read_csv(paste(revenues,"consumption_pct_rev.csv",sep=""))
vat_rate_trend<-read_csv(paste(rates,"vat_rate_avg_1975_2020.csv",sep=""))
vat_threshold_trend<-read_csv(paste(thresholds,"thresholds_2007_2020.csv",sep=""))
vat_base_trend<-read_csv(paste(base,"vat_base_avg_1976_2019.csv",sep=""))


consumption_trends<-merge(consumption_pct_gdp,consumption_pct_rev,by="year",all=T)
consumption_trends<-merge(consumption_trends,vat_rate_trend,by="year",all=T)
consumption_trends<-merge(consumption_trends,vat_threshold_trend,by="year",all=T)
consumption_trends<-merge(consumption_trends,vat_base_trend,by="year",all=T)

write.csv(consumption_trends,file = paste(intermediate_outputs,"consumption_trends.csv",sep=""),row.names=F)
