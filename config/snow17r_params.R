# Parameter file for snow17r

################################################################################
########################    START USER OPTIONS    ##############################
################################################################################

# Forcing data option
# SNOTEL = automatically download a single site's data for multiple water years
# OTHER = provide your own user data (must be a CSV in /data)
data_type = "SNOTEL"
data_string = "testdata.csv"

# Identify model type
# Options are:
# TI (simple temperature index)
# SNOW17 (Anderson 2006)
model_type = "TI"

# Identify model mode
# Options are:
# NORMAL
# CALIBRATION
model_mode = "NORMAL"

# Rain-snow partitioning method
# 1 = single threshold
# 2 = dual threshold 
  # The rain-snow elevation method in SNOW17 is not implemented here
# 3 = precipitation phase assigned as part of forcing data
rain_snow = 2

################################################################################
#########################    END USER OPTIONS    ###############################
################################################################################


################################################################################
############################    PARAMETERS    ##################################
################################################################################

# Single rain-snow threshold; rain_snow = 1
rs_thresh = 2.5 #°C

# Dual rain-snow threshold; rain_snow = 2
snow_thresh_max = 1.0 #°C, max temperature at which precip is all snow
rain_thresh_min = 4.0 #°C, min temperature at which precip is all rain

# Maximum degree day factor
ddf_max = 2 #mm/day/°C

# Minimum degree factor
ddf_min = 1 #mm/day/°C

# Air temperature above which melt can occur
tair_melt_thresh = 0 #°C

# Initial SWE
swe_init = 0 #mm (only change if you wish to start model from a known state)
