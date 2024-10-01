## Loading the necessary libraries for this file

library(dplyr)
library(tidyr)
rm(list = ls()) # clear workspace

## loading the data cleaned and saved from 00_OECD_rawdata.Rmd
load(here::here("PISA_data", "maths_pisa.Rdata"))

##PISA_Data contains the available PISA data on OECD which has been processed 
#by grouping countries by region (WHO) and Income (WDI)

## For these analysis, we are analysing only the European data.
## Hence, filter the available data for European countries.
Pisa_Europe_Data <- PISA_Data |> filter(Continent == "Europe")

#For these analysis, the baseline year is 2018. 
#Hence, we will create a variable called year_orig centering the year on 0 with year 2018.

baseline_year <- 2018

Pisa_Europe_Data <- Pisa_Europe_Data |>
  mutate(year_orig = year - baseline_year)|> #Subtracting the 2018 from year variable
  arrange(Country)

#We introduced a new variable called Income-region
## Joining the Income and Region together to form one new column
Pisa_Europe_Data <- unite(Pisa_Europe_Data, col = "Income_region", 
                          c("Income", "Region"), sep = "_ ", remove = FALSE)



#Saving all the data in the PISA_Data folder

save(Pisa_Europe_Data, 
     file =here::here("PISA_data", "Europe_Pisamaths.Rdata"))

#Selecting the unique countries with their respective region, income and income-region groups
Country_groups <- Pisa_Europe_Data |>
  select(Country, Region, Income, Income_region) |>
  unique()

#The color flag for region
R_flag <- data.frame(color_region=c("bisque2", "#ACE1AF", "lightsteelblue2","lavenderblush2"),
                     Region= unique(Country_groups$Region))

#The color flag for Income
I_flag <- data.frame(color_income=c("magenta3", "black"),
                     Income= unique(Country_groups$Income))

#Joining the color flags with the country_groups
Country_groups <- Country_groups |>
  left_join(R_flag, by = join_by(Region)) |>
  left_join(I_flag, by = join_by(Income)) |>
  as.data.frame()

save(Country_groups, 
     file =here::here("PISA_data", "Country_groups.Rdata"))

