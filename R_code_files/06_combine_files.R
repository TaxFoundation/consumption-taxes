#Combine files####
vat_base <- read_csv(paste(intermediate_outputs,"vat_base.csv",sep=""))
vat_rates <- read_csv(paste(intermediate_outputs,"vat_rates.csv",sep=""))
vat_thresholds <- read_csv(paste(intermediate_outputs,"vat_thresholds.csv",sep=""))

vat_data <- merge(vat_rates, vat_thresholds, by=c("country","year"))
vat_data <- merge(vat_data,vat_base,by=c("country", "year"))

vat_data <- merge(vat_data,iso_country_codes,by=c("country"))
vat_data <- vat_data[c("ISO_2","ISO_3","country","year","vat_rate","vat_threshold","vat_base")]

write.csv(vat_data,file = paste(intermediate_outputs,"vat_data.csv",sep=""),row.names=F)