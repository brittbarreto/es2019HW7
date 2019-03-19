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

#Before making the function, data preparation is needed.

```{r}
by_county_day <- daily.site %>% 
  mutate(year = year(date), month = month(date),day = mday(date)) %>%
  group_by(CountyName, year, month, day) %>% 
  summarize(daily_mean = mean(o3))


#calculate annural daily mean ozone concentration
daily_mean_by_county <- by_county_day %>% 
  group_by(CountyName, year) %>% 
  summarize(annual_daily_mean = mean(daily_mean))

annual_daily_mean_county <- function(county){
  #detect county by a regular expression assigned in county parameter
  selected_data <- filter(daily_mean_by_county, str_detect(CountyName, pattern = county))
  #results in quantitive foramt
  print(selected_data)
  #visual format
  plot <- ggplot(data = selected_data)+
    geom_point(mapping = aes(x = year, y = annual_daily_mean))
  print(plot)
}

annual_daily_mean_county("Merced")

