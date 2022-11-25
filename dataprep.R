#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# dataprep.R
# R shiny basic demo ----
# R Code Club 10 November 2022
# Isabella Tortora Brayda
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# This dashboard is going to show the incidence of 3 main cancer types (Breast, Lung and Prostate) in Scotland and across
# a few healthboards (Borders, Fife, Lothian and Greater Glasgow and Clyde) between 2000 and 2020.
# 
#  We will have three main outputs:
#   1) Line graph of cancer incidence by 3 cancer types (breast, lung and prostate) at Scotland level,
#   2) Data table for the data used to produce the first output.
#   3) Bar chart of cancer incidence by cancer type, and healthboard (4 selected healthboards),


# Libraries ----
#~~~~~~~~~~~~~~~~

library(shiny)
library(tidyverse)
library(tidylog)
library(haven)
library(phsmethods)
library(janitor)

# Data Prep (note that for larger dashboards these could be done individual scripts for each tab) ----
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# Read in data on cancer incidence at Scotland level:

data_path <- paste("https://www.opendata.nhs.scot/dataset/c2c59eb1-3aff-48d2-9e9c-60ca8605431d/resource/3aef16b7-8af6-4ce0-a90b-8a29d6870014/download/opendata_inc9620_hb.csv")
cancer_data <- read.csv(data_path) %>% 
  clean_names()
names(cancer_data)
levels(as.factor(cancer_data$cancer_site))

# Create extract for R shiny app (which will show cancer incidence by year (from 2000 - 2020) and cancer type)


## create breakdown by nhsboard and cancer type
cancer_breakdown <- cancer_data%>% 
  filter(!is.na(hb),!is.na(cancer_site)) %>% 
  group_by(cancer_site, hb, year) %>% 
  summarise(count = sum(incidences_all_ages)) %>% 
  ungroup()

# create scotland level extract
cancer_scotland <- cancer_data %>% 
  group_by(cancer_site, year) %>% 
  summarise(count = sum(incidences_all_ages)) %>% 
  ungroup() %>% 
  mutate(hb = "Scotland")

# merge the nhs board level data and scotland level data into one extract
cancer00_20 <- bind_rows(cancer_breakdown,cancer_scotland) %>% 
  filter(year %in% 2000:2020,
         cancer_site %in% c("All cancer types","Breast","Trachea, bronchus and lung","Prostate")) 

# WRITE TO CSV: ----

write.csv(cancer00_20,"cancer_data.csv", row.names = FALSE)

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
## END OF DATA PREP
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
