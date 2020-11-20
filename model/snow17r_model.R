# This script contains the model mechanism for computing SWE


################################################################################
# Compute model data outside of time loop
# Because SNOW-17 is a simple model, computational time can be saved by
# performing many operations outside of the time loop

# Assign precipitation phase
# 0 = snow, 1 = rain
if(rain_snow == 1){
  forcing <- forcing %>% 
    mutate(ppt_phase = case_when(tair_c <= rs_thresh ~ 0,
                                 TRUE ~ 1))
} else if(rain_snow == 2){
  forcing <- forcing %>% 
    mutate(ppt_phase = case_when(tair_c <= snow_thresh_max ~ 0,
                                 tair_c >  rain_thresh_min ~ 1,
                                 TRUE ~ tair_c - snow_thresh_max / 
                                   (rain_thresh_min - snow_thresh_max)))
} else if(rain_snow == 3){
  # NEED WAY TO DEFINE 
} else{
  stop("Missing or incorrect precipitation phase method specified")
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

################################################################################
# Time loop for model

#
if(model_type == "TI"){
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
    
  } # end time loop
} # end model_type == TI

# SNOW17 model implementation
# Based on Anderson (2006)
if(model_type == "SNOW17"){
  
} 


################################################################################
#
