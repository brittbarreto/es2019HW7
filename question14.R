library(tidyverse)
library(readr)
library(dplyr)
library(data.table)
library(stringr)
library(readxl)
library(ggforce)

# when you do HW7, skip data preparation and go to the function I made. 

## import the data
#data downloading and preparation

o3.filenames <- list.files("data/ca_ozone", pattern = ".txt")

#change the working directory
setwd("data/ca_ozone")
#Load the data
o3.filelist <- lapply(o3.filenames, read_delim, delim = "|")
#set the name for each element in the list
names(o3.filelist) <- gsub(".txt", "", o3.filenames)

daily <- o3.filelist %>%
  rbindlist() %>%
  group_by(site = as.factor(site), date) %>%
  summarize(o3 = mean(obs, na.rm = TRUE))

colnames(loc)[1] <- "site"
daily.site <- daily %>%
  left_join(loc, by = "site")

# Before making the function, data preparation is needed.

#change the column name "Site Name" because this includes a space  
colnames(daily.site)[5] <- "SiteName"
colnames(daily.site)[11] <- "CountyName"
#add new columns for annual mean, median, max, and min for each site.
by_sitename_year <- daily.site %>% 
  mutate(obs_year = year(date)) %>%
  group_by(SiteName, obs_year) %>% 
  summarize(mean = mean(o3), median = median(o3), max = max(o3), min = min(o3))


#function
annual_statistic <- function(site, stats){
  #site parameter is for a regular expression detecting sites you want. Here "San|Santa".
  #stats parameter is for which statistical value you want among mean, median, max, and min.
  
  #detect sites by a regular expression assigned as a site parameter
  selected_data <- filter(by_sitename_year, str_detect(SiteName, pattern = site))
  
  #prepare for plotting
  #check the matched city number for plotting
  city_number <- group_by(selected_data, SiteName) %>% 
    count() %>% 
    nrow()
  required_pages <- ceiling(city_number / 9) # 9 graphs are shown in a page
  
  #plotting using ggforce 
  if(stats == "mean"){
    for(n in 1:required_pages){
      plot <- ggplot(data = selected_data)+
        geom_point(mapping = aes(x = obs_year, y = mean))+
        facet_wrap_paginate(~SiteName, ncol=3, nrow = 3, page = n)
      print(plot)
    }
  }else if(stats == "median"){
    for(n in 1:required_pages){
      plot <- ggplot(data = selected_data)+
        geom_point(mapping = aes(x = obs_year, y = median))+
        facet_wrap_paginate(~SiteName, ncol=3, nrow = 3, page = n)
      print(plot)
    }  
  }else if(stats == "max"){
    for(n in 1:required_pages){
      plot <- ggplot(data = selected_data)+
        geom_point(mapping = aes(x = obs_year, y = max))+
        facet_wrap_paginate(~SiteName, ncol=3, nrow = 3, page = n)
      print(plot)
    }  
  }else if(stats == "min"){
    for(n in 1:required_pages){
      plot <- ggplot(data = selected_data)+
        geom_point(mapping = aes(x = obs_year, y = min))+
        facet_wrap_paginate(~SiteName, ncol=3, nrow = 3, page = n)
      print(plot)
    }  
  }else{print("stats parameter must be mean, median, max, or min.")}
}


#Use the function to obtain annual mean of ozone concentrations for all sites that have “San” or “Santa” in their name.

annual_statistic(site = "San|Santa",stats = "mean")
