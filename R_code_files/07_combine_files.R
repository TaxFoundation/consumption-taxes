#Combine files####
consumption_revenue<-read_csv(paste(revenues,"revenue_final.csv",sep=""))
vat_rates <- read_csv(paste(rates,"vat_rates_1967_2020.csv",sep=""))
vat_thresholds<-read_csv(paste(thresholds,"vat_thresholds.csv",sep=""))
vat_base <- read_csv(paste(base,"vat_base_1976_2019.csv",sep=""))

vat_data <- merge(vat_rates, vat_thresholds, by=c("iso_2","iso_3","country","year"),all=T)
vat_data <- merge(vat_data, vat_base, by=c("iso_2","iso_3","country","year"),all=T)
vat_data <- merge(vat_data, consumption_revenue,by=c("iso_2","iso_3","country","year"),all=T)

write.csv(vat_data,file = paste(intermediate_outputs,"vat_data.csv",sep=""),row.names=F)

#Combine trend files####


vat_data <- merge(vat_data,vat_base,by=c("country", "year"))

vat_data <- merge(vat_data,iso_country_codes,by=c("country"))
vat_data <- vat_data[c("ISO_2","ISO_3","country","year","vat_rate","vat_threshold","vat_base")]

write.csv(vat_data,file = paste(intermediate_outputs,"vat_data.csv",sep=""),row.names=F)