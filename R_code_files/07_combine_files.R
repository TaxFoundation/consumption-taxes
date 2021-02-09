#Combine country files####
consumption_revenue<-read_csv(paste(revenues,"revenue_final.csv",sep=""))
vat_rates <- read_csv(paste(rates,"vat_rates_1967_2020.csv",sep=""))
vat_thresholds<-read_csv(paste(thresholds,"vat_thresholds.csv",sep=""))
vat_base <- read_csv(paste(base,"vat_base_1976_2019.csv",sep=""))
excise <- read_csv(paste(excises,"excise_taxes.csv",sep=""))
consumption_data <- merge(vat_rates, vat_thresholds, by=c("iso_2","iso_3","country","year"),all=T)
consumption_data <- merge(consumption_data, vat_base, by=c("iso_2","iso_3","country","year"),all=T)
consumption_data <- merge(consumption_data, consumption_revenue,by=c("iso_2","iso_3","country","year"),all=T)
consumption_data <- merge(consumption_data, excise,by=c("iso_2","iso_3","country","year"),all=T)

consumption_data<-consumption_data%>%replace_na(list(higher_rate_1="",
                                   higher_rate_2="",higher_rate_3="",reduced_rate_1="",
                                   reduced_rate_2="",
                                   reduced_rate_3="",
                                   reduced_rate_4="",
                                   reduced_rate_5="",
                                   reduced_rate_6="",
                                   standard_vat_rate="",
                                   threshold="",
                                   vrr="",
                                   consumption_pct_total_5000="",
                                   vat_pct_total_5111="",
                                   sales_pct_total="",
                                   excise_pct_total="",
                                   consumption_pct_gdp_5000="",
                                   vat_pct_gdp_5111="",
                                   sales_pct_gdp_5112="",
                                   excise_pct_gdp_5121="",
                                   beer_excise_hl_usd="",
                                   beer_low_alc_usd="",
                                   still_wine_excise_hl_usd="",
                                   sparkling_wine_excise_hl_usd="",
                                   low_alc_excise_hl_usd="",
                                   alc_excise_hl_usd="",
                                   small_dist_rate="",
                                   cigarette_excise_1k_usd="",
                                   cigarette_excise_1k_pct_rsp="",
                                   cigar_excise_1k_usd="",
                                   cigar_excise_1k_pct_rsp="",
                                   roll_tob_excise_1kg_usd="",
                                   roll_tob_excise_1kg_pct_rsp="",
                                   cig_pack_ex_tax_price_usd="",
                                   cig_pack_specific_pct_rsp="",
                                   cig_pack_ad_val_pct_rsp="",
                                   cig_pack_sales_pct_rsp="",
                                   cig_pack_total_tax_pct_rsp="",
                                   cig_pack_price_usd="",
                                   unleaded_total_tax_pct_price="",
                                   unleaded_excise_pct_price="",
                                   diesel_total_tax_pct_price="",
                                   diesel_excise_pct_price="",
                                   household_fuel_total_tax_pct_price="",
                                   household_fuel_excise_pct_price=""))
write.csv(consumption_data,file = paste(intermediate_outputs,"consumption_data.csv",sep=""),row.names=F)

#Combine trend files####
consumption_pct_gdp<-read_csv(paste(revenues,"consumption_pct_gdp.csv",sep=""))
consumption_pct_rev<-read_csv(paste(revenues,"consumption_pct_rev.csv",sep=""))
vat_rate_trend<-read_csv(paste(rates,"vat_rate_avg_1975_2020.csv",sep=""))
vat_threshold_trend<-read_csv(paste(thresholds,"thresholds_2007_2020.csv",sep=""))
vat_base_trend<-read_csv(paste(base,"vat_base_avg_1976_2019.csv",sep=""))


consumption_trends<-merge(consumption_pct_gdp,consumption_pct_rev,by="year",all=T)
consumption_trends<-merge(consumption_trends,vat_rate_trend,by="year",all=T)
consumption_trends<-merge(consumption_trends,vat_threshold_trend,by="year",all=T)
consumption_trends<-merge(consumption_trends,vat_base_trend,by="year",all=T)

write.csv(consumption_trends,file = paste(intermediate_outputs,"consumption_trends.csv",sep=""),row.names=F)
