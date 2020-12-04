#VAT Rates####

#VAT Rates Historic
vat_rates_historic <- read_excel(paste(source_data,"historic-vat-gst-rates-ctt-trends.xlsx",sep=""), 
                        range = "A4:T39")

vat_rates_historic<-vat_rates_historic[-c(2)]

colnames(vat_rates_historic)[colnames(vat_rates_historic)=="X__1"] <- "country"

vat_rates_historic <- melt(vat_rates_historic,id.vars=c("country"))

colnames(vat_rates_historic)<-c("country","year","rate")
vat_rates_historic$year<-as.numeric(vat_rates_historic$year)
#VAT Rates Current
vat_rates_current <- read_excel(paste(source_data,"current-vat-gst-rates-ctt-trends.xlsx",sep=""), 
                                 range = "A1:P37")

colnames(vat_rates_current)[colnames(vat_rates_current)=="X__1"] <- "country"

vat_rates_current <- melt(vat_rates_current,id.vars=c("country"))

colnames(vat_rates_current)<-c("country","year","rate")

#Subset Historic Data to just 1975, 1985, and 1995####
vat_rates_historic<-subset(vat_rates_historic,vat_rates_historic$year<4)
vat_rates_historic$year<-if_else(vat_rates_historic$year=="1","1975",
                                 if_else(vat_rates_historic$year=="2","1985",
                                         if_else(vat_rates_historic$year=="3","1995","0")))
vat_rates_historic$country <- str_remove_all(vat_rates_historic$country, "[*]")


#Combine Historic and Current Data####
vat_rates<-rbind(vat_rates_historic,vat_rates_current)

vat_rates$rate <- str_remove_all(vat_rates$rate, "[-]")
vat_rates$rate <-as.numeric(vat_rates$rate)

write.csv(vat_rates, paste(intermediate_outputs,"vat_rates.csv",sep=""), row.names = F)

#Average VAT rate by Year

#Means for 2000-2019####
magic_for(silent = TRUE)
years<-print(unique(vat_rates$year))

for(year in years){
  vat_rate_avg<-mean(vat_rates$rate[vat_rates$year==year],na.rm = T)
  put(vat_rate_avg)
}
vat_rate_avg<-magic_result_as_dataframe() 

vat_rates$key<-if_else(vat_rates$rate!="NA",1,0)
count<-vat_rates%>%
  count(key,year)

count<-subset(count,count$key!="NA")

vat_rate_avg<-merge(vat_rate_avg,count,by="year")
vat_rate_avg<-vat_rate_avg[-c(3)]
colnames(vat_rate_avg)[colnames(vat_rate_avg)=="n"] <- "observations"

write.csv(vat_rate_avg, paste(intermediate_outputs,"vat_rate_avg.csv",sep=""), row.names = F)

#US VAT rate equivalent
vat_rates<-vat_rates[-c(4)]

year<- c("2014","2015","2016","2017","2018","2019","2020")
rate<- c("7.2","7.3","7.3","7.4","7.4","7.4","7.4")
country<-c("United States","United States","United States","United States","United States","United States","United States")
us <- data.frame(country,year, rate)

write.csv(us, paste(intermediate_outputs,"us_vat_equivalent.csv",sep=""), row.names = F)


#Canada VAT rate equivalent - https://www.retailcouncil.org/resources/quick-facts/sales-tax-rates-by-province/

year<- c("2014","2015","2016","2017","2018","2019","2020")
rate<- c("15.6","10.6","10.6","12.4","12.4","12.4","12.4")
country<-c("Canada","Canada","Canada","Canada","Canada","Canada","Canada")
canada <- data.frame(country,year, rate)

write.csv(canada, paste(intermediate_outputs,"canada_vat_equivalent.csv",sep=""), row.names = F)