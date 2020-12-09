#Beer####
beer_2018<-read_excel(paste(source_data,"taxation-beer-ctt-trends-2018.xlsx",sep=""), range = "a3:i59")
beer_2020<-read_excel(paste(source_data,"taxation-beer-ctt-trends-2020.xlsx",sep=""), range = "a3:i60")

colnames(beer_2018)<-c("country","currency","beer_excise_hl_nat","beer_excise_hl_usd",
                       "beer_production_hl","beer_lower_nat","beer_lower_usd","beer_low_alc_nat","beer_low_alc_usd")
beer_2018<-subset(beer_2018,select = -c(currency,beer_excise_hl_nat,beer_production_hl,beer_lower_nat,beer_lower_usd,beer_low_alc_nat))
beer_2018$year<-2018
colnames(beer_2020)<-c("country","currency","beer_excise_hl_nat","beer_excise_hl_usd",
                       "beer_production_hl","beer_lower_nat","beer_lower_usd","beer_low_alc_nat","beer_low_alc_usd")
beer_2020<-subset(beer_2020,select = -c(currency,beer_excise_hl_nat,beer_production_hl,beer_lower_nat,beer_lower_usd,beer_low_alc_nat))
beer_2020$year<-2020

beer<-rbind(beer_2018,beer_2020)
beer$country <- str_remove_all(beer$country, "[*]")
beer<-merge(beer,country_names,by=c("country"))

beer$beer_excise_hl_usd<-as.numeric(beer$beer_excise_hl_usd)
beer$beer_low_alc_usd<-as.numeric(beer$beer_low_alc_usd)

#Lower excise for small independent breweries
beer_2018<-read_excel(paste(source_data,"taxation-beer-ctt-trends-2018.xlsx",sep=""), range = "a3:g59")
beer_2020<-read_excel(paste(source_data,"taxation-beer-ctt-trends-2020.xlsx",sep=""), range = "a3:g60")

colnames(beer_2018)<-c("country","currency","beer_excise_hl_nat","beer_excise_hl_usd",
                       "beer_production_hl","beer_lower_nat","beer_lower_usd")
beer_2018<-subset(beer_2018,select = -c(currency,beer_excise_hl_nat,beer_excise_hl_usd,beer_lower_nat))
beer_2018$year<-2018


colnames(beer_2020)<-c("country","currency","beer_excise_hl_nat","beer_excise_hl_usd",
                       "beer_production_hl","beer_lower_nat","beer_lower_usd")
beer_2020<-subset(beer_2020,select = -c(currency,beer_excise_hl_nat,beer_excise_hl_usd,beer_lower_nat))
beer_2020$year<-2020


small_ind_beer<-rbind(beer_2018,beer_2020)
small_ind_beer<-small_ind_beer %>% fill(country)
#remove special characters and values
small_ind_beer$beer_lower_usd<-as.numeric(small_ind_beer$beer_lower_usd)
small_ind_beer$country <- str_remove_all(small_ind_beer$country, "[*]")
small_ind_beer<-subset(small_ind_beer,small_ind_beer$beer_production_hl!="Country note")

small_ind_beer$beer_production_hl<-if_else(small_ind_beer$country=="Hungary","< 200 000",small_ind_beer$beer_production_hl)
small_ind_beer$beer_production_hl<-if_else(small_ind_beer$country=="Slovenia","< 20 000",small_ind_beer$beer_production_hl)

small_ind_beer<-small_ind_beer%>%
  separate(beer_production_hl,c("one","two","three")," ")

small_ind_beer$beer_production_hl<-paste(small_ind_beer$two,small_ind_beer$three,sep="")
small_ind_beer<-merge(small_ind_beer,country_names,by=c("country"))

#Fix US value
small_ind_beer$beer_production_hl<-if_else(small_ind_beer$country=="United States","2347000",small_ind_beer$beer_production_hl)

