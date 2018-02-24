# Loading the necessary Libraries
library(RSQLite)

# Downloading file if it does not exist
file_name <- "exdata%2Fdata%2Fhousehold_power_consumption.zip"
if(!file.exists(file_name)) {
  url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
  download.file(url, destfile = file_name)
}

if(!file.exists("./household_power_consumption.txt")){
  unzip(file_name) 
}

# use a sql connection to subset the Date for entries between February 1st and 2nd, 2007
conn <- dbConnect(SQLite(), dbname = "sample_db.sqlite")
dbWriteTable(conn, name="sample_table", value="household_power_consumption.txt", 
             row.names=FALSE, header=TRUE, sep = ";")
data <- dbGetQuery(conn, "SELECT * FROM sample_table WHERE [Date] == '1/2/2007'or [Date] == '2/2/2007' ")

# Closing the db connection
dbDisconnect(conn)

# Formatting the Date and Time object 
datetime <- strptime(paste(data$Date, data$Time, sep=" "), "%d/%m/%Y %H:%M:%S") 

# Initialize a graphics device for the png file
png(file = "plot4.png", width = 480, height = 480)

# Setting the mfrow to 2 rows and 2 collumns
par(mfrow = c(2,2))

# Costruct the plot
plot(datetime, data$Global_active_power, xlab = "", ylab = "Global Active Power (Killowatts)", type = "l")
plot(datetime, data$Voltage , xlab= "datetime", ylab = "Voltage", type = "l")
plot(datetime, data$Sub_metering_1, type = "l", xlab = "", ylab = "Energy sub metering")
lines(datetime, data$Sub_metering_2, type = "l", col = "red")
lines(datetime, data$Sub_metering_3, type = "l", col = "blue")
legend("topright", lty = 1, col = c("black", "red", "blue"), legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))
plot(datetime, data$Global_reactive_power , xlab = "datetime", ylab = "Global_reactive_power", type = "l")

#Closing the graphics device 
dev.off()