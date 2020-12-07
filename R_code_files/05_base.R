#Vat Base####
#Source data: https://doi.org/10.1787/888933890122
vat_base <- read_excel(paste(source_data,"oecd_vat_revenue_ratio_calculations.xlsx",sep=""), 
                       sheet = "Sheet1", range = "A7:W43")
vat_base <- vat_base[-c(2)]

columns <- names(vat_base)
vat_base <- melt(vat_base, id.vars=c("Country"))
colnames(vat_base) <- c("country","year","vat_revenue_ratio")

#Change NAs to zeros and delete those rows
vat_base[is.na(vat_base)] <- 0
vat_base <- subset(vat_base,country!="0")

write.csv(vat_base,paste(base,"vat_base.csv",sep=""), row.names = FALSE)
