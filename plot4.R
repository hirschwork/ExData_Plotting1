###  # get the zip file
fileUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
download.file(fileUrl, destfile="exdata-data-household_power_consumption.zip")

# unzip the file
unzip("./exdata-data-household_power_consumption.zip")

#read in the file
bigDS <- read.csv("household_power_consumption.txt", na.strings="?", sep=";", 
                  colClasses=c("character", "character","numeric","numeric",
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
png(filename="plot4.png")

# set up the multiple outputs
par(mfrow=c(2,2))

# top left - global active power
plot(myDS$dt, myDS$Global_active_power, type="l", ylab="Global Active Power", xlab="", xaxt="n")
axis.POSIXct(1, at=(seq(min(as.Date(myDS$Date,"%d/%m/%Y")), max(as.Date(myDS$Date,"%d/%m/%Y"))+1, "days" )), format="%a")

# top right - voltage
plot(myDS$dt,myDS$Voltage, type="l", xaxt="n", xlab="datetime", ylab="Voltage")
axis.POSIXct(1, at=(seq(min(as.Date(myDS$Date,"%d/%m/%Y")), max(as.Date(myDS$Date,"%d/%m/%Y"))+1, "days" )), format="%a")

# bottom left - energy sub metering
# create the chart (with first sub metering level)
plot(myDS$dt,myDS$Sub_metering_1, type="l", xaxt="n", ylab="Energy sub metering", xlab="")
#    add in other sub metering levels
lines(myDS$dt, myDS$Sub_metering_2, type="l", col="red")
lines(myDS$dt, myDS$Sub_metering_3, type="l", col="blue")
legend("topright", lty=1, bty="n", names(myDS[7:9]), col=c("black","red","blue"))
axis.POSIXct(1, at=(seq(min(as.Date(myDS$Date,"%d/%m/%Y")), max(as.Date(myDS$Date,"%d/%m/%Y"))+1, "days" )), format="%a")

# bottom right - global reactive power
plot(myDS$dt,myDS$Global_reactive_power, type="l", xaxt="n", xlab="datetime", ylab="Global_reactive_power")
axis.POSIXct(1, at=(seq(min(as.Date(myDS$Date,"%d/%m/%Y")), max(as.Date(myDS$Date,"%d/%m/%Y"))+1, "days" )), format="%a")


#don't forget to close the output device
dev.off()
