#Directory Variables####
R_code_files<-"C:/Github/consumption-taxes/R_code_files/"
source_data<-"C:/Github/consumption-taxes/source_data/"
intermediate_outputs<-"C:/Github/consumption-taxes/intermediate_outputs/"
revenues<-"C:/Github/consumption-taxes/intermediate_outputs/revenue/"
rates<-"C:/Github/consumption-taxes/intermediate_outputs/rates/"
thresholds<-"C:/Github/consumption-taxes/intermediate_outputs/thresholds/"
base<-"C:/Github/consumption-taxes/intermediate_outputs/base/"
excise<-"C:/Github/consumption-taxes/intermediate_outputs/excise/"
final_data<-"C:/Github/consumption-taxes/final_data/"
final_outputs<-"C:/Github/consumption-taxes/final_outputs/"

#Define Using function####
using<-function(...,prompt=TRUE){
  libs<-sapply(substitute(list(...))[-1],deparse)
  req<-unlist(lapply(libs,require,character.only=TRUE))
  need<-libs[req==FALSE]
  n<-length(need)
  installAndRequire<-function(){
    install.packages(need)
    lapply(need,require,character.only=TRUE)
  }
  if(n>0){
    libsmsg<-if(n>2) paste(paste(need[1:(n-1)],collapse=", "),",",sep="") else need[1]
    if(n>1){
      libsmsg<-paste(libsmsg," and ", need[n],sep="")
    }
    libsmsg<-paste("The following packages count not be found: ",libsmsg,"n\r\n\rInstall missing packages?",collapse="")
    if(prompt==FALSE){
      installAndRequire()
    }else if(winDialog(type=c("yesno"),libsmsg)=="YES"){
      installAndRequire()
    }
  }
}

#Load libraries####
using(OECD)
using(readxl)
using(plyr)
using(dplyr)
using(reshape2)
using(countrycode)
using(tidyverse)
using(stringr)
using(readr)
using(xlsx)
using(scales)
using(magicfor)

#Define list of OECD countries####
oecd_countries<-c("AUS",
                  "AUT",
                  "BEL",
                  "CAN",
                  "CHL",
                  "COL",
                  "CZE",
                  "DNK",
                  "EST",
                  "FIN",
                  "FRA",
                  "DEU",
                  "GRC",
                  "HUN",
                  "ISL",
                  "IRL",
                  "ISR",
                  "ITA",
                  "JPN",
                  "KOR",
                  "LVA",
                  "LUX",
                  "LTU",
                  "MEX",
                  "NLD",
                  "NZL",
                  "NOR",
                  "POL",
                  "PRT",
                  "SVK",
                  "SVN",
                  "ESP",
                  "SWE",
                  "CHE",
                  "TUR",
                  "GBR",
                  "USA")

#Read in ISO Country Codes####
#Source: https://www.cia.gov/library/publications/the-world-factbook/appendix/appendix-d.html
#Import and match country names with ISO-3 codes####

#Read in country name file
country_names <- read.csv(paste(source_data,"iso-country-codes.csv",sep=""))
colnames(country_names)[colnames(country_names)=="ï..country"] <- "country"
