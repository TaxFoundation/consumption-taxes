#VAT Thresholds####
vat_thresholds_2014 <- read_excel(paste(source_data,"oecd_vat_gst_annual_turnover_concessions_ctt_trends.xlsx",sep=""), sheet = "2014", range = "a4:d37")
vat_thresholds_2016 <- read_excel(paste(source_data,"oecd_vat_gst_annual_turnover_concessions_ctt_trends.xlsx",sep=""), sheet = "2016", range = "a4:e41")
vat_thresholds_2018 <- read_excel(paste(source_data,"oecd_vat_gst_annual_turnover_concessions_ctt_trends.xlsx",sep=""), sheet = "2018", range = "A4:e42")
vat_thresholds_2020 <- read_excel(paste(source_data,"oecd_vat_gst_annual_turnover_concessions_ctt_trends.xlsx",sep=""), sheet = "2020", range = "A4:e42")

#2014
vat_thresholds_2014 <- vat_thresholds_2014[-c(2:3)]
colnames(vat_thresholds_2014) <- c("country","vat_threshold")
vat_thresholds_2014$country <- str_remove_all(vat_thresholds_2014$country, "[*]")
vat_thresholds_2014$year <- "2014"

#2015
vat_thresholds_2015 <- vat_thresholds_2014
vat_thresholds_2015$year <- "2015"

#2016
vat_thresholds_2016 <- vat_thresholds_2016[-c(2:4)]
colnames(vat_thresholds_2016) <- c("country","vat_threshold")
vat_thresholds_2016$country <- str_remove_all(vat_thresholds_2016$country, "[(f)*]")
vat_thresholds_2016$year <- "2016"

#2017
vat_thresholds_2017 <- vat_thresholds_2016
vat_thresholds_2017$year <- "2017"

#2018
vat_thresholds_2018 <- vat_thresholds_2018[-c(2:4)]
colnames(vat_thresholds_2018) <- c("country", "vat_threshold")
vat_thresholds_2018$country <- str_remove_all(vat_thresholds_2018$country, "[6*]")
vat_thresholds_2018$year <- "2018"

#2019
vat_thresholds_2019 <- vat_thresholds_2018
vat_thresholds_2019$year <- "2019"

#2020
vat_thresholds_2020 <- vat_thresholds_2020[-c(2:4)]
colnames(vat_thresholds_2020) <- c("country", "vat_threshold")
vat_thresholds_2020$country <- str_remove_all(vat_thresholds_2020$country, "[6*]")
vat_thresholds_2020$year <- "2020"

#Combine years
vat_thresholds <- rbind(vat_thresholds_2014, vat_thresholds_2015, vat_thresholds_2016, vat_thresholds_2017, vat_thresholds_2018, vat_thresholds_2019, vat_thresholds_2020)

#Change NAs to zeros and delete empty rows
vat_thresholds[is.na(vat_thresholds)] <- 0
vat_thresholds <- subset(vat_thresholds, vat_thresholds$country!="0")

#Add US for all years; Latvia for 2014 and 2015; Lithuania for 2014, 2015, 2016, 2017#
country <- c("United States","United States","United States","United States","United States","United States", "United States")
vat_threshold <- c("0","0","0","0","0","0","0")
year <- c("2014","2015","2016","2017","2018","2019","2020")
USA <- data.frame(country, vat_threshold, year)

country <- c("Latvia", "Latvia")
vat_threshold <- c("100402", "100604")
year <- c("2014", "2015")
LVA <- data.frame(country, vat_threshold, year)

country <- c("Lithuania", "Lithuania", "Lithuania", "Lithuania")
vat_threshold <- c("101580", "100897", "100671", "100223")
year <- c("2014", "2015", "2016", "2017")
LTU <- data.frame(country,vat_threshold,year)

vat_thresholds <- rbind(vat_thresholds, USA, LVA, LTU)

write.csv(vat_thresholds,paste(intermediate_outputs,"vat_thresholds.csv",sep=""),row.names = FALSE)
