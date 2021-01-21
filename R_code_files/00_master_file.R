#Clean up working environment####
rm(list=ls())
gc()
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

#Run code files####
source("01_setup.R")
source("02_revenue.R")
source("03_rates.R")
source("04_thresholds.R")
source("05_base.R")
source("06_excise.R")
source("07_combine_files.R")
source("08_output_files.R")
