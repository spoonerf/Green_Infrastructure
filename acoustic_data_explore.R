library(lubridate)

#####adding in appropriate date time vlaues for each of the acoustic datasets

file_name<-list.files(paste(getwd(),"/Data/Raw_data", sep=""), pattern = "*.csv")

f_sites<-gsub("_|.csv", "", file_name)

f_df<-data.frame(file_name, f_sites)

all_sites<-read.csv("surveyTimeAndDate_FSamend.csv")

sites_f<-merge(f_df, all_sites, by.x = "f_sites", by.y = "SiteCode")

sites_f$start_datetime<-as.POSIXct(paste(sites_f$Start_Date, sites_f$Start_Time, sep = " "), format = "%d-%m-%y %H:%M:%OS")


sr<-0.524  #one record every 0.524 seconds


site_datetime<-function(site_name){
  
  df<-sites_f[sites_f$f_sites == site_name,]
  
  acoustic<-read.csv(paste(getwd(), "/Data/Raw_data/", df$file_name, sep=""))
  
  time_seq<-seq(
    from=as.POSIXct(df$start_datetime[1], format = "%Y-%m-%d %H:%M:%OS"),
    #to=as.POSIXct("2015-08-25 09:30:00.00", format = "%Y-%m-%d %H:%M:%OS"),
    by= sr,
    length.out = (7*24*60*60)/sr
  )  
  
  t.lub <- ymd_hms(time_seq)
  h.lub <- minute(t.lub)
  
  down_time<-which(h.lub == 29)    #removing times that are in the 29th minute
  
  time_seq_sub<-time_seq[-down_time]
  df_sub<-acoustic[1:length(time_seq_sub),]
  df_sub$datetime<-time_seq_sub
  df_sub$site<-site_name
  
  write.csv(df_sub, paste(getwd(), "/Data/Processed_data/",site_name, "_acoustic_datetime.csv", sep=""))
  return(df_sub)
  
}

sapply(sites_f$f_sites[26:nrow(sites_f)], site_datetime)

####plotting and checking the data

br4<-read.csv(paste(getwd(), "/Data/Processed_data/", sites_f$f_sites[1],"_acoustic_datetime.csv", sep=""), stringsAsFactors = FALSE)

br4$datetime <- as.POSIXct(br4$datetime)


br4$time <- strftime(br4$datetime, format="%H:%M:%OS")
br4$time <- as.POSIXct(br4$time, format="%H:%M:%OS")

library(ggplot2)
library(dplyr)

test<-br4 %>%
  group_by(time) %>%
  summarize(mean_anth = mean(anthrop), mean_bio = mean(biotic), na.rm = T)

ggplot(test, aes(x = time, y = mean_anth))+
  geom_point()

ggplot(test, aes(x = time, y = mean_bio))+
  geom_point()+
  geom_smooth()


################################

# getting dawn and dusk from coordinates

library(suncalc)

lon_lat<-read.csv("allSitesDetailsCoordinates.csv")

xy_id<-lon_lat[, c("SiteCode", "Lat", "Long")]

sites_xy<-merge(sites_f, xy_id, by.x = "f_sites", by.y = "SiteCode")


data<-data.frame(date = as.Date(sites_xy$Start_Date, format = "%d-%m-%y"), lat = sites_xy$Lat, lon = sites_xy$Long)

getSunlightTimes(data = data, keep = c("sunrise", "sunriseEnd", "sunset", "sunsetStart"), tz = "GMT")













