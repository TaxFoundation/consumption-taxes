# VAT Source Data

#VAT Rates####

vat_rates <- read_excel(paste(source_data,"vat-gst-rates-ctt-trends.xlsx",sep=""), 
                        range = "A4:T39")

vat_rates<-vat_rates[-c(2)]

colnames(vat_rates) <- c("country", "year", "2014", "2015", "2016", "2017", "2018", "2019", "2020")

vat_rates <- melt(vat_rates,id.vars=c("country"))



#US VAT rate equivalent
columns <- names(vat_rates)
values <- c("United States","","7.2","7.3","7.3","7.4","7.4","7.4","7.4")
US <- data.frame(columns, values)
US <- spread(US, columns, values)

vat_rates <- rbind(vat_rates, US)

#Canada VAT rate equivalent - https://www.retailcouncil.org/resources/quick-facts/sales-tax-rates-by-province/
columns <- names(vat_rates)
values <- c("Canada","","15.6","10.6","10.6","12.4","12.4","12.4","12.4")
Canada <- data.frame(columns, values)
Canada <- spread(Canada, columns, values)

vat_rates <- subset(vat_rates, vat_rates$country!="Canada*")
vat_rates <- rbind(vat_rates, Canada)

vat_rates <- vat_rates[-c(2)]
vat_rates <- melt(vat_rates,id.vars=c("country"))
colnames(vat_rates) <- c("country", "year", "vat_rate")
vat_rates$country <- str_remove_all(vat_rates$country, "[*]")

write.csv(vat_rates,paste(intermediate_outputs,"vat_rates.csv",sep=""),row.names = FALSE)