# SNOTEL site info for running snow17r_main

################################################################################
#########################    START USER EDITS    ###############################
################################################################################

# Enter SNOTEL site ID
site_id = 663
  
# Enter water year start and end (01 October through 30 September)
wyear_start = 2010
wyear_end = 2020
wyears = wyear_start:wyear_end

################################################################################
##########################    END USER EDITS    ################################
################################################################################

# Initialize empty forcing data frame
forcing <- data.frame()

# Download strings
dl1 = "https://wcc.sc.egov.usda.gov/nwcc/view?intervalType=Historic+&report=STAND&timeseries=Daily&format=copy&sitenum="
dl2 = "&year="
dl3 = "&month=WY"

# Loop through each water year and download data
for(i in 1:length(wyears)){
  
  # Download data into temporary data frame
  tmp <-
    read.csv(url(paste0(dl1,
                        site_id,
                        dl2,
                        wyears[i],
                        dl3)),
             stringsAsFactors = F,
             skip = 4)
  
  # Bind temporary data frame to snotel data frame
  forcing <- bind_rows(forcing, tmp)
  
  # Remove tmp files
  rm(tmp)
}

# Rename select columns
# Convert depth to mm
depth_conv_factor = 25.4 # for inches to millimeters

forcing <- forcing %>% 
  select(site_id = Site.Id,
         date = Date,
         ppt_in = PREC.I.1..in.,
         tair_c = TAVG.D.1..degC.,
         swe_obs_in = WTEQ.I.1..in.) %>% 
  transmute(site_id, 
            date = as.Date(date),
            tair_c,
            ppt_mm = ppt_in * depth_conv_factor,
            swe_obs_mm = swe_obs_in * depth_conv_factor) %>% 
  mutate(ppt_mm = c(0, diff(ppt_mm)),
         ppt_mm = case_when(ppt_mm < 0 ~ 0,
                            TRUE ~ ppt_mm))