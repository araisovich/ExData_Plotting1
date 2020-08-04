#ar3 - had to install package data.table to use it to read in the semicolon-delimited file
#install.packages("data.table")
#position ourselves conveniently in the file system
setwd("~/coursera/ExData_Plotting");
#make sure the data.tables package is loaded
require(data.table);
#read in the semicolon-delimited data file
dt <- read.table(file.choose(), #allow user to select file via gui
                 header=TRUE,   #headers are included in the file
                 sep=";",       #semicolons as colseps
                 dec=".",       #decimal point indicates numeric
                 na.strings="?",#NA values indicated by ?
                 stringsAsFactor=FALSE); #bring in string fields as character vectors, not factors
#use strptime to convert the date and time fields into POSIX time, and add it as column datetime
dt$datetime <- strptime(paste(dt$Date,dt$Time), format="%d/%m/%Y %H:%M:%S");
#drop the columns Date and Time from the dataframe
dropcols <- c("Date","Time")
dt <- dt[, !(names(dt) %in% dropcols)]
