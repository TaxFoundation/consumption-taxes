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

write.csv(vat_rates, paste(rates,"vat_rates.csv",sep=""), row.names = F)

#Average VAT rate by Year

#Means for 1975-2020####
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

write.csv(vat_rate_avg, paste(rates,"vat_rate_avg.csv",sep=""), row.names = F)

#US VAT rate equivalent
vat_rates<-vat_rates[-c(4)]

year<- c("2014","2015","2016","2017","2018","2019","2020")
rate<- c("7.2","7.3","7.3","7.4","7.4","7.4","7.4")
country<-c("United States","United States","United States","United States","United States","United States","United States")
us <- data.frame(country,year, rate)

write.csv(us, paste(rates,"us_vat_equivalent.csv",sep=""), row.names = F)


#Canada VAT rate equivalent - https://www.retailcouncil.org/resources/quick-facts/sales-tax-rates-by-province/

year<- c("2014","2015","2016","2017","2018","2019","2020")
rate<- c("15.6","10.6","10.6","12.4","12.4","12.4","12.4")
country<-c("Canada","Canada","Canada","Canada","Canada","Canada","Canada")
canada <- data.frame(country,year, rate)

write.csv(canada, paste(rates,"canada_vat_equivalent.csv",sep=""), row.names = F)

#1967-2020 Database####
vat_rates_database <- read_excel(paste(source_data,"vat-gst-rates-historical-tax-database.xlsx",sep=""), 
                                 range = "A2:BC261")

colnames(vat_rates_database)[colnames(vat_rates_database)=="X__1"] <- "category"

#Adjust to a true spreadsheet

#Combine Countries and Standard Rates####
countries<-print(unique(country_names$country))
vat_rates_database_countries<-subset(vat_rates_database,vat_rates_database$category%in%countries)
vat_rates_database_countries$row<-row.names(vat_rates_database_countries)
vat_rates_database_countries<-vat_rates_database_countries[-c(2:55)]
colnames(vat_rates_database_countries)[colnames(vat_rates_database_countries)=="category"] <- "country"

standard<-vat_rates_database
standard$reference<-row.names(vat_rates_database)

standard<-subset(standard,standard$reference!=99)
standard<-subset(standard,standard$reference!=195)
standard<-subset(standard,standard$reference!=202)
standard<-subset(standard,standard$reference!=227)
standard<-subset(standard,standard$reference!=232)

standard<-subset(standard,standard$category=="Standard rate")

standard$row<-row.names(standard)

vat_1967_2020<-merge(vat_rates_database_countries,standard,by="row")

vat_1967_2020<-vat_1967_2020[-c(1,58)]

vat_1967_2020_long <- melt(vat_1967_2020,id.vars=c("country","category"))

colnames(vat_1967_2020_long)<-c("country","category","year","rate")
vat_1967_2020_long$rate <- str_remove_all(vat_1967_2020_long$rate, "[-]")
vat_1967_2020_long$rate <-as.numeric(vat_1967_2020_long$rate)

write.csv(vat_1967_2020_long, paste(rates,"vat_1967_2020_long.csv",sep=""), row.names = F)

#Standard Rate Means for 1967-2020####
magic_for(silent = TRUE)
years<-print(unique(vat_1967_2020_long$year))

for(year in years){
  vat_rate_avg<-mean(vat_1967_2020_long$rate[vat_1967_2020_long$year==year],na.rm = T)
  put(vat_rate_avg)
}
vat_rate_avg_1967_2020<-magic_result_as_dataframe() 

vat_1967_2020_long$key<-if_else(vat_1967_2020_long$rate!="NA",1,0)
count<-vat_1967_2020_long%>%
  count(key,year)

count<-subset(count,count$key!="NA")

vat_rate_avg_1967_2020<-merge(vat_rate_avg_1967_2020,count,by="year")
vat_rate_avg_1967_2020<-vat_rate_avg_1967_2020[-c(3)]
colnames(vat_rate_avg_1967_2020)[colnames(vat_rate_avg_1967_2020)=="n"] <- "observations"

write.csv(vat_rate_avg_1967_2020, paste(rates,"vat_rate_avg_1967_2020.csv",sep=""), row.names = F)

#Reduced rates####
reduced<-vat_rates_database
reduced$reference<-row.names(vat_rates_database)

reduced<-subset(reduced,reduced$reference!=101)
reduced<-subset(reduced,reduced$reference!=197)
reduced<-subset(reduced,reduced$reference!=204)
reduced<-subset(reduced,reduced$reference!=229)
reduced<-subset(reduced,reduced$reference!=234)


reduced<-subset(reduced,reduced$category=="Reduced rates")

reduced$row<-row.names(reduced)

reduced_countries<-subset(vat_rates_database_countries,vat_rates_database_countries$country!="Chile")
reduced_countries<-subset(reduced_countries,reduced_countries$country!="New Zealand")

reduced_countries$row<-row.names(reduced_countries)

reduced_1967_2020<-merge(reduced_countries,reduced,by="row")

reduced_1967_2020<-reduced_1967_2020[-c(1,58)]

reduced_1967_2020_long <- melt(reduced_1967_2020,id.vars=c("country","category"))

colnames(reduced_1967_2020_long)<-c("country","category","year","rate")
reduced_1967_2020_long$rate <- str_remove_all(reduced_1967_2020_long$rate, "[-]")

#Separate Reduced Rates into multiple variables
reduced_1967_2020_long<-reduced_1967_2020_long%>%
  separate(rate,c("reduced_1","reduced_2","reduced_3","reduced_4","reduced_5","reduced_6"),"/")

reduced_1967_2020_long<-reduced_1967_2020_long[-c(2)]

reduced_1967_2020_long <- melt(reduced_1967_2020_long,id.vars=c("country","year"))


#Add reduced rates to standard rates
standard<-vat_1967_2020_long
standard<-standard[-c(5)]

reduced<-reduced_1967_2020_long
colnames(reduced)<-c("country","year","category","rate")

standard_reduced<-merge(standard,reduced,by=c("country","year","category","rate"),all=T)

#Higher rates


vat_rates_database_standard<-vat_rates_database_standard[-c(2:55)]
colnames(vat_rates_database_standard)[colnames(vat_rates_database_standard)=="category"] <- "country"





vat_rates_database<-subset(vat_rates_database,vat_rates_database$category!="Implementation date")
vat_rates_database<-subset(vat_rates_database,vat_rates_database$category!="Reduced rates")
vat_rates_database<-subset(vat_rates_database,vat_rates_database$category!="Higher rate")



