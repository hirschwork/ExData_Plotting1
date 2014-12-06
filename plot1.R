###  # get the zip file
fileUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
download.file(fileUrl, destfile="exdata-data-household_power_consumption.zip")

# unzip the file
unzip("./exdata-data-household_power_consumption.zip")

#read in the file
bigDS <- read.csv("household_power_consumption.txt", na.strings="?", sep=";", colClasses=c("character", "character","numeric","numeric",
                                                                                           "numeric","numeric","numeric","numeric","numeric"))
# Only use the required data for two days
DS1 <- subset(bigDS, bigDS$Date=="1/2/2007")
DS2 <- subset(bigDS, bigDS$Date=="2/2/2007")

# concatenate
myDS <- DS1
myDS <- rbind(myDS, DS2)

# convert character date and time fields into a single Date field and add to data frame
dt <- strptime(paste(myDS$Date, myDS$Time), "%d/%m/%Y %H:%M:%S")
myDS <- cbind(myDS, dt)

# write it out as PNG file
png('plot1.png')

# create the histogram
hist(myDS$Global_active_power, main="Global Active Power", xlab="Global Active Power (kilowatts)", ylab="Frequency", col="red")

#don't forget to close the output device
dev.off()