small_ind_beer$beer_production_hl<-as.numeric(small_ind_beer$beer_production_hl)

#Drop unnecessary variables
small_ind_beer<-subset(small_ind_beer,select = -c(one,two,three))


print(small_ind_beer$beer_production_hl)
#Wine####
wine_2018<-read_excel(paste(source_data,"taxation-wine-ctt-trends-2018.xlsx",sep=""), range = "a4:j40")
wine_2020<-read_excel(paste(source_data,"taxation-wine-ctt-trends-2020.xlsx",sep=""), range = "a4:j41")

colnames(wine_2018)<-c("country","currency","still_wine_excise_hl_nat","still_wine_excise_hl_usd",
                       "still_wine_vat","sparkling_wine_excise_hl_nat","sparkling_wine_excise_hl_usd",
                       "sparkling_wine_vat","low_alc_excise_hl_nat","low_alc_excise_hl_usd")
wine_2018<-subset(wine_2018,select = -c(currency,still_wine_excise_hl_nat,still_wine_vat,sparkling_wine_excise_hl_nat,
                                        sparkling_wine_vat,low_alc_excise_hl_nat))
wine_2018$year<-2018

colnames(wine_2020)<-c("country","currency","still_wine_excise_hl_nat","still_wine_excise_hl_usd",
                       "still_wine_vat","sparkling_wine_excise_hl_nat","sparkling_wine_excise_hl_usd",
                       "sparkling_wine_vat","low_alc_excise_hl_nat","low_alc_excise_hl_usd")
wine_2020<-subset(wine_2020,select = -c(currency,still_wine_excise_hl_nat,still_wine_vat,sparkling_wine_excise_hl_nat,
                                        sparkling_wine_vat,low_alc_excise_hl_nat))
wine_2020$year<-2020

wine<-rbind(wine_2018,wine_2020)
wine$country <- str_remove_all(wine$country, "[*]")
wine<-merge(wine,country_names,by=c("country"))

wine$still_wine_excise_hl_usd<-as.numeric(wine$still_wine_excise_hl_usd)
wine$sparkling_wine_excise_hl_usd<-as.numeric(wine$sparkling_wine_excise_hl_usd)
wine$low_alc_excise_hl_usd<-as.numeric(wine$low_alc_excise_hl_usd)

#Alcohol####
alc_2018<-read_excel(paste(source_data,"taxation-alcoholic-beverages-ctt-trends-2018.xlsx",sep=""), range = "a4:f40")
alc_2020<-read_excel(paste(source_data,"taxation-alcoholic-beverages-ctt-trends-2020.xlsx",sep=""), range = "a4:f41")

colnames(alc_2018)<-c("country","currency","alc_excise_hl_nat","alc_excise_hl_usd",
                          "alc_vat","small_dist_rate")
alc_2018<-subset(alc_2018,select = -c(currency,alc_excise_hl_nat,alc_vat))
alc_2018$year<-2018

colnames(alc_2020)<-c("country","currency","alc_excise_hl_nat","alc_excise_hl_usd",
                      "alc_vat","small_dist_rate")
alc_2020<-subset(alc_2020,select = -c(currency,alc_excise_hl_nat,alc_vat))
alc_2020$year<-2020

alcohol<-rbind(alc_2018,alc_2020)
alcohol$country <- str_remove_all(alcohol$country, "[*]")
alcohol<-merge(alcohol,country_names,by=c("country"))

alcohol$alc_excise_hl_usd<-as.numeric(alcohol$alc_excise_hl_usd)
alcohol$small_dist_rate<-if_else(alcohol$small_dist_rate=="Yes",1,0)
#Tobacco####
tobacco_2018<-read_excel(paste(source_data,"taxation-tobacco-ctt-trends-2018.xlsx",sep=""), range = "a4:k40")
tobacco_2020<-read_excel(paste(source_data,"taxation-tobacco-ctt-trends-2020.xlsx",sep=""), range = "a4:k41")

