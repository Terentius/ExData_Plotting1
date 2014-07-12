# Exploratory Data Analysis-004
# Peer Assessments /Course Project 1
# ExData_Plotting1
#
# plot1.R script produces from the dataset "Electric power consumption" a
# histogram in the file "plot1.png" of the data "Global Active Power"
#
# SHA1-hash "9706eec78829cea080e4f7dc25d5d1158baee77f *plot1.png"
#
# Some requirements are needed:
# * library sqldf
# * Dataset "Electric power consumption" from "UC Irvine Machine Learning 
#   Repository" at http://archive.ics.uci.edu/ml/  
#   The file-name is "household_power_consumption.zip" 

read.dataset <- function() {
        zip.filename <- "./household_power_consumption.zip"
        txt.filename <- "./household_power_consumption.txt"
        if (!file.exists(txt.filename)) {
                if (!file.exists(zip.filename)) {
                        download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip",
                                      destfile="household_power_consumption.zip",
                                      method="curl")
                        if (file.exists(zip.filename)) {
                                unzip(zip.filename)     
                        } else {stop("dataset missing")}
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
png(filename = "plot1.png",
    width = 480,
    height = 480,
    units = "px",
    pointsize = 12,
    # I noticed the transparent background from task-setting,
    # but I chose to make it white for an easier evaluation of the viewer.
    bg = "white",
    res = NA,
    type = c("cairo", "cairo-png", "Xlib", "quartz"))

# Producing histogram with title, label for x-axis and
# red color for filled bars
with(dataset,
     hist(Global_active_power,
          main="Global Active Power",
          xlab="Global Active Power (kilowatts)",
          col="red",
          border="black"))

# Close the device opened above
dev.off()

# Removing data.frame "dataset" and
# function "read.dataset" from environment
rm(dataset,read.dataset)

