# Consumption tax data including sales taxes, VAT, and Excise tax Revenue

The Tax Foundation’s publication [Consumption Tax Policies in OECD Countries](https://taxfoundation.org/consumption-tax-policies/) shows to what extent OECD countries rely on different consumption tax revenue sources and discusses the variation of these policies throughout the OECD.

## The Dataset and its Tax Revenue Categories and Scope

### The Datasets
The majority of the data used in this publication comes from OECD data sources, primarily Consumption Tax Trends (https://www.oecd-ilibrary.org/taxation/consumption-tax-trends-2020_152def2d-en) and the OECD's Revenue Statistics dataset (https://stats.oecd.org/Index.aspx?DataSetCode=REV). See `source_documentation.md` for more details on sources.


### Revenue Categories
The OECD's  Revenue Statistics Database provides various categories for the different tax revenue sources. For our report, we chose the categories as follows:

* **Consumption Taxes:** Covers the OECD category *5000 Taxes on goods and services*.
* **Value added Taxes:** Covers the OECD category *5111 Taxes on goods and services*.
* **Sales Taxes:** Covers the OECD category *5112 Taxes on goods and services*.
* **Excise Taxes:** Covers the OECD category *5121 Taxes on goods and services*.
* **Other:** Covers the unallocated portion of Consumption Taxes.

## Explanation of Files in Repository

### /main directory

Location of the source documentation and this README.

The R code reads in and downloads the necessary data, cleans the data, adds missing data manually (except for `reduced_rates_base.csv`), merges datasets, and produces intermediate and final output datasets and tables.

The source documentation cites all the sources used.

### /R_code_files
Location of the R code used to read and manipulate the source data into intermediate and final output files.

-  `00_master_file.R` runs the other R code files in the repository.
-  `01_setup.R` sets universal variables and loads relevant packages.
-  `02_revenue.R` downloads and cleans consumption tax revenue data.
-  `03_rates.R` cleans and structures data on consumption tax rates.
-  `04_thresholds.R` cleans and structures data on VAT thresholds.
-  `05_base.R` cleans and structures data on VAT revenue ratios.
-  `06_excise.R` cleans and structures data on excise taxes.
-  `07_combine_files.R` combines files for intermediate outputs.
-  `08_output_files.R` structures files for final outputs.

### /source_data

Location of **input** files to .R code file including:

- `country-codes.csv` Dataset that includes all 249 sovereign states and dependent territories that have been assigned a country code by the International Organization for Standardization (ISO). Includes official country names in various languages, ISO country codes, continents, and further geographical information.

- **Various OECD Tables** Data tables from the different vintages of the Consumption Tax Policies in OECD Countries that include yearly or trend data on VAT and GST rates and turnover thresholds; VAT revenue ratios (one table covering 1976 to 2016 and one covering 1992-2018); excise rates on alcoholic beverages (2018 and 2020), automotive diesel (2017 and 2019), beer (2018 and 2020), household light fuel (2017 and 2019), premium unleaded gasoline (2017 and 2019), tobacco (2018 and 2020), wine (2018 and 2020), and cigarettes (2017).

### /intermediate_outputs

Location of **intermediate output** files of .R code file including files concerning:

- Tax Base
- Excise Taxes
- Tax Rates
- Tax Revenue
- Tax Thresholds
-  `consumption_data.csv` - a summary dataset of all relevant variables for 1967-2020.
-  `consumption_trends.csv` - OECD average trends for all trend variables
-  `reduced_rates_2020.csv` - a table of reduced VAT rates by country for 2020.

### /final_outputs
Location of **output tables** that are included in the country profile pages at taxfoundation.org for example: https://taxfoundation.org/country/austria/.

- `alcohol.csv` Table of alcohol excise rates.
- `fuel.csv` Table of fuel excise rates.
- `reduced_rates_base.csv` Table of VAT reduced rates and the tax base to which they apply.
- `revenue.csv` Table showing the OECD average tax revenue shares for the three types of consumption taxes.
- `tobacco.csv` Table of fuel excise rates.

## Explanation of Main Datasets in /intermediate_outputs
### `consumption_data.csv`
#### Panel data for 37 OECD countries from 1967-2020 (not all variables are available for all years)
#### Variable Descriptions
- `iso_2` : Two character ISO code for countries available for all countries in all years
- `iso_3` : Three character ISO code for countries available for all countries in all years
- `country` : Country names for the 37 OECD countries
- `year` : Year for data, runs from 1967-2020
- `higher_rate_1` : Higher rate for VAT available for VAT countries with higher rates from 1967-2012 (2012 is the last year an OECD country [Colombia] had a higher rate for VAT)
- `higher_rate_2` : Second higher rate for VAT available for VAT countries with two higher rates from 1975-2012 (2012 is the last year an OECD country [Colombia] had two higher rates for VAT); `higher_rate_1`<`higher_rate_2`
- `higher_rate_3` : Third higher rate for VAT available for VAT countries with three higher rates from 1980-2012 (2012 is the last year an OECD country [Colombia] had three higher rates for VAT); `higher_rate_1` < `higher_rate_2` < `higher_rate_3`
- `reduced_rate_1`: First reduced rate for VAT available for VAT countries with reduced rates from 1967-2020
- `reduced_rate_2`: Second reduced rate for VAT available for VAT countries with reduced rates from 1968-2020; `reduced_rate_1` < `reduced_rate_2`
- `reduced_rate_3`: Third reduced rate for VAT available for VAT countries with reduced rates from 1971-2020; `reduced_rate_1` < `reduced_rate_2` < `reduced_rate_3`
- `reduced_rate_4`: Fourth reduced rate for VAT available for VAT countries with reduced rates from 1976-2020; `reduced_rate_1` < `reduced_rate_2` < `reduced_rate_3` < `reduced_rate_4`
- `reduced_rate_5`: Fifth reduced rate for VAT available for VAT countries with reduced rates from 1977-1988 (only applies to Italy and France); `reduced_rate_1` < `reduced_rate_2` < `reduced_rate_3` < `reduced_rate_4` < `reduced_rate_5`
- `reduced_rate_6`: Sixth reduced rate for Italy in 1980; `reduced_rate_1` < `reduced_rate_2` < `reduced_rate_3` < `reduced_rate_4` < `reduced_rate_5` < `reduced_rate_6`
- `standard_vat_rate`: Standard VAT rates for countries with VAT from 1967-2020
- `threshold`: General threshold for registration or collection of VAT in US dollars. Years included are 2007, 2010, 2011, 2012, 2013, 2014, 2016, 2018, 2020.
- `vrr`: Vat Revenue Ratio calculated as VRR = VAT Revenue/[(Consumption - VAT revenue) x standard VAT rate]. Consumption = Final Consumption Expenditure (Heading P3) in national accounts. VAT rates used are standard rates applicable as at 1 January of each year. Applicable for VAT countries from 1976-2019.
- `5000_consumption_pct_total`: Percent of total tax revenue for code 5000 Taxes on goods and services in https://stats.oecd.org/Index.aspx?DataSetCode=REV; available for years 1975-2019
- `5111_vat_pct_total`: Percent of total tax revenue for code 5111 Value added taxes in https://stats.oecd.org/Index.aspx?DataSetCode=REV; available for years 1975-2019
- `5112_sales_pct_total`: Percent of total tax revenue for code 5112 Sales tax in https://stats.oecd.org/Index.aspx?DataSetCode=REV; available for years 1975-2019
- `5121_excise_pct_total`: Percent of total tax revenue for code 5121 Excises in https://stats.oecd.org/Index.aspx?DataSetCode=REV; available for years 1975-2019
- `5000_consumption_pct_gdp`: Percent of GDP for code 5000 Taxes on goods and services in https://stats.oecd.org/Index.aspx?DataSetCode=REV; available for years 1975-2019
- `5111_vat_pct_gdp`: Percent of GDP for code 5111 Value added taxes in https://stats.oecd.org/Index.aspx?DataSetCode=REV; available for years 1975-2019
- `5112_sales_pct_gdp`: Percent of GDP for code 5112 Sales tax in https://stats.oecd.org/Index.aspx?DataSetCode=REV; available for years 1975-2019
- `5121_excise_pct_gdp`: Percent of GDP for code 5121 Excises in https://stats.oecd.org/Index.aspx?DataSetCode=REV; available for years 1975-2019
- `beer_excise_hl_usd`: specific excise per hectoliter per & abv in US Dollars for years 2018 and 2020
- `beer_low_alc_usd`: Excise duty on low alcohol beer (not exceeding 2.8% abv), excise per hectoliter of product in US dollars. Applicable for Denmark, Finland, France, and the United Kingdom; for years 2018 and 2020.
- `still_wine_excise_hl_usd`: Still wine excise per hectoliter in US dollars for years 2018 and 2020
- `sparkling_wine_excise_hl_usd`: Sparkling wine excise per hectoliter in US dollars for years 2018 and 2020
- `low_alc_excise_hl_usd`: Low-alcohol still wine (<8.5% abv) excise per hectoliter in US dollars for years 2018 and 2020
- `alc_excise_hl_usd`: Excise tax per hectoliter of absolute alcohol in US dollars for years 2018 and 2020
- `small_dist_rate`: Dummy variable (1,0) for whether a country has a special rate for small distilleries, for years 2018 and 2020
- `cigarette_excise_1k_usd`: Specific excise per 1,000 cigarettes in US dollars for years 2018 and 2020
- `cigarette_excise_1k_pct_rsp`: _Ad valorem_ excise on cigarettes as percent of retail sales price for years 2018 and 2020
- `cigar_excise_1k_usd`: Specific excise per 1,000 cigars in US dollars for years 2018 and 2020
- `cigar_excise_1k_pct_rsp`: _Ad valorem_ excise on cigars as percent of retail sales price for years 2018 and 2020
- `roll_tob_excise_1kg_usd`: Specific excise per 1,000 grams of rolling tobacco for cigarettes in US dollars for years 2018 and 2020
- `roll_tob_excise_1kg_pct_rsp`: _Ad valorem_ excise on rolling tobacco as percent of retail sales price for years 2018 and 2020
- `cig_pack_ex_tax_price_usd`: Ex-tax price for a pack of 20 cigarettes in U.S. dollars for years 2014 and 2016
- `cig_pack_specific_pct_rsp`: Specific excise on a pack of 20 cigarettes as a percent of retail sales price for years 2014 and 2016
- `cig_pack_ad_val_pct_rsp`: _Ad valorem_ excise on a pack of 20 cigarettes as a percent of retail sales price for years 2014 and 2016
- `cig_pack_sales_pct_rsp`: VAT/GST/RST on a pack of 20 cigarettes as a percent of retail sales price for years 2014 and 2016
- `cig_pack_total_tax_pct_rsp`: Total tax on a pack of 20 cigarettes as a percent of retail sales price for years 2014 and 2016
- `cig_pack_price_usd`: Retail sales price in US dollars for a pack of 20 cigarettes for years 2014 and 2016
- `unleaded_total_tax_pct_price`: Total tax as % of total price for premium unleaded gasoline (per liter) for years 2017 and 2019
- `unleaded_excise_pct_price`: Excise tax as % of total price for premium unleaded gasoline (per liter) for years 2017 and 2019
- `diesel_total_tax_pct_price`: Total tax as % of total price for automotive diesel (per liter) for years 2017 and 2019
- `diesel_excise_pct_price`: Excise tax as % of total price for automotive diesel (per liter) for years 2017 and 2019
- `household_fuel_total_tax_pct_price`: Total tax as % of total price for light fuel oil for households (per liter) for years 2017 and 2019
- `household_fuel_excise_pct_price`: Excise tax as % of total price for light fuel oil for households (per liter) for years 2017 and 2019

### `consumption_trends.csv`
Variable descriptions (see above for variable descriptions of variables used in annual averages)
- `year`: Year; 1975-2019 for revenue variables
- `consumption_pct_gdp`: Annual average for `5000_consumption_pct_gdp`
- `vat_pct_gdp`: Annual average for `5111_vat_pct_gdp`
- `sales_pct_gdp`: Annual average for `5112_sales_pct_gdp`
- `excise_pct_gdp`: Annual average for `5121_excise_pct_gdp`
- `pct_gdp_observations`: Number of countries included in average for each year for % of GDP variables
- `consumption_pct_rev`: Annual average for `5000_consumption_pct_total`
- `vat_pct_rev`: Annual average for `5111_vat_pct_total`
- `sales_pct_rev`: Annual average for `5112_sales_pct_total`
- `excise_pct_rev`: Annual average for `5121_excise_pct_total`
- `pct_rev_observations`: Number of countries included in average for each year for % of total revenue variables
- `vat_rate_avg`: Annual average for `standard_vat_rate`; for years 1975, 1985, 1995, 2005, 2007, 2009-2020
- `rates_observations`: Number of countries included in average for each year for `vat_rate_avg`; for years 1975, 1985, 1995, 2005, 2007, 2009-2020
- `vat_threshold_avg`: Annual average for `threshold`; for years 2007, 2010-2014, 2016, 2018, 2020 
- `threshold_observations`: Number of countries included in average for each year for `vat_threshold_avg`; for years 2007, 2010-2014, 2016, 2018, 2020 
- `vat_base_avg`: Annual average for `vrr`; for years 1976, 1980, 1984, 1988, 1992, 1996, 2000, 2005, 2007-2019
- `base_observations`: Number of countries included in average for each year for `vat_base_avg`; for years 1976, 1980, 1984, 1988, 1992, 1996, 2000, 2005, 2007-2019

### `reduced_rates_2020.csv`
- `country`: country name
- `year`: year (2020)
- `category`: level of reduced rate
- `rate`: reduced rate of VAT