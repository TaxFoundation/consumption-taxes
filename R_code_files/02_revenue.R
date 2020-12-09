#Reading in and cleaning OECD's Revenue Statistics - OECD countries: Comparative tables####
#https://stats.oecd.org/Index.aspx?DataSetCode=REV 

#dataset_list <- get_datasets()
#search_dataset("Revenue", data= dataset_list)
dataset <- ("REV")

#dstruc <- get_data_structure(dataset)
#str(dstruc, max.level = 1)
#dstruc$VAR
#dstruc$TAX
#dstruc$GOV
#dstruc$YEA
taxes<-c("5000","5111","5112","5121")

revenue <- get_dataset(dataset, filter= list(c("NES"),c(taxes),c("TAXGDP","TAXPER"),c(oecd_countries)),start_time = 1975)

#Drop redundant columns
revenue <- subset(revenue, select=-c(GOV, TIME_FORMAT,POWERCODE,UNIT))

#Rename columns
colnames(revenue)[colnames(revenue)=="COU"] <- "iso_3"
colnames(revenue)[colnames(revenue)=="TAX"] <- "tax"
colnames(revenue)[colnames(revenue)=="VAR"] <- "variable"
colnames(revenue)[colnames(revenue)=="obsTime"] <- "year"
colnames(revenue)[colnames(revenue)=="obsValue"] <- "value"

#Add country names and continents to data, and add variable signaling OECD countries####
revenue <- merge(revenue, country_names, by='iso_3')

#Fix country name that was read in incorrectly
revenue$country <- as.character(revenue$country)

#Rename Tax Codes
revenue$tax<-if_else(revenue$tax=="5000","5000 Consumption",revenue$tax)
revenue$tax<-if_else(revenue$tax=="5111","5111 VAT",revenue$tax)
revenue$tax<-if_else(revenue$tax=="5112","5112 Sales",revenue$tax)
revenue$tax<-if_else(revenue$tax=="5121","5121 Excise",revenue$tax)

#Rename Variable Codes
revenue$variable<-if_else(revenue$variable=="TAXGDP","% of GDP",revenue$variable)
revenue$variable<-if_else(revenue$variable=="TAXPER","% of Total Revenue",revenue$variable)

write.csv(revenue, paste(revenues,"revenue_preliminary.csv",sep=""), row.names = F)

#Fix countries for which 2019 data is not available (unless otherwise noted, 2018 data is used for these cases)####

#Australia: 2019 data not available -> use 2018 data
missing_australia <- revenue
missing_australia <- subset(missing_australia, subset = iso_3 == "AUS" & year == "2018")
missing_australia[missing_australia$year == 2018, "year"] <- 2019

#Greece: 2019 data not available for VAT and Excise -> use 2018 data for VAT and Excise
missing_greece <- revenue
missing_greece_vat <- subset(missing_greece, subset = iso_3 == "GRC" & year == "2018" & tax == "5111 VAT")
missing_greece_excise <- subset(missing_greece, subset = iso_3 == "GRC" & year == "2018" & tax == "5121 Excise")

missing_greece_vat[missing_greece_vat$year == 2018, "year"] <- 2019
missing_greece_excise[missing_greece_excise$year == 2018, "year"] <- 2019

#Japan: 2017, 2018, and 2019 data not available for Sales-> use 2016 data for Sales; 2019 % of revenue not available for excise, VAT, and consumption -> Use 2018
missing_japan <- revenue
missing_japan_sales <- subset(missing_japan, subset = iso_3 == "JPN" & year == "2016" & tax == "5112 Sales")
missing_japan_sales_2017<-missing_japan_sales
missing_japan_sales_2018<-missing_japan_sales
missing_japan_sales_2019<-missing_japan_sales

missing_japan_sales_2017[missing_japan_sales$year == 2016, "year"] <- 2017
missing_japan_sales_2018[missing_japan_sales$year == 2016, "year"] <- 2018
missing_japan_sales_2019[missing_japan_sales$year == 2016, "year"] <- 2019

missing_japan_2019 <- subset(missing_japan, subset = iso_3 == "JPN" & year == "2018" & variable == "% of Total Revenue")
missing_japan_2019[missing_japan_2019$year == 2018, "year"] <- 2019



#Mexico: 2019 data not available -> use 2018 data
missing_mexico <- revenue
missing_mexico <- subset(missing_mexico, subset = iso_3 == "MEX" & year == "2018")
missing_mexico[missing_mexico$year == 2018, "year"] <- 2019

#Slovakia: 2018 data not available for Sales-> use 2017 data for Sales
missing_slovakia <- revenue
missing_slovakia <- subset(missing_slovakia, subset = iso_3 == "SVK" & year == "2017" & tax == "5112 Sales")
missing_slovakia[missing_slovakia$year == 2017, "year"] <- 2018


