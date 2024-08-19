## Loading the necessary libraries for this analysis
library(tidybayes)
library(ggplot2)
library(dplyr)
library(tidyr)
library(brms)
library(stringr)
library(bayesplot)
library(ggragged)
library(geofacet)
library(grid)

## loading the data cleaned and saved from 00_OECD_Rawdata.Rmd
load(here::here("PISA_Data", "maths_pisa.Rdata"))

##PISA_Data contains the available PISA data on OECD which has been processed 
#by grouping countries by region (WHO) and Income (WDI)

## For these analysis, we are analysing only the European data.
## Hence, filter the available data for European countries.
Pisa_Europe_Data <- PISA_Data |> filter(Continent == "Europe")

#For these analysis, the baseline year is 2018. 
#Hence, we will create a variable called year_orig centering the year on 0 with year 2018.

baseline_year <- 2018

Pisa_Europe_Data <- Pisa_Europe_Data |>
  mutate(year_orig = year - baseline_year)|>#Subtracting the 2018 from year variable
  arrange(Country)

#We introduced a new variable called Income-region
## Joining the Income and Region together to form one new column
Pisa_Europe_Data <- unite(Pisa_Europe_Data, col = "Income_region", 
                          c("Income", "Region"), sep = "_ ", remove = FALSE)

## We intend to make prediction for year 2022 and compare it with the observed data,
## Hence the complete PISA Europe data set is stored as Pisa_Europe_Data, 
## while the data set without the year 2022 is stored as PISA_Europe_Data.
PISA_Europe_Data <- Pisa_Europe_Data |>
  filter(year != "2022") # removing year 2022

## For the independent country  model, 
## we ignored countries with one data point as this countries only have one data point.
#Hence, This model will be fitted excluding Belarus, Ukraine, and Bosnia & Herzegovina. 
## We created a new variable called SCountry containing the countries with one data point.
SCountry <- c("Belarus", "Bosnia & Herzegovina", "Ukraine")

SPisa_Europe_Data <- Pisa_Europe_Data |> #Pisa_Europe_Data with obs for 2022
  filter(!Country %in% SCountry)

SPISA_Europe_Data <- PISA_Europe_Data |> #PISA_Europe_Data without obs for 2022
  filter(!Country %in% SCountry)

#Saving all the data in the PISA_Data folder
PISA_Europe <- here::here("PISA_Data", "Europe_Pisamaths.Rdata")

save(Pisa_Europe_Data,PISA_Europe_Data, SPisa_Europe_Data, SPISA_Europe_Data, 
     file =PISA_Europe)

#------------------------------------------------------------------------------
#Selecting the unique country names, with the region, income and incomeregion groupings 
SNames <- SPISA_Europe_Data |> 
  select(Country, Region, Income, Income_region) |>
  distinct()

Names <- PISA_Europe_Data |> 
  select(Country, Region, Income, Income_region) |>
  distinct()


