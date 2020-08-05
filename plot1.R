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
dt <- dt[with(dt,order(dt$datetime)),]
#open a .png file device, resolution 480x480 pixels
png(file="plot1.png", width=480, height=480);
#perform the plot, with red-filled boxes, x labels, and title; x/y axis ticks off,
#to be added after the plot
plot(hist(dt$Global_active_power), 
     xaxt="n",
     yaxt="n",
     xlab="Global Active Power (kilowatts)", 
     main="Global Active Power", 
     xlim=c(0,8), 
     ylim=c(0,1200), 
     cex=0.8,
     col="red");
#add x axis ticks and scale
axis(side=1, at=seq(from=0, to=6, by=2));
#add y axis ticks and scale
axis(side=2, at=seq(from=0, to=1200, by=200));
#and close the graphics device
dev.off();
close(dt);