#Combine data
revenue <- rbind(revenue, missing_australia,missing_greece_vat,missing_greece_excise,
              missing_japan_sales_2017,missing_japan_sales_2018,missing_japan_sales_2019,
              missing_japan_2019,missing_mexico,missing_slovakia)

#Sort dataset
revenue <- revenue[order(revenue$country, revenue$tax, revenue$year),]

write.csv(revenue, paste(revenues,"revenue_fixed.csv",sep=""), row.names = F)

#Spread into wide dataset####
#Percent of total tax revenue
revenue_per_tax<-subset(revenue,revenue$variable=="% of Total Revenue")


revenue_per_tax_wide<-revenue_per_tax%>%
  spread(tax,value)
names(revenue_per_tax_wide)

colnames(revenue_per_tax_wide)<-c("iso_3" ,"variable" ,"year",
                                  "country"  ,"iso_2","5000_consumption_pct_total",
                                  "5111_vat_pct_total","5112_sales_pct_total","5121_excise_pct_total")

revenue_per_tax_wide<-subset(revenue_per_tax_wide,select=-c(variable))

#Percent of GDP
revenue_per_gdp<-subset(revenue,revenue$variable=="% of GDP")


revenue_per_gdp_wide<-revenue_per_gdp%>%
  spread(tax,value)
names(revenue_per_gdp_wide)

colnames(revenue_per_gdp_wide)<-c("iso_3" ,"variable" ,"year",
                                  "country"  ,"iso_2","5000_consumption_pct_gdp",
                                  "5111_vat_pct_gdp","5112_sales_pct_gdp","5121_excise_pct_gdp")

revenue_per_gdp_wide<-subset(revenue_per_gdp_wide,select=-c(variable))

#Merge
revenue_wide<-merge(revenue_per_tax_wide,revenue_per_gdp_wide,by=c("iso_3","iso_2","country","year"))
write.csv(revenue_wide,paste(revenues,"revenue_final.csv",sep=""),row.names = F)

#Means####
magic_for(silent = TRUE)
years<-print(unique(revenue$year))

#Average pct of total revenues
for(year in years){
  consumption_pct_rev<-mean(revenue$value[revenue$year==year&
                                         revenue$tax=="5000 Consumption"&
                                         revenue$variable=="% of Total Revenue"])
  vat_pct_rev<-mean(revenue$value[revenue$year==year&
                                         revenue$tax=="5111 VAT"&
                                         revenue$variable=="% of Total Revenue"])
  sales_pct_rev<-mean(revenue$value[revenue$year==year&
                                 revenue$tax=="5112 Sales"&
                                 revenue$variable=="% of Total Revenue"])
  excise_pct_rev<-mean(revenue$value[revenue$year==year&
                                   revenue$tax=="5121 Excise"&
                                   revenue$variable=="% of Total Revenue"])

  put(consumption_pct_rev,vat_pct_rev,sales_pct_rev,excise_pct_rev)
}
pct_rev<-magic_result_as_dataframe() 

#Add number of countries by year
revenue_wide$key<-if_else(revenue_wide$country!="NA",1,0)
count<-revenue_wide%>%
  count(key,year)

count<-subset(count,count$key!="NA")

pct_rev<-merge(pct_rev,count,by="year")
pct_rev<-pct_rev[-c(6)]
colnames(pct_rev)[colnames(pct_rev)=="n"] <- "pct_rev_observations"

write.csv(pct_rev, paste(revenues,"consumption_pct_rev.csv",sep=""), row.names = F)

#Average pct of GDP
for(year in years){
  consumption_pct_gdp<-mean(revenue$value[revenue$year==year&
                                         revenue$tax=="5000 Consumption"&
                                         revenue$variable=="% of GDP"])
  vat_pct_gdp<-mean(revenue$value[revenue$year==year&
                                 revenue$tax=="5111 VAT"&
                                 revenue$variable=="% of GDP"])
  sales_pct_gdp<-mean(revenue$value[revenue$year==year&
                                   revenue$tax=="5112 Sales"&
                                   revenue$variable=="% of GDP"])
  excise_pct_gdp<-mean(revenue$value[revenue$year==year&
                                    revenue$tax=="5121 Excise"&
                                    revenue$variable=="% of GDP"])
  
  put(consumption_pct_gdp,vat_pct_gdp,sales_pct_gdp,excise_pct_gdp)
}
pct_gdp<-magic_result_as_dataframe() 

#Add number of countries by year
pct_gdp<-merge(pct_gdp,count,by="year")
pct_gdp<-pct_gdp[-c(6)]
colnames(pct_gdp)[colnames(pct_gdp)=="n"] <- "pct_gdp_observations"

write.csv(pct_gdp, paste(revenues,"consumption_pct_gdp.csv",sep=""), row.names = F)
