
## Visualisations for exploratory analysis of Bayesian hierarchical regression models

### All the data needed for this analysis are saved in the folder named "PISA_Data" as; maths_pisa.Rdata and Europe_Pisamaths.Rdata.

#### If you can't load this data, the codes in 00_OECD_Rawdata.Rmd file will generate the data for you but you have to download the SPSS raw data directly from OECD website.

**The maths_pisa.Rdata contains the entire data from OECD with all the countries that participated in PISA survey. This data set is the average maths score across all the countries over time.**

**The Europe_Pisamaths.Rdata contains the data for the European countries comprising of 237 observations from 40 countries. Filtering year 2022, as the modelling were conducted without the PISA 2022 observations, we have 202 observations left.**

### Data cleaning - 00_OECD_RawData.Rmd
Upon careful examination, it was observed that the PISA dataset recorded by the learningtower differs from the information available on the OECD website. 
Consequently, we decided to download the raw data directly from the OECD website.

The datasets for the years 2022, 2018, and 2015 are saved as SPSS (.sav file), while the preceding years— 2012, 2009, 2006, 2003, and 2000—are saved as TXT files.

For the .sav files, the R package named haven provides a function called read_spss, facilitating the reading of SPSS files into R. 
Utilizing this package, we successfully loaded the data in its SPSS format for the years 2022, 2018, and 2015.

As for the PISA surveys conducted prior to 2015, the data was stored as TXT files. 
There are multiple methods to load the data into R, including downloading SPSS software. 
However, to streamline the process, we opted for the R package pbiecek, which contains the raw data directly from the OECD website spanning from 2000 to 2012. 
The raw data, comprising score points and weights, was downloaded as a dataset.

The R package intsvy, designed to consider complex sample designs, was employed for this purpose. We used this package to compute the mean of the raw data for each country.

### Data Processing - 00_PISA_Data.R
This file contains all the necessary libraries for this analysis. It processed the data and saved the data for the European countries as Pisa_Europe_Data with PISA2022 observations and PISA_Europe_Data without PISA2022 observations. 

For the independent country model, we ignored countries with one data points. Countries like Belarus, Ukraine, and Bosnia & Herzegovina. Hence, we created a new dataset for the Pisa_Europe_Data and PISA_Europe_Data without these countries as SPisa_Europe_Data and SPISA_Europe_Data respectively.

### Model Fitting - 01_Hierarchical_Models.Rmd
In all our models, we employed the brms R package and fitted 5 models which are:
Model 1 - The independent model  $\text{math} \sim \; \text{year} * \text{Country}$

Model 2 - The country-specific model $\text{math} \sim \; \text{year} + (1 + \text{year} | \text{Country})$

Priors were established for the country-specific alphas and betas, as well as for $\sigma$. Introducing a prior on $\sigma$ was crucial for facilitating the posterior setup, enabling predictions for missing data points and future estimations. This process was reiterated with a hyper-parameterisation of  $\alpha$ and $\beta$, ensuring that country estimates originated from a common prior distribution. 

Subsequently, we extended the model into a hierarchical structure, incorporating three levels (Region, Income, and Income-region). The model was adapted to assign hyper-parameters to countries based on their respective hierarchical structures. Our rationale behind specifying distinct hyper-parameters according to the hierarchical structure was to evaluate the influence of information sharing within specific groups.

Model 3 - The region hierarchical model $\text{math} \sim \; \text{year} + (1 + \text{year} | \text{Region}) + (1 + \text{year} | \text{Country})$

Model 4 - The Income hierarchical model $\text{math} \sim \; \text{year} + (1 + \text{year} | \text{Income}) + (1 + \text{year} | \text{Country})$

Model 5 - The Income-region hierarchical model $\text{math} \sim \; \text{year} + (1 + \text{year} | \text{Income-region}) + (1 + \text{year} | \text{Country})$


### Extracting estimates from the models - 01_Model_Estimates.Rmd
The parameter estimates derived from all the fitted models were extracted in this file and utilised to generate visual representations of the model regression line on the observed data. These visualisations are stored as "Independent_fit.pdf," "country_specific_fit.pdf," "region_hierarchical_fit.pdf," "income_hierarchical_fit.pdf," and "income-region_hierarchical_fit.pdf" within the **regression_fits folder** of the **Saved_Plots folder**.


### Plots for the Background section of the paper - 02_Background_Section.Rmd
The conventional visualisation of model estimates where we have the model fit on the data points, showing the overall trends across each country was created and the plots showing the country offsets from the country-specific model.

### Displaying the model in the data space - 03_Model_in_Data_Space.Rmd
We displayed the model in the data space using the ggragged R package to arrange the panels according to their respective geographical groupings. We utilised colour, scaled to facilitate comparison across each region group.

### Examining a collection of multiple models - 03_Multiple_Models.Rmd
We displayed the parameter estimates across the 5 models and the hyper-parameter estimates across the 4 hierarchical models simultaneously arranging the countries to micmic the geographical layouts with the help of the geofacet package. We specified a grid manually to position each country on a 7 by 8 matrix.

### Exploring the PISA 2022 estimates - 04_Model_Prediction.Rmd
We predicted the estimates across the countries using the income-region hierarchical model and presented the prediction error by subtracting the predicted estimates from the observed values (Observed - Predicted). The estimates alongside its 50%, 80% and 95% prediction intervals were presented using the stat_pointinterval function of ggdist R package. Countries were faceted using the income-region grouping and coloured by the same color scheme used to differentiate the region and income groups.
