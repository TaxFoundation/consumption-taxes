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

write.csv(vat_base,paste(base,"vat_base.csv",sep=""), row.names = FALSE)

#VRR Calculations according to table note at https://www.oecd-ilibrary.org/taxation/consumption-tax-trends-2020_152def2d-en Annex Table 2.A.7.
#VAT revenue####
dataset <- ("REV")
dstruc <- get_data_structure(dataset)
str(dstruc, max.level = 1)
dstruc$VAR
#dstruc$TAX
dstruc$GOV
#dstruc$YEA
taxes<-c("5111")
vat_revenues <- get_dataset(dataset, filter= list(c("NES"),c(taxes),c("TAXNAT"),c(oecd_countries)),start_time = 1976)

#Drop redundant columns
vat_revenues <- subset(vat_revenues, select=-c(GOV, TAX, VAR, TIME_FORMAT, UNIT, POWERCODE))
colnames(vat_revenues)<-c("iso_3","year","vat_revenue")

#Final Consumption Expenditure####
dataset <- ("SNA_Table1")
dstruc <- get_data_structure(dataset)
str(dstruc, max.level = 1)
dstruc$CL_SNA_TABLE1_LOCATION
dstruc$CL_SNA_TABLE1_TRANSACT
dstruc$CL_SNA_TABLE1_MEASURE
dstruc$CL_SNA_TABLE1_TIME
dstruc$CL_SNA_TABLE1_OBS_STATUS
dstruc$CL_SNA_TABLE1_UNIT
dstruc$CL_SNA_TABLE1_POWERCODE
#dstruc$YEA
consumption <- get_dataset(dataset,filter=list(c(oecd_countries),c("P3"),c("C")),start_time=1976)

#Drop redundant columns
consumption <- subset(consumption, select=-c(TRANSACT, MEASURE, TIME_FORMAT, UNIT, POWERCODE, OBS_STATUS))
colnames(consumption)<-c("iso_3","year","consumption")
