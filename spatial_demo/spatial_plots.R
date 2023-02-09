#### Installing sf ####
install_spatial_package <- function(package_name=NULL,archive_path=NULL){
  
  if (is.null(package_name) & is.null(archive_path)){
    stop("Please supply either a package name or source URL e.g. CRAN archive url")
  }
  
  old_ld_path <- Sys.getenv("LD_LIBRARY_PATH")
  Sys.setenv(LD_LIBRARY_PATH = paste(old_ld_path,
                                     "/usr/local/gdal/lib",
                                     "/usr/local/proj-6.3.0/lib",
                                     sep = ":"))
  # Specify additional proj path in which pkg-config should look for .pc files
  Sys.setenv("PKG_CONFIG_PATH" = "/usr/local/proj-6.3.0/lib/pkgconfig")
  # Specify the path to GDAL data
  Sys.setenv("GDAL_DATA" = "/usr/local/gdal/share/gdal")
  
  
  
  if (is.null(archive_path)){
    # Install the "sf" package from source, specifying the paths to GDAL and proj
    install.packages(package_name,
                     configure.args = c("--with-gdal-config=/usr/local/gdal/bin/gdal-config",
                                        "--with-proj-include=/usr/local/proj-6.3.0/include",
                                        "--with-proj-lib=/usr/local/proj-6.3.0/lib"),
                     INSTALL_opts = "--no-test-load")  
  } else {
    # Install the "sf" package from source, specifying the paths to GDAL and proj
    install.packages(archive_path, repos = NULL,
                     configure.args = c("--with-gdal-config=/usr/local/gdal/bin/gdal-config",
                                        "--with-proj-include=/usr/local/proj-6.3.0/include",
                                        "--with-proj-lib=/usr/local/proj-6.3.0/lib"),
                     INSTALL_opts = "--no-test-load")
  }
  
}
# Use function above to install
install_spatial_package(
  archive_path = 
    "https://cran.r-project.org/src/contrib/Archive/sf/sf_0.9-8.tar.gz")


#### Spatial Plotting in R ####

#### Load Libraries ####
# Make sure to load the GDAL library module before loading the packages
# reliant on GDAL
dyn.load("/usr/local/gdal/lib/libgdal.so")
# load package
library(sf) # vector reading & analysis
library(tidyverse)  # load dplyr, tidyr, ggplot2 packages
library(readxl) # To read in excel file
library(plotly) # To make interactive plots

#### Reading in Shapefiles ####
# Read in the NHS Health Board File
health_boards <- read_sf("Spatial Files/SG_NHS_HealthBoards_2019/SG_NHS_HealthBoards_2019.shp")
# For viewing readability 
as_tibble(health_boards)
# Plot the health boards using default plot() function
# plot(health_boards)
# show names of the data frame health_boards
# names(health_boards)
# plot column of interest
plot(health_boards['HBName'])

#### Reading in the CWT excel Data sheet ####
# Read in the CWT_data using that is taken from https://publichealthscotland.scot/publications/cancer-waiting-times/cancer-waiting-times-1-april-to-30-june-2022/
CWT_data <- read_excel("Spatial Files/2022-09-27-cwt-table-1-compliance-to-standard.xlsx", 
                       sheet = "Data", col_types = c("skip", 
                                                     "text", "text", "text", "text", "numeric", 
                                                     "numeric", "numeric", "numeric", 
                                                     "numeric", "skip", "numeric"))

#### Tidying and filtering Data ####
# Filter Data for this example will only consider most recent quarter data published, 62 day target and All Cancer Types
CWT_data_62_day <- CWT_data %>% 
  filter(`Report Type` == "62 Day",
         `Quarter End` == "April-June 2022",
         `Cancer Type` == "All Cancer Types*") %>% 
  rename(Standard = `Report Type`,
         Quarter = `Quarter End`,
         HB = `Health Board`,
         pct_62_day = `62 day performance`,
         no_eligible_referrals = `Number of Eligible referrals`,
         no_eligible_referrals_treated_62_days = `Number of Eligible referrals treated within 62 days`,
         percentile_95 =`95th percentile`) %>% 
  select(-c(Standard, Quarter, `Cancer Type`)) 

# View data we are using
as_tibble(CWT_data_62_day)

# This is how I would usually get the tables to join by creating variable HBCode with conditions to fill
# CWT_data_62_day <- CWT_data_62_day %>% 
#   mutate(HBCode = case_when(HB == "NHS Ayrshire & Arran" ~ "S08000015", HB == "NHS Borders" ~ "S08000016",
#                             HB == "NHS Dumfries & Galloway" ~ "S08000017", HB == "NHS Fife" ~ "S08000029",
#                             HB == "NHS Forth Valley" ~ "S08000019", HB == "NHS Grampian" ~ "S08000020",
#                             HB == "NHS Greater Glasgow & Clyde" ~ "S08000031", HB == "NHS Highland" ~ "S08000022",
#                             HB == "NHS Lanarkshire" ~ "S08000032", HB == "NHS Lothian" ~ "S08000024",
#                             HB == "NHS Orkney" ~ "S08000025", HB == "NHS Shetland" ~ "S08000026",
#                             HB == "NHS Tayside" ~ "S08000030", HB == "NHS Western Isles" ~ "S08000028"))

# Making key to join two data sets as making HBCode from HB didn't work
HBName <- sort(health_boards$HBName)
HB <- sort(CWT_data_62_day$HB[1:14])
key <- as.data.frame(cbind(HBName,HB))
as_tibble(key) # View Key to make sure correct  

#### Merging Data to Shapefile ####
# joining CWT data to key and then to the shapefile data
CWT_data_62_day <- left_join(CWT_data_62_day,key, by = "HB")
HB_CWT_data <- left_join(health_boards, CWT_data_62_day, by ="HBName")

# Plot the health boards CWT data using default plot() function
plot(HB_CWT_data, max.plot = 11) # Can use to check data has all been joined
names(HB_CWT_data) # Make sure all columns have been joined as wanted

#### Making Plot using ggplot2 ####
# plot, ggplot
ggplot() +
  geom_sf(data = HB_CWT_data, aes(fill = pct_62_day)) +
  scale_fill_distiller(palette = "RdYlGn", direction=1,
                       guide = guide_legend(title = "% 62 day", reverse=T)) +
  theme_void() +
  ggtitle("62 day performance by NHS Health Board", subtitle = "All Cancer Types*")

#### Preparing ggplot to be made into interactive plot ####
plot <- ggplot() +
  geom_sf(data = HB_CWT_data, aes(fill = pct_62_day, text = paste0("</br>Health Board: ",HB,
                                                                   "</br>Eligible Referrals: ", no_eligible_referrals,
                                                                   "</br>Eligible Referrals Treated within 62 days: ",  no_eligible_referrals_treated_62_days, 
                                                                   "</br>62 day Performance: ", pct_62_day,
                                                                   "</br>Met 62 day Target: ", ifelse(pct_62_day >= 95, "Yes", "No")))) +
  scale_fill_distiller(palette = "RdYlGn", direction=1,
                       guide = guide_legend(title = "% 62 day", reverse=T)) +
  theme_void() +
  ggtitle("62 day performance by NHS Health Board", subtitle = "All Cancer Types*")


ggplotly(plot, tooltip = c("text"))
