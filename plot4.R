# Peer Assessments /Course Project 1
# ExData_Plotting1
#
# plot4.R script produces from the dataset "Electric power consumption"
# multiple overlayed base plots as one single plot and write it in file
# "plot4.png".
#
# SHA1-hash "f0bc9679c742f2384bbe1eb07f271d2a5aa204aa *plot4.png"
#
# Some requirements are needed:
# * library sqldf
# * Dataset "Electric power consumption" from "UC Irvine Machine Learning 
#   Repository" at http://archive.ics.uci.edu/ml/  
#   The file-name is "household_power_consumption.zip" 
#
# Hint:
# I "turned off" and "turned on" locale-specific settings
#   # Sys.setlocale(category = "LC_TIME", locale = "C")
#   # Sys.setlocale(locale = "") 
#


read.dataset <- function() {
        zip.filename <- "./household_power_consumption.zip"
        txt.filename <- "./household_power_consumption.txt"
        if (!file.exists(txt.filename)) {
                if (!file.exists(zip.filename)) {
                        download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip",
                                      destfile="household_power_consumption.zip",
                                      method="curl")
                        unzip(zip.filename)
                } else {
                        unzip(zip.filename)
                }
        }        
        
        # need library sqldf for function read.csv.sql
        require(sqldf)
        dataset<-read.csv.sql(file=txt.filename,
                              sql="select * from file where Date = '2/2/2007' OR Date='1/2/2007'",
                              sep=";",
                              header=TRUE,
                              colClasses=c("character",
                                           "character",
                                           "numeric",
                                           "numeric",
                                           "numeric",
                                           "numeric",
                                           "numeric",
                                           "numeric",
                                           "numeric")
        )
        
        dateandtime <- as.POSIXct(paste(dataset$Date,dataset$Time),
                                  format="%d/%m/%Y %H:%M:%S")
        dataset <- cbind(dataset,dateandtime)
}

# Reading the selected dataset
dataset <- read.dataset()

# Construct the plot and save it to a PNG file with a
# width of 480 pixels and a height of 480 pixels.
# The PNG file will be saved in the current directory.
png(filename = "plot4.png",
    width = 480,
    height = 480,
    units = "px",
    pointsize = 12,
    # I noticed the transparent background from task-setting,
    # but I chose to make it white for an easier evaluation of the viewer.
    bg = "white",
    res = NA,
    type = c("cairo", "cairo-png", "Xlib", "quartz"))


Sys.setlocale(category = "LC_TIME", locale = "C")


# Preparing multiple base plots column wise ordered
par(mfcol=c(2,2))

# Producing four plots in context of data.frame "dataset"
with(dataset, {
        # Producing a line plot of "Global Active Power" on y-axis and
        # on the x-axis the corresponding time value of dataset$dateandtime.
        # The label on the x-axis will be automatically set by plot function
        plot(dateandtime,
             Global_active_power,
             type="l",
             ylab="Global Active Power",
             xlab= "")
    
        
        # Producing the plot from variables Sub_metering_1, Sub_metering_2 and
        # Sub_metering_3 on y-axis to variable dateandtime on x-axis
        plot(dateandtime, Sub_metering_1, type="n",
             ylab="Energy sub metering",xlab= "")
        
        lines(dateandtime, Sub_metering_1, type="l", col="black")
        lines(dateandtime, Sub_metering_2, type="l", col="red")
        lines(dateandtime, Sub_metering_3, type="l", col="blue")
        
        legend("topright", lty=1, col=c("black","blue","red"), bty = "n",
               legend = c("Sub_metering_1","Sub_metering_2","Sub_metering_3"))
   
        
        # Producing a line plot of "Voltage" on y-axis and
        # on the x-axis the corresponding time value of dataset$dateandtime.
        # The label on the x-axis will be automatically set by plot function
        plot(dateandtime,
             Voltage,
             type="l",
             xlab = "datetime")
  
        
        # Producing a line plot of "Global_reactive_power" on y-axis and
        # on the x-axis the corresponding time value of dataset$dateandtime.
        # The label on the x-axis will be automatically set by plot function
        plot(dateandtime,
             Global_reactive_power,
             type="l",
             xlab="datetime")})


Sys.setlocale(locale = "") 

# Close the device opened above
dev.off()

# Removing data.frame "dataset" and
# function "read.dataset" from environment
rm(dataset,read.dataset)
