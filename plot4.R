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
png(file="plot4.png", width=480, height=480);
par(mfrow=c(2,2));
#perform the plot, with red-filled boxes, x labels, and title
with(dt,
     { plot(x=datetime,
            y=Global_active_power, 
            yaxt="n",
            ylab="Global Active Power",
            xlab="",
            type="l",  #line plot
            ylim=c(0,8),
            pty="m",
            cex.lab=0.8,
            cex.axis=0.8
       )
       axis(side=2, at=c(0,2,4,6))
       plot(x=datetime,
            y=Voltage, 
            #yaxt="n",
            ylab="Voltage",
            #xlab="",
            type="l",  #line plot
            #ylim=c(0,8),
            pty="m"
            #,
            #cex.lab=0.8,
            #cex.axis=0.8
       )
       plot(x=datetime,
            y=rep(NA,length(datetime)), 
            yaxt="n",
            ylab="Energy sub metering",
            xlab="",
            type="l",  #line plot
            ylim=c(0,39),
            pty="m",
            cex.lab=0.9 #,
            #cex.axis=0.8
       )
       lines(x=datetime,
             y=dt$Sub_metering_1,
             col="grey"
       )
       lines(x=datetime,
             y=dt$Sub_metering_2,
             col="red"
       )
       lines(x=datetime,
             y=dt$Sub_metering_3,
             col="blue"
       )
       axis(side=2, at=c(0,10,20,30))
       legend("topright",
              legend=colnames(dt)[5:7],
              lty=1,
              bty="n",
#              cex=0.95,
              col=c("grey","red","blue"))
       plot(x=datetime,
            y=Global_reactive_power, 
#            yaxt="n",
            #ylab="Global Reactive Power",
#            xlab="",
            type="l",  #line plot
#            ylim=c(0,8),
            pty="m",
            cex.lab=0.8,
            #cex.axis=0.8
       )
    }
);
#and close the graphics device
dev.off()