colnames(tobacco_2018)<-c("country","currency","cigarette_excise_1k_nat","cigarette_excise_1k_usd","cigarette_excise_1k_pct_rsp",
                          "cigar_excise_1k_nat","cigar_excise_1k_usd","cigar_excise_1k_pct_rsp",
                          "roll_tob_excise_1kg_nat","roll_tob_excise_1kg_usd","roll_tob_excise_1kg_pct_rsp")
tobacco_2018<-subset(tobacco_2018,select = -c(currency,cigarette_excise_1k_nat,cigar_excise_1k_nat,roll_tob_excise_1kg_nat))
tobacco_2018$year<-2018

colnames(tobacco_2020)<-c("country","currency","cigarette_excise_1k_nat","cigarette_excise_1k_usd","cigarette_excise_1k_pct_rsp",
                          "cigar_excise_1k_nat","cigar_excise_1k_usd","cigar_excise_1k_pct_rsp",
                          "roll_tob_excise_1kg_nat","roll_tob_excise_1kg_usd","roll_tob_excise_1kg_pct_rsp")
tobacco_2020<-subset(tobacco_2020,select = -c(currency,cigarette_excise_1k_nat,cigar_excise_1k_nat,roll_tob_excise_1kg_nat))
tobacco_2020$year<-2020

tobacco<-rbind(tobacco_2018,tobacco_2020)
tobacco$country <- str_remove_all(tobacco$country, "[*]")
tobacco<-merge(tobacco,country_names,by=c("country"))

tobacco$cigarette_excise_1k_usd<-as.numeric(tobacco$cigarette_excise_1k_usd)
tobacco$cigarette_excise_1k_pct_rsp<-as.numeric(tobacco$cigarette_excise_1k_pct_rsp)
tobacco$cigar_excise_1k_usd<-as.numeric(tobacco$cigar_excise_1k_usd)
tobacco$cigar_excise_1k_pct_rsp<-as.numeric(tobacco$cigar_excise_1k_pct_rsp)
tobacco$roll_tob_excise_1kg_usd<-as.numeric(tobacco$roll_tob_excise_1kg_usd)
tobacco$roll_tob_excise_1kg_pct_rsp<-as.numeric(tobacco$roll_tob_excise_1kg_pct_rsp)

#Cigarette Pack####
cigarettes_2014<-read_excel(paste(source_data,"tax-burden-cigarettes-ctt-trends-2017.xlsx",sep=""),sheet="2014", range = "a3:i38")
cigarettes_2016<-read_excel(paste(source_data,"tax-burden-cigarettes-ctt-trends-2017.xlsx",sep=""),sheet="2016", range = "a3:i39")

colnames(cigarettes_2014)<-c("country","cig_pack_ex_tax_price_usd","cig_pack_specific_pct_rsp","cig_pack_ad_val_pct_rsp","cig_pack_sales_pct_rsp",
                          "cig_pack_total_tax_pct_rsp","currency","cig_pack_price_nat",
                          "cig_pack_price_usd")

cigarettes_2014<-subset(cigarettes_2014,select=-c(currency,cig_pack_price_nat))
cigarettes_2014$year<-2014
colnames(cigarettes_2016)<-c("country","cig_pack_ex_tax_price_usd","cig_pack_specific_pct_rsp","cig_pack_ad_val_pct_rsp","cig_pack_sales_pct_rsp",
                             "cig_pack_total_tax_pct_rsp","currency","cig_pack_price_nat",
                             "cig_pack_price_usd")
cigarettes_2016<-subset(cigarettes_2016,select=-c(currency,cig_pack_price_nat))
cigarettes_2016$year<-2016
cigarettes<-rbind(cigarettes_2014,cigarettes_2016)
cigarettes$country <- str_remove_all(cigarettes$country, "[*]")
cigarettes<-merge(cigarettes,country_names,by=c("country"))

