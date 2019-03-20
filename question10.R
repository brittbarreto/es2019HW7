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

### This would instead filter out the incomplete addresses and physically show the ones that are complete 
## rather than just giving a numerical answer. The string is long, however the structure
##can be used for future string detection purposes. 
miss_add<-str_detect(loc$Address,"\\d{1,5}\\s\\w.\\s(\\b\\w*\\b\\s){1,2}\\w*\\.")
miss_zip<-str_detect(loc$`Zip Code`,"\\d{5}")
Complete<- loc%>%
  filter(Incomp.1,Incomp.Zip)
