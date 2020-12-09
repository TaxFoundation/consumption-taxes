#Alcohol#####

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

#Other####


#Tobacco####

#Fuel####

#Unleaded Gas####

#Diesel####

#Light fuel####