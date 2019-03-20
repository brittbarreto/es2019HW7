library(tidyverse)
library(readr)
library(dplyr)
library(stringr)
library(readxl)

#import the data
loc <- read_excel("data/ca_ozone/location.xls")

#extract the Site Name column as a vector
SiteNames <- pull(loc,"Site Name")

#count the numbers of site containg "San" or "Santa" in thier name
sum(str_count(SiteNames, "San|Santa"))

##Adding this line to the end of your code would allow you to see the addresses with this string rather than just the number of how many contain the string.
str_view_all(SiteNames, "San\\s|Santa", match = T)
