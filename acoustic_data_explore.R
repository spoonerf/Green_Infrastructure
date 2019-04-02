f<-list.files(paste(getwd(),"/csv_results", sep=""), pattern = "*.csv")

test<-read.csv(paste(getwd(), "/csv_results/", f[3], sep=""))

length(seq(
  from=as.POSIXct("2015-07-31 13:00:00"),
  to=as.POSIXct("2015-08-07 14:29:59"),
  by="sec"
)  
)/nrow(test)
