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
png(file="plot3.png", width=480, height=480);
#perform an empty plot, with no y axis ticks; to be added later
plot(x=dt$datetime,
     y=rep(NA,length(dt$datetime)), 
     yaxt="n",
     ylab="Energy sub metering",
     xlab="",
     type="l",  #line plot
     ylim=c(0,39),
     pty="m",
     cex.lab=0.9,
     cex.axis=0.8
);
#add a green line plot of sub metering 1, of width 5; could not determine
#what color the wide plot line was, so I set green.
lines(x=dt$datetime,
      y=dt$Sub_metering_1,
      col="green",
      lwd=3
);
#add a black over-plot of sub metering 1, of width 1, as it appears from the
#graphic delivered in the repo and assignment.
lines(x=dt$datetime,
      y=dt$Sub_metering_1,
      col="black"
);
#add a red over-plot of sub metering 2, of width 1, as it appears from the
#graphic delivered in the repo and assignment.
lines(x=dt$datetime,
     y=dt$Sub_metering_2,
     col="red"
);
#add a blue over-plot of sub metering 3, of width 1, as it appears from the
#graphic delivered in the repo and assignment.
lines(x=dt$datetime,
     y=dt$Sub_metering_3,
     col="blue"
);
#set the scale and ticks on the y axis
axis(side=2, at=seq(from=0, to=30, by=10));
#add a legend
legend("topright",
       legend=colnames(dt)[5:7],
       lty=1,
       col=c("black","red","blue"));
#and close the graphics device
dev.off()

