# Script for calibrating the model

# Assign min and max values for params

# Single rain-snow threshold; rain_snow = 1
rs_thresh_max = 2.5 #°C
rs_thresh_max = 2.5 #°C

# Dual rain-snow threshold; rain_snow = 2
snow_thresh_max = 1.0 #°C, max temperature at which precip is all snow
rain_thresh_min = 4.0 #°C, min temperature at which precip is all rain

# Maximum degree day factor
ddf_max = 2 #mm/day/°C

# Minimum degree factor
ddf_min = 1 #mm/day/°C

# Air temperature above which melt can occur
tair_melt_thresh = 1 #°C




# Create parameter set data frame
# Note: think of making multiple data frames in a list
# when running different model types or parameter sets




# Call model
source("model/snow17r_model.R")

# Save output and parameter values