#Unleaded Gas####
unleaded_gas_2017<-read_excel(paste(source_data,"taxation-premium-unleaded-gasoline-ctt-trends-2017.xlsx",sep=""), range = "a3:k39")
unleaded_gas_2019<-read_excel(paste(source_data,"taxation-premium-unleaded-gasoline-ctt-trends-2019.xlsx",sep=""), range = "a3:k40")

colnames(unleaded_gas_2017)<-c("country","currency","unleaded_ex_tax_price_nat","unleaded_ex_tax_price_usd","unleaded_excise_nat",
                               "unleaded_excise_usd","unleaded_vat_rate","unleaded_vat_usd",
                               "unleaded_total_tax_usd","unleaded_total_price_usd","unleaded_total_tax_pct_price")

unleaded_gas_2017<-subset(unleaded_gas_2017,select=c(country,unleaded_excise_usd,unleaded_total_price_usd,unleaded_total_tax_pct_price))
unleaded_gas_2017$year<-2017
unleaded_gas_2017$unleaded_excise_pct_price<-(unleaded_gas_2017$unleaded_excise_usd/unleaded_gas_2017$unleaded_total_price_usd)*100
unleaded_gas_2017<-subset(unleaded_gas_2017,select=-c(unleaded_excise_usd,unleaded_total_price_usd))


colnames(unleaded_gas_2019)<-c("country","currency","unleaded_ex_tax_price_nat","unleaded_ex_tax_price_usd","unleaded_excise_nat","unleaded_vat_rate"
                               ,"unleaded_vat_nat","unleaded_total_tax_nat","unleaded_total_price_nat",
                               "unleaded_total_price_usd","unleaded_total_tax_pct_price")

unleaded_gas_2019<-subset(unleaded_gas_2019,select=c(country,unleaded_excise_nat,unleaded_total_price_nat,unleaded_total_tax_pct_price))
unleaded_gas_2019$year<-2019
unleaded_gas_2019$unleaded_excise_pct_price<-(unleaded_gas_2019$unleaded_excise_nat/unleaded_gas_2019$unleaded_total_price_nat)*100
unleaded_gas_2019<-subset(unleaded_gas_2019,select=-c(unleaded_excise_nat,unleaded_total_price_nat))

unleaded_gas<-rbind(unleaded_gas_2017,unleaded_gas_2019)
unleaded_gas$country <- str_remove_all(unleaded_gas$country, "[*]")
unleaded_gas<-merge(unleaded_gas,country_names,by=c("country"))

#Diesel####
diesel_2017<-read_excel(paste(source_data,"taxation-automotive-diesel-ctt-trends-2017.xlsx",sep=""), range = "a3:k39")
diesel_2019<-read_excel(paste(source_data,"taxation-automotive-diesel-ctt-trends-2019.xlsx",sep=""), range = "a3:k40")

colnames(diesel_2017)<-c("country","currency","diesel_ex_tax_price_nat","diesel_ex_tax_price_usd","diesel_excise_nat",
                               "diesel_excise_usd","diesel_vat_rate","diesel_vat_usd",
                               "diesel_total_tax_usd","diesel_total_price_usd","diesel_total_tax_pct_price")

diesel_2017<-subset(diesel_2017,select=c(country,diesel_excise_usd,diesel_total_price_usd,diesel_total_tax_pct_price))
diesel_2017$year<-2017
diesel_2017$diesel_excise_pct_price<-(diesel_2017$diesel_excise_usd/diesel_2017$diesel_total_price_usd)*100
diesel_2017<-subset(diesel_2017,select=-c(diesel_excise_usd,diesel_total_price_usd))


colnames(diesel_2019)<-c("country","currency","diesel_ex_tax_price_nat","diesel_ex_tax_price_usd","diesel_excise_nat","diesel_vat_rate"
                               ,"diesel_vat_nat","diesel_total_tax_nat","diesel_total_price_nat",
                               "diesel_total_price_usd","diesel_total_tax_pct_price")

