#VAT Thresholds####
#Source: https://www.oecd.org/tax/consumption/vat-gst-annual-turnover-concessions-ctt-trends.xlsx
vat_thresholds_2007 <- read_excel(paste(source_data,"vat-gst-annual-turnover-concessions-ctt-trends.xlsx",sep=""), sheet = "2007", range = "a6:e35")
vat_thresholds_2010 <- read_excel(paste(source_data,"vat-gst-annual-turnover-concessions-ctt-trends.xlsx",sep=""), sheet = "2010", range = "a4:d36")
vat_thresholds_2011 <- read_excel(paste(source_data,"vat-gst-annual-turnover-concessions-ctt-trends.xlsx",sep=""), sheet = "2011", range = "a4:d37")
vat_thresholds_2012 <- read_excel(paste(source_data,"vat-gst-annual-turnover-concessions-ctt-trends.xlsx",sep=""), sheet = "2012", range = "a4:d37")
vat_thresholds_2013 <- read_excel(paste(source_data,"vat-gst-annual-turnover-concessions-ctt-trends.xlsx",sep=""), sheet = "2013", range = "a4:d37")
vat_thresholds_2014 <- read_excel(paste(source_data,"vat-gst-annual-turnover-concessions-ctt-trends.xlsx",sep=""), sheet = "2014", range = "a4:d37")
vat_thresholds_2016 <- read_excel(paste(source_data,"vat-gst-annual-turnover-concessions-ctt-trends.xlsx",sep=""), sheet = "2016", range = "a4:e41")
vat_thresholds_2018 <- read_excel(paste(source_data,"vat-gst-annual-turnover-concessions-ctt-trends.xlsx",sep=""), sheet = "2018", range = "A4:e42")
vat_thresholds_2020 <- read_excel(paste(source_data,"vat-gst-annual-turnover-concessions-ctt-trends.xlsx",sep=""), sheet = "2020", range = "A4:e43")

#2007
vat_thresholds_2007 <- vat_thresholds_2007[-c(2:4)]
colnames(vat_thresholds_2007)<-c("country","threshold")
vat_thresholds_2007$year<-"2007"

#2010
vat_thresholds_2010 <- vat_thresholds_2010[-c(2:3)]
colnames(vat_thresholds_2010)<-c("country","threshold")
vat_thresholds_2010$country <- str_remove_all(vat_thresholds_2010$country, "[*]")
vat_thresholds_2010$year<-"2010"

#2011
vat_thresholds_2011 <- vat_thresholds_2011[-c(2:3)]
colnames(vat_thresholds_2011)<-c("country","threshold")
vat_thresholds_2011$country <- str_remove_all(vat_thresholds_2011$country, "[*]")
vat_thresholds_2011$year<-"2011"

#2012
vat_thresholds_2012 <- vat_thresholds_2012[-c(2:3)]
colnames(vat_thresholds_2012)<-c("country","threshold")
vat_thresholds_2012$country <- str_remove_all(vat_thresholds_2012$country, "[*]")
vat_thresholds_2012$year<-"2012"

#2013
vat_thresholds_2013 <- vat_thresholds_2013[-c(2:3)]
colnames(vat_thresholds_2013)<-c("country","threshold")
vat_thresholds_2013$country <- str_remove_all(vat_thresholds_2013$country, "[*]")
vat_thresholds_2013$year<-"2013"

#2014
vat_thresholds_2014 <- vat_thresholds_2014[-c(2:3)]
colnames(vat_thresholds_2014)<-c("country","threshold")
vat_thresholds_2014$country <- str_remove_all(vat_thresholds_2014$country, "[*]")
vat_thresholds_2014$year <- "2014"

#2016
vat_thresholds_2016 <- vat_thresholds_2016[-c(2:4)]
colnames(vat_thresholds_2016) <- c("country","threshold")
vat_thresholds_2016$country <- str_remove_all(vat_thresholds_2016$country, "[(f)*]")
vat_thresholds_2016$year <- "2016"

#2018
vat_thresholds_2018 <- vat_thresholds_2018[-c(2:4)]
colnames(vat_thresholds_2018) <- c("country", "threshold")
vat_thresholds_2018$country <- str_remove_all(vat_thresholds_2018$country, "[6*]")
vat_thresholds_2018$year <- "2018"

#2020
vat_thresholds_2020 <- vat_thresholds_2020[-c(2:4)]
colnames(vat_thresholds_2020) <- c("country", "threshold")
vat_thresholds_2020$country <- str_remove_all(vat_thresholds_2020$country, "[6*]")
vat_thresholds_2020$year <- "2020"

#Combine years
vat_thresholds <- rbind(vat_thresholds_2007, vat_thresholds_2010, vat_thresholds_2011,
                        vat_thresholds_2012,vat_thresholds_2013,vat_thresholds_2014, 
                        vat_thresholds_2016, vat_thresholds_2018, vat_thresholds_2020)

#Change NAs to zeros and delete empty rows
vat_thresholds[is.na(vat_thresholds)] <- 0
vat_thresholds <- subset(vat_thresholds, vat_thresholds$country!="0")

#Add Latvia for 2014; Lithuania for 2014 and 2016#

country <- c("Latvia")
threshold <- c("100402")
year <- c("2014")
LVA <- data.frame(country, threshold, year)

country <- c("Lithuania", "Lithuania")
threshold <- c("101580", "100671")
year <- c("2014", "2016")
LTU <- data.frame(country,threshold,year)

vat_thresholds <- rbind(vat_thresholds, LVA, LTU)
vat_thresholds <- merge(vat_thresholds,country_names,by=c("country"))

write.csv(vat_thresholds,paste(thresholds,"vat_thresholds.csv",sep=""),row.names = FALSE)
