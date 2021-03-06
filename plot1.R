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

# closing the db connection
dbDisconnect(conn)

# Initialize a graphics device for the png file
png(file = "plot1.png", width = 480, height = 480)

# Costruct the plot
hist(data$Global_active_power, main = "Global Active Power", xlab= "Global Active Power(Kilowatts)", col = "red")

#Closing the graphics device 
dev.off()