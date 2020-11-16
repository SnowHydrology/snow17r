# Main model script for SNOW-17 adapted in R

# Keith Jennings
# kjennings@lynkertech.com
# 2020-11-12

# Load packages
# Will throw error if not installed
library(tidyverse)
library(lubridate)

# Initialize model type and parameters
source("config/snow17r_params.R")

# If data_type = "SNOTEL", grab snotel data
if(data_type == "SNOTEL"){
  source("config/snow17r_snotel.R")
} else {
  forcing <- read.csv(paste0("data/", data_string))
}

# Assign precipitation phase
# 0 = snow, 1 = rain
if(rain_snow == 1){
  forcing <- forcing %>% 
    mutate(ppt_phase = case_when(tair_c <= rs_thresh ~ 0,
                             TRUE ~ 1))
}

# Compute snowfall and rainfall
forcing <- forcing %>% 
  mutate(snowfall_mm = (1 - ppt_phase) * ppt_mm,
         rainfall_mm = ppt_mm - snowfall_mm)

# Compute degree day factors
forcing <- forcing %>% 
  mutate(ddf = ((ddf_max + ddf_min) / 2) + 
           (sin((yday(date) - 81 )/ 58.09) *
           ((ddf_max - ddf_min) / 2)))

# Compute potential melt
forcing <- forcing %>% 
  mutate(melt_pot_mm = case_when(tair_c > tair_melt_thresh ~ 
                                   (tair_c - tair_melt_thresh) * ddf,
                                 TRUE ~ 0))

# Initialize SWE at first time step
forcing <- forcing %>% 
  mutate(swe_mm = NA)
forcing[1, "swe_mm"] = swe_init

# Perform time loop to compute SWE and actual melt
for(i in 2:length(forcing$date)){
  # Add new snowfall to SWE
  if(forcing[i, "snowfall_mm"] > 0){
    forcing[i, "swe_mm"] = forcing[i - 1, "swe_mm"] + forcing[i, "snowfall_mm"]
  } else {
    if(forcing[i, "melt_pot_mm"] > 0){
      forcing[i, "swe_mm"] = forcing[i - 1, "swe_mm"] - forcing[i, "melt_pot_mm"]
    } else{
      forcing[i, "swe_mm"] = forcing[i - 1, "swe_mm"]
    }
  }
  
  # Check that SWE is not negative (from too much melt)
  if(forcing[i, "swe_mm"] < 0){
    forcing[i, "swe_mm"] = 0
  } # no else needed
  
}
