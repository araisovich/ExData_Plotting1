#ar3 - installed sqldf to filter rows when reading from csv file
#install.packages("sqldf")
#position ourselves conveniently in the file system
setwd("~/coursera/ExData_Plotting1");
#make sure the sqldf package is loaded
require(sqldf);
#read in the semicolon-delimited data file
dt <- read.csv.sql(file.choose(),          #allow user to select file via gui
                   sql="select * from file where Date='1/2/2007' or Date='2/2/2007'", #limit to Feb 1 and 2 of 2007
                   header=TRUE,            #headers are included in the file
                   sep=";",                #semicolons as colseps
                   stringsAsFactor=FALSE  #bring in string fields as character vectors, not factors
                  );
#use strptime to convert the date and time fields into POSIX time, and add it as column datetime
dt$datetime <- strptime(paste(dt$Date,dt$Time), format="%d/%m/%Y %H:%M:%S");
#drop the columns Date and Time from the dataframe
dropcols <- c("Date","Time")
dt <- dt[, !(names(dt) %in% dropcols)]
#then order the data frame (not strictly required)
#dt <- dt[with(dt,order(dt$datetime)),]
#open a .png file device, resolution 480x480 pixels
png(file="plot2.png", width=480, height=480);
#perform the plot, with red-filled boxes, x labels, and title
#perform the plot, x labels off, and title; y axis ticks off,
#to be added after the plot
plot(x=dt$datetime,
     y=dt$Global_active_power, 
     yaxt="n",
     ylab="Global Active Power (kilowatts)",
     xlab="",
     type="l",  #line plot
     ylim=c(0,8),
     pty="m",
     cex.lab=0.8,
     cex.axis=0.8
);
#add the y axis ticks
axis(side=2, at=seq(from=0, to=6, by=2));
#and close the graphics device
dev.off()
