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

## Convert dates

datetime <- paste(as.Date(data$Date), data$Time)
data$Datetime <- as.POSIXct(datetime)

## Create plot2

plot(data$Global_active_power~data$Datetime, type="l",
ylab="Global Active Power (kilowatts)", xlab="")

## Size and save to file
dev.copy(png, file="plot2.png", height=480, width=480)
dev.off()



