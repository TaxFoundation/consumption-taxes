# Consumption tax data including sales taxes, VAT, and Excise tax Revenue

The Tax Foundation’s publication [Consumption Tax Policies in OECD Countries](https://taxfoundation.org/consumption-tax-policies/) shows to what extent OECD countries rely on different consumption tax revenue sources and discusses the variation of these policies throughout the OECD.

## The Dataset and its Tax Revenue Categories and Scope

### The Datasets
The majority of the data used in this publication comes from OECD data sources, primarily Consumption Tax Trends (https://www.oecd-ilibrary.org/taxation/consumption-tax-trends-2020_152def2d-en) and the OECD's Revenue Statistics dataset (https://stats.oecd.org/Index.aspx?DataSetCode=REV).


### Revenue Categories
The OECD's  Revenue Statistics Database provides various categories for the different tax revenue sources. For our report, we chose the categories as follows:

* **Consumption Taxes:** Covers the OECD category *5000 Taxes on goods and services*.
* **Value added Taxes:** Covers the OECD category *5111 Taxes on goods and services*.
* **Sales Taxes:** Covers the OECD category *5112 Taxes on goods and services*.
* **Excise Taxes:** Covers the OECD category *5121 Taxes on goods and services*.
* **Other:** Covers the unallocated portion of Consumption Taxes.

## Explanation of Files in Repository

### /main directory

Location of the R code, the source documentation, and this README.

The R code reads in and downloads the necessary data, cleans the data, adds missing data manually (except for `reduced_rates_base.csv`), merges datasets, and produces intermediate and final output datasets and tables.

The source documentation cites all the sources used.

### /source-data

Location of **input** files to .R code file including:

- `country-codes.csv` Dataset that includes all 249 sovereign states and dependent territories that have been assigned a country code by the International Organization for Standardization (ISO). Includes official country names in various languages, ISO country codes, continents, and further geographical information.

- **Various OECD Tables** Data tables from the different vintages of the Consumption Tax Policies in OECD Countries that include yearly or trend data on VAT and GST rates and turnover thresholds; VAT revenue ratios (one table covering 1976 to 2016 and one covering 1992-2018); excise rates on alcoholic beverages (2018 and 2020), automotive diesel (2017 and 2019), beer (2018 and 2020), household light fuel (2017 and 2019), premium unleaded gasoline (2017 and 2019), tobacco (2018 and 2020), wine (2018 and 2020), and cigarettes (2017).

### /intermediate-outputs

Location of **intermediate output** files of .R code file including files concerning:

- Tax Base
- Excise Taxes
- Tax Rates
- Tax Revenue
- Tax Thresholds
-  `consumption_data.csv` - a summary dataset of all relevant variables for 1967-2020.
-  `consumption_trends.csv` - OECD average trends for all trend variables
-  `reduced_rates_2020.csv` - a table of reduced VAT rates by country for 2020.

### /final-outputs
Location of **output tables** that are included in the country profile pages at taxfoundation.org for example: https://taxfoundation.org/country/austria/.

- `alcohol.csv` Table of alcohol excise rates.

- `fuel.csv` Table of fuel excise rates.

- `reduced_rates_base.csv` Table of VAT reduced rates and the tax base to which they apply.

- `revenue.csv` Table showing the OECD average tax revenue shares for the three types of consumption taxes.

- `tobacco.csv` Table of fuel excise rates.