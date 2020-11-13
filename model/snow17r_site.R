# SNOTEL site info for running snow17r_main

##########################    USER EDITS    ################################

# Enter SNOTEL site ID
site_id = 663
  
# Enter water year start (01 October through 30 September)
wyear_start = 2020
wyear_end   = 2020


# Build the download link

# Download strings
dl1 = "https://wcc.sc.egov.usda.gov/nwcc/view?intervalType=Historic+&report=STAND&timeseries=Daily&format=copy&sitenum="
dl2 = "&year="
dl3 = "&month=WY"

dl_url <- paste0(dl1,
                 site_id,
                 dl2,
                 wyears,
                 dl3)



