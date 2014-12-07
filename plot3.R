# Clean up workspace

rm(list=ls())

# Create and set working directory

# Download zip file and extract dataset

dir.create("./ExData_016_Plotting1")
setwd("./ExData_016_Plotting1")

# Download zip file and extract dataset

fileUrl<-"https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
download.file(fileUrl,destfile="household_power_consumption.zip")
unzip("household_power_consumption.zip", files = NULL, list = FALSE, overwrite = TRUE, junkpaths = FALSE, exdir = ".", unzip = "internal", setTimes = FALSE)

#Subset out the only two days we need data from.  Method taken from Alexander Vikulin's post in this thread https://class.coursera.org/exdata-016/forum/thread?thread_id=14

library(data.table)
cmd <- 'findstr /b /c:"1/2/2007" /c:"2/2/2007" /c:"Date;" household_power_consumption.txt'
t <- paste0(system(cmd, intern = T), collapse = "\n")
pow <- fread(t, sep = ";", header = T, na.strings = '?')

# Combine Date and Time columns, format them using strptime, add them back to the dataset and remove the old versions

Date.Time <- data.frame("Date.Time" = paste(pow$Date, pow$Time, sep = " "))
Date.Time$Date.Time <- strptime(Date.Time$Date.Time, format = "%d/%m/%Y %H:%M:%S")
power <- cbind(Date.Time, pow)
power <- subset(power, select = -c(2,3) )

# Create a line plot from the dataset displaying Energy sub metering 1-3


plot(power$Date.Time,power$Sub_metering_1,ylab="Energy sub metering",xlab="",type="l",col="black")
lines(power$Date.Time,power$Sub_metering_2, type="l", col="red")
lines(power$Date.Time,power$Sub_metering_3, type="l", col="blue")
legend("topright", lty = 1, col = c("black", "red", "blue"), legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))

# create a PNG file of the plot

dev.copy(png, file = "plot3.png",width=480,height=480)
dev.off()

# Have a nice day
# Stay gold