diesel_2019<-subset(diesel_2019,select=c(country,diesel_excise_nat,diesel_total_price_nat,diesel_total_tax_pct_price))
diesel_2019$year<-2019
diesel_2019$diesel_excise_pct_price<-(diesel_2019$diesel_excise_nat/diesel_2019$diesel_total_price_nat)*100
diesel_2019<-subset(diesel_2019,select=-c(diesel_excise_nat,diesel_total_price_nat))

diesel<-rbind(diesel_2017,diesel_2019)
diesel$country <- str_remove_all(diesel$country, "[*]")
diesel<-merge(diesel,country_names,by=c("country"))
#Household fuel####
household_fuel_2017<-read_excel(paste(source_data,"taxation-households-light-fuel-oil-ctt-trends-2017.xlsx",sep=""), range = "a3:k39")
household_fuel_2019<-read_excel(paste(source_data,"taxation-households-light-fuel-oil-ctt-trends-2019.xlsx",sep=""), range = "a3:k40")

colnames(household_fuel_2017)<-c("country","currency","household_fuel_ex_tax_price_nat","household_fuel_ex_tax_price_usd","household_fuel_excise_nat",
                         "household_fuel_excise_usd","household_fuel_vat_rate","household_fuel_vat_usd",
                         "household_fuel_total_tax_usd","household_fuel_total_price_usd","household_fuel_total_tax_pct_price")

household_fuel_2017<-subset(household_fuel_2017,select=c(country,household_fuel_excise_usd,household_fuel_total_price_usd,household_fuel_total_tax_pct_price))
household_fuel_2017$year<-2017
household_fuel_2017$household_fuel_excise_pct_price<-(household_fuel_2017$household_fuel_excise_usd/household_fuel_2017$household_fuel_total_price_usd)*100
household_fuel_2017<-subset(household_fuel_2017,select=-c(household_fuel_excise_usd,household_fuel_total_price_usd))


colnames(household_fuel_2019)<-c("country","currency","household_fuel_ex_tax_price_nat","household_fuel_ex_tax_price_usd","household_fuel_excise_nat","household_fuel_vat_rate"
                         ,"household_fuel_vat_nat","household_fuel_total_tax_nat","household_fuel_total_price_nat",
                         "household_fuel_total_price_usd","household_fuel_total_tax_pct_price")

household_fuel_2019<-subset(household_fuel_2019,select=c(country,household_fuel_excise_nat,household_fuel_total_price_nat,household_fuel_total_tax_pct_price))
household_fuel_2019$year<-2019
household_fuel_2019$household_fuel_excise_pct_price<-(household_fuel_2019$household_fuel_excise_nat/household_fuel_2019$household_fuel_total_price_nat)*100
household_fuel_2019<-subset(household_fuel_2019,select=-c(household_fuel_excise_nat,household_fuel_total_price_nat))

household_fuel<-rbind(household_fuel_2017,household_fuel_2019)
household_fuel$country <- str_remove_all(household_fuel$country, "[*]")
household_fuel<-merge(household_fuel,country_names,by=c("country"))
#Combine####
excise<-merge(beer,wine,by=c("iso_2","iso_3","country","year"), all=T)
excise<-merge(excise,alcohol,by=c("iso_2","iso_3","country","year"), all=T)
excise<-merge(excise,tobacco,by=c("iso_2","iso_3","country","year"), all=T)
excise<-merge(excise,cigarettes,by=c("iso_2","iso_3","country","year"), all=T)
excise<-merge(excise,unleaded_gas,by=c("iso_2","iso_3","country","year"), all=T)
excise<-merge(excise,diesel,by=c("iso_2","iso_3","country","year"), all=T)
excise<-merge(excise,household_fuel,by=c("iso_2","iso_3","country","year"), all=T)

write.csv(excise,paste(excises,"excise_taxes.csv",sep=""),row.names = F)
