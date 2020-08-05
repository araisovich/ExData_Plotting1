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
#set up a 2x2 set of plot areas
par(mfrow=c(2,2));
with(dt,
     #Plot the global active power in top-left quadrant
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
       #set the scale ticks on the left
       axis(side=2, at=seq(from=0,to=6,by=2))
       #Perform the next plot in the top right quadrant
       plot(x=datetime,
            y=Voltage, 
            #yaxt="n",
            ylab="Voltage",
            type="l",  #line plot
            pty="m"
       )
       #perform the next plot (empty) in the bottom left quadrant
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
       #add a green line plot of sub metering 1, of width 5; could not determine
       #what color the wide plot line was, so I set green.
       lines(x=dt$datetime,
             y=dt$Sub_metering_1,
             col="green",
             lwd=3)
       #and plot the sub metering ranges in appropriate colors
       lines(x=datetime,
             y=dt$Sub_metering_1,
             col="black"
       )
       lines(x=datetime,
             y=dt$Sub_metering_2,
             col="red"
       )
       lines(x=datetime,
             y=dt$Sub_metering_3,
             col="blue"
       )
       #set the ticking and scale on the y axis
       axis(side=2, at=seq(from=0,to=30,by=10))
       #add an open legend, without a border
       legend("topright",
              legend=colnames(dt)[5:7],
              lty=1,
              bty="n",
              col=c("black","red","blue"))
       #Perform the plot in the bottom right quadrant
       plot(x=datetime,
            y=Global_reactive_power, 
            type="l",  #line plot
            pty="m",
            cex.lab=0.8
       )
    }
);
#and close the graphics device
dev.off()

