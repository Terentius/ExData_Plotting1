# Peer Assessments /Course Project 1
# ExData_Plotting1
#
# plot3.R script produces from the dataset "Electric power consumption" a
# multiple overlayed base plot as one single plot and write it in file
# "plot3.png".
# plot3.R uses on y-axis "Engery sub metering" of all three variables
# Sub_merting_1, Sub_merting_2 and Sub_merting_3.
# plot3.R uses on x-axis the corresponding values of "Date" and "Time" as one
# POSIXct Date variable with variable name "dateandtime"
#
# SHA1-hash "ed8175f252f08010c50486f78bf306748670c200 *plot3.png"
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
png(filename = "plot3.png",
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

# Producing the plot from variables Sub_metering_1, Sub_metering_2 and
# Sub_metering_3 on y-axis to variable dateandtime on x-axis
with(dataset, {
        plot(dateandtime, Sub_metering_1, type="n",
             ylab="Energy sub metering",xlab= "")
        lines(dateandtime, Sub_metering_1, type="l", col="black")
        lines(dateandtime, Sub_metering_2, type="l", col="red")
        lines(dateandtime, Sub_metering_3, type="l", col="blue")
        legend("topright", lty=1, col=c("black","blue","red"),
               legend = c("Sub_metering_1","Sub_metering_2","Sub_metering_3"))})

Sys.setlocale(locale = "") 

# Close the device opened above
dev.off()

# Removing data.frame "dataset" and
# function "read.dataset" from environment
rm(dataset,read.dataset)
