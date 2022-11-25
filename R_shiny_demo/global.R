#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# global.R
# R shiny basic demo ----
# R Code Club 10 November 2022
# Isabella Tortora Brayda
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# Libraries ----
#~~~~~~~~~~~~~~~~

library(shiny)
library(shinymanager)
library(tidyverse)
library(tidylog)
library(haven)
library(phsmethods)

# Create a colour palette for plots in the dashboard: 

col_palette <- c('#3F3685',
                 '#9F9BC2',
                 '#9B4393',
                 '#CDA1C9',
                 '#0078D4',
                 '#B3D7F2',
                 '#EE82EE',
                 '#9CC951')
