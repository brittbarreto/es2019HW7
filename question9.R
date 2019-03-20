library(tidyverse)
library(readr)
library(dplyr)
library(stringr)
library(readxl)

#import the data
loc <- read_excel("data/ca_ozone/location.xls")

##this is a shorter and "cleaner" version of doing searching for the patterns and
##would allow to easily re edit the "San|Santa" for future uses.
match<- loc %>%  
  filter(str_detect(`Site Name`, "^(San|Santa)"))
