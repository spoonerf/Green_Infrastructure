f<-list.files(paste(getwd(),"/Data", sep=""), pattern = "*.csv")

test<-read.csv(paste(getwd(), "/Data/", f[2], sep=""))

length(seq(
  from=as.POSIXct("2015-07-31 13:00:00"),
  to=as.POSIXct("2015-08-07 14:29:59"),
  by="sec"
)  
)/nrow(test)
