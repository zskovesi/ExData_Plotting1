#Download full zipped data, unzip, save source file, remove zip file

file.url <- 'https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip'
file.dest <- 'power.consumption.zip'
download.file( file.url, file.dest )
source.file <- unzip( file.dest, list = TRUE )$Name
unzip( file.dest )
file.remove( file.dest )
rm(file.url)
rm(file.dest)

##Before loading dataset to R, rough estimate of the memory requirements (suppose numeric data): 2,075,259 rows and 9 columns.
##2M * 9 * 8 bytes / 1M ~ 142 MB. I can get the full dataset, it will download ca. 20 MBs.

## Get the full dataset

data_full <- read.csv("./household_power_consumption.txt", header=T, sep=';', na.strings="?", 
nrows=2075259, check.names=F, stringsAsFactors=F, comment.char="", quote='\"')
data_full$Date <- as.Date(data_full$Date, format="%d/%m/%Y")

## Subset the data

data <- subset(data_full, subset=(Date >= "2007-02-01" & Date <= "2007-02-02"))
rm(data_full)

## Converting dates

datetime <- paste(as.Date(data$Date), data$Time)
data$Datetime <- as.POSIXct(datetime)

## Create plot4

par(mfrow=c(2,2), mar=c(4,4,1,1), oma=c(0,0,0.5,0))

# plot1
plot(data$Datetime, data$Global_active_power, type = "l", ylab = "Global Active Power", 
     xlab = "")

# plot2
plot(data$Datetime, data$Voltage, type = "l", ylab = "Voltage", xlab = "datetime")

# plot3
plot(data$Datetime, data$Sub_metering_1, type = "l", ylab = "Energy sub metering", 
     xlab = "", col = "black")
points(data$Datetime, data$Sub_metering_2, type = "l", xlab = "", ylab = "Sub_metering_2", 
       col = "red")
points(data$Datetime, data$Sub_metering_3, type = "l", xlab = "", ylab = "Sub_metering_3", 
       col = "blue")
legend("topright", col=c("black", "red", "blue"), lty=c(1,1,1), lwd=c(2.5,2.5,2.5), pch=21, pt.cex=1, cex=0.7, bty="n",
       legend=c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))

# plot4
plot(data$Datetime, data$Global_reactive_power, type = "l", xlab = "datetime", 
     ylab = "Global_reactive_power", ylim = c(0, 0.5))


## Size and save to file

dev.copy(png, file="plot4.png", height=480, width=480, units = "px")
dev.off()