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

data <- get_dataset(dataset, filter= list(c("NES"),c(taxes),c("TAXGDP","TAXPER"),c(oecd_countries)),start_time = 2000)

#Drop redundant columns
data <- subset(data, select=-c(GOV, TIME_FORMAT,POWERCODE,UNIT))

#Rename columns
colnames(data)[colnames(data)=="COU"] <- "iso_3"
colnames(data)[colnames(data)=="TAX"] <- "tax"
colnames(data)[colnames(data)=="VAR"] <- "variable"
colnames(data)[colnames(data)=="obsTime"] <- "year"
colnames(data)[colnames(data)=="obsValue"] <- "value"

#Add country names and continents to data, and add variable signaling OECD countries####
data <- merge(data, country_names, by='iso_3')

#Adjust the order of the columns
data <- data[c("iso_2", "iso_3", "country", "continent", "year", "tax","variable", "value")]

#Fix country name that was read in incorrectly
data$country <- as.character(data$country)

#Rename Tax Codes
data$tax<-if_else(data$tax=="5000","5000 Consumption",data$tax)
data$tax<-if_else(data$tax=="5111","5111 VAT",data$tax)
data$tax<-if_else(data$tax=="5112","5112 Sales",data$tax)
data$tax<-if_else(data$tax=="5121","5121 Excise",data$tax)

#Rename Variable Codes
data$variable<-if_else(data$variable=="TAXGDP","% of GDP",data$variable)
data$variable<-if_else(data$variable=="TAXPER","% of Total Revenue",data$variable)

write.csv(data, paste(intermediate_outputs,"revenue_preliminary.csv",sep=""), row.names = F)

#Fix countries for which 2019 data is not available (unless otherwise noted, 2018 data is used for these cases)####

#Australia: 2019 data not available -> use 2018 data
missing_australia <- data
missing_australia <- subset(missing_australia, subset = iso_3 == "AUS" & year == "2018")
missing_australia[missing_australia$year == 2018, "year"] <- 2019

#Greece: 2019 data not available for VAT and Excise -> use 2018 data for VAT and Excise
missing_greece <- data
missing_greece_vat <- subset(missing_greece, subset = iso_3 == "GRC" & year == "2018" & tax == "5111 VAT")
missing_greece_excise <- subset(missing_greece, subset = iso_3 == "GRC" & year == "2018" & tax == "5121 Excise")

missing_greece_vat[missing_greece_vat$year == 2018, "year"] <- 2019
missing_greece_excise[missing_greece_excise$year == 2018, "year"] <- 2019

#Japan: 2017, 2018, and 2019 data not available for Sales-> use 2016 data for Sales; 2019 % of revenue not available for excise, VAT, and consumption -> Use 2018
missing_japan <- data
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
missing_mexico <- data
missing_mexico <- subset(missing_mexico, subset = iso_3 == "MEX" & year == "2018")
missing_mexico[missing_mexico$year == 2018, "year"] <- 2019

#Slovakia: 2018 data not available for Sales-> use 2017 data for Sales
missing_slovakia <- data
missing_slovakia <- subset(missing_slovakia, subset = iso_3 == "SVK" & year == "2017" & tax == "5112 Sales")
missing_slovakia[missing_slovakia$year == 2017, "year"] <- 2018


#Combine data
data <- rbind(data, missing_australia,missing_greece_vat,missing_greece_excise,
              missing_japan_sales_2017,missing_japan_sales_2018,missing_japan_sales_2019,
              missing_japan_2019,missing_mexico,missing_slovakia)

#Sort dataset
data <- data[order(data$country, data$tax, data$year),]

write.csv(data, paste(intermediate_outputs,"revenue_fixed.csv",sep=""), row.names = F)


#Means for 2000-2019####
magic_for(silent = TRUE)
years<-print(unique(data$year))

for(year in years){
  consumption_pct_rev<-mean(data$value[data$year==year&
                                         data$tax=="5000 Consumption"&
                                         data$variable=="% of Total Revenue"])
  vat_pct_rev<-mean(data$value[data$year==year&
                                         data$tax=="5111 VAT"&
                                         data$variable=="% of Total Revenue"])
  sales_pct_rev<-mean(data$value[data$year==year&
                                 data$tax=="5112 Sales"&
                                 data$variable=="% of Total Revenue"])
  excise_pct_rev<-mean(data$value[data$year==year&
                                   data$tax=="5121 Excise"&
                                   data$variable=="% of Total Revenue"])

  put(consumption_pct_rev,vat_pct_rev,sales_pct_rev,excise_pct_rev)
}
pct_rev<-magic_result_as_dataframe() 

write.csv(pct_rev, paste(intermediate_outputs,"consumption_pct_rev.csv",sep=""), row.names = F)


for(year in years){
  consumption_pct_gdp<-mean(data$value[data$year==year&
                                         data$tax=="5000 Consumption"&
                                         data$variable=="% of GDP"])
  vat_pct_gdp<-mean(data$value[data$year==year&
                                 data$tax=="5111 VAT"&
                                 data$variable=="% of GDP"])
  sales_pct_gdp<-mean(data$value[data$year==year&
                                   data$tax=="5112 Sales"&
                                   data$variable=="% of GDP"])
  excise_pct_gdp<-mean(data$value[data$year==year&
                                    data$tax=="5121 Excise"&
                                    data$variable=="% of GDP"])
  
  put(consumption_pct_gdp,vat_pct_gdp,sales_pct_gdp,excise_pct_gdp)
}
pct_gdp<-magic_result_as_dataframe() 

write.csv(pct_gdp, paste(intermediate_outputs,"consumption_pct_gdp.csv",sep=""), row.names = F)
