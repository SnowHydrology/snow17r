# Main model script for SNOW-17 adapted in R

# Keith Jennings
# kjennings@lynkertech.com
# 2020-11-12

################################################################################
# Load packages
# Will throw error if not installed
library(tidyverse)
library(lubridate)

# Initialize model in brackets 
# Allows code to stop and print errors
{
################################################################################
# Initialize model type, mode, and parameters
source("config/snow17r_params.R")

################################################################################
# Import forcing data

# If data_type = "SNOTEL", grab snotel data
if(data_type == "SNOTEL"){
  source("config/snow17r_snotel.R")
} else {
  forcing <- read.csv(paste0("data/", data_string))
}
  
################################################################################
# Run model in normal or calibration mode
if(model_mode == "NORMAL"){
  source("model/snow17r_model.R")
} else if(model_mode == "CALIBRATION"){
  source("calibration/snow17r_calibration.R")
} else{
  stop("Missing or incorrect model mode specified. Options are NORMAL or CALIBRATION.")
}

  
# Plot
plotly::ggplotly(
  ggplot(forcing, aes(date, swe_mm)) + 
    geom_line(color = "purple") + 
    geom_line(data = forcing, aes(date, swe_obs_mm), color = "black") + 
    ylim(0,500))
}

# Need some of export function here