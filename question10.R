library(tidyverse)
library(readr)
library(dplyr)
library(stringr)
library(readxl)

#Some addresses are unknow like "Address Not Known" or NA. 
#Some addresses are incomplete like "Watt Road" for site 2044. 
#I think full address must contain some number like "7400 Sunrise Blvd" for site 2001.

#extract the Address column as a vector
Address <- pull(loc,"Address")
FullAddress <- str_subset(Address, "\\d")
FullAddress

#It seems like these addresses are complete address. 
#In addition to address, check zip code. California zip code is a 5 digit number starting with 9. 

#extract the Zip Code column as a vector
ZipCode <- pull(loc,"Zip Code")

#The number of sites that do not have a complete address
length(Address) - sum(str_detect(Address, "\\d") & str_detect(ZipCode, "^\\d{5}"), na.rm = TRUE)