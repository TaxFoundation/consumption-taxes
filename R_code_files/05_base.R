#Vat Base####
#Source data: https://doi.org/10.1787/888933890122
vat_base <- read_excel(paste(source_data,"oecd_vat_revenue_ratio_calculations.xlsx",sep=""), 
                       sheet = "Sheet1", range = "A7:W43")
vat_base <- vat_base[-c(2:16)]

columns <- names(vat_base)
values<-c("United States","0.341","0.354","0.358","0.351","0.347","0.341","0.339")
US <- data.frame(columns, values)
US <- spread(US, columns, values)

vat_base <- rbind(vat_base, US)

vat_base <- melt(vat_base, id.vars=c("Country"))
colnames(vat_base) <- c("country","year","vat_base")

#Change NAs to zeros and delete those rows
vat_base[is.na(vat_base)] <- 0
vat_base <- subset(vat_base,country!="0")

#Add 2-year lag
vat_base$year <- as.character.Date(vat_base$year)
vat_base$year <- as.numeric(vat_base$year)
vat_base$year <- vat_base$year+2

write.csv(vat_base,paste(intermediate_outputs,"vat_base.csv",sep=""), row.names = FALSE)