#Vat Base####

#VAT Base 1976-1988####
#Source data: https://doi.org/10.1787/888933890122
vat_base_1976_2016 <- read_excel(paste(source_data,"vat-revenue-ratio-1976-2016.xlsx",sep=""), 
                       sheet = "Sheet1", range = "A7:U43")

#Keep 1976, 1980, 1984, 1988
vat_base_1976_1988 <- vat_base_1976_2016[-c(2,7:21)]

vat_base_1976_1988 <- melt(vat_base_1976_1988, id.vars=c("Country"))
colnames(vat_base_1976_1988) <- c("country","year","vat_revenue_ratio")

#Change NAs to zeros and delete those rows
vat_base_1976_1988$country[is.na(vat_base_1976_1988$country)] <- 0
vat_base_1976_1988 <- subset(vat_base_1976_1988,country!="0")

#VAT Base 1992-2018
#Source data: https://www.oecd-ilibrary.org/taxation/consumption-tax-trends-2020_152def2d-en Annex Table 2.A.7.

vat_base_1992_2018 <- read_excel(paste(source_data,"vat-revenue-ratio-1992-2018.xlsx",sep=""), 
                                 sheet = "Sheet1", range = "A1:S37")

#Drop standard rates variable
vat_base_1992_2018 <- vat_base_1992_2018[-c(2)]

vat_base_1992_2018 <- melt(vat_base_1992_2018, id.vars=c("Country"))
colnames(vat_base_1992_2018) <- c("country","year","vat_revenue_ratio")

#Combine for 1976-2018 data
vat_base<-rbind(vat_base_1976_1988,vat_base_1992_2018)
vat_base<-merge(vat_base,country_names,by="country")

write.csv(vat_base,paste(base,"vat_base.csv",sep=""), row.names = FALSE)

#VRR Calculations#### 
#According to table note at https://www.oecd-ilibrary.org/taxation/consumption-tax-trends-2020_152def2d-en Annex Table 2.A.7.
#VAT revenue####
dataset <- ("REV")
dstruc <- get_data_structure(dataset)
#str(dstruc, max.level = 1)
#dstruc$VAR
#dstruc$TAX
#dstruc$GOV
#dstruc$UNIT
taxes<-c("5111")
#Federal VAT revenue only for Canada
vat_revenues_can <- get_dataset(dataset, filter= list(c("FED"),c(taxes),c("TAXNAT"),c("CAN")),start_time = 1976)

#Total VAT revenue for other OECD countries
vat_revenues_other <- get_dataset(dataset, filter= list(c("NES"),c(taxes),c("TAXNAT"),c(oecd_countries)),start_time = 1976)
#Drop Canada
vat_revenues_other <- subset(vat_revenues_other,vat_revenues_other$COU!="CAN")

#Combine Canada and Other OECD Countries
vat_revenues<-rbind(vat_revenues_can,vat_revenues_other)

#Fix columns and names
vat_revenues <- subset(vat_revenues, select=-c(GOV, TAX, VAR, TIME_FORMAT, UNIT, POWERCODE))
colnames(vat_revenues)<-c("iso_3","year","vat_revenue")

#Convert revenues to millions
vat_revenues$vat_revenue<-vat_revenues$vat_revenue*1000
vat_revenues<-merge(vat_revenues,country_names,by="iso_3")

#Final Consumption Expenditure####
dataset <- ("SNA_Table1")
#dstruc <- get_data_structure(dataset)
#str(dstruc, max.level = 1)
#dstruc$CL_SNA_TABLE1_LOCATION
#dstruc$CL_SNA_TABLE1_TRANSACT
#dstruc$CL_SNA_TABLE1_MEASURE
#dstruc$CL_SNA_TABLE1_TIME
#dstruc$CL_SNA_TABLE1_OBS_STATUS
#dstruc$CL_SNA_TABLE1_UNIT
#dstruc$CL_SNA_TABLE1_POWERCODE
#dstruc$YEA
consumption <- get_dataset(dataset,filter=list(c(oecd_countries),c("P3"),c("C")),start_time=1976)

#Fix columns and names
consumption <- subset(consumption, select=-c(TRANSACT, MEASURE, TIME_FORMAT, UNIT, POWERCODE, OBS_STATUS))
colnames(consumption)<-c("iso_3","year","consumption")
consumption<-merge(consumption,country_names,by="iso_3")

#Standard VAT Rate####
vat_rates <- read.csv(paste(rates,"standard_vat_rates_1975_2020.csv",sep=""))
vat_rates<-merge(vat_rates,country_names,by="country")

#Fix Japan VAT Rate for 2014
vat_rates$rate<-as.numeric(vat_rates$rate)
vat_rates$rate<-if_else(vat_rates$country=="Japan"&vat_rates$year==2014,7.25,vat_rates$rate)

#Combine variables####
vat_revenue_ratio<-merge(vat_rates,vat_revenues,by=c("iso_2","iso_3","country","year"),all=T)
vat_revenue_ratio<-merge(vat_revenue_ratio,consumption,by=c("iso_2","iso_3","country","year"),all=T)

#Calculate VAT Revenue Ratio####
vat_revenue_ratio$vrr<-vat_revenue_ratio$vat_revenue/((vat_revenue_ratio$consumption-vat_revenue_ratio$vat_revenue)*(vat_revenue_ratio$rate/100))

#Remove Rows wher VRR==NA
vat_revenue_ratio<-subset(vat_revenue_ratio,vat_revenue_ratio$vrr!="NA")

write.csv(vat_revenue_ratio,paste(base,"vat_revenue_ratio_1985_2019.csv",sep=""), row.names = FALSE)

#Compare data
vrr_compare<-merge(vat_revenue_ratio,vat_base,by=c("iso_2","iso_3","country","year"))
vrr_compare$difference<-vrr_compare$vat_revenue_ratio-vrr_compare$vrr

print(mean(vrr_compare$difference))
#mean difference between OECD calculation and Tax Foundation calculation is -0.0002711146; the statistics are generally comparable
