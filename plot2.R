# Peer Assessments /Course Project 1
# ExData_Plotting1
#
# plot2.R script writes a plot in file "plot2.png" in the current
# directory from the dataset "Electric power consumption".
# The plot uses the variable "Global Active Power" and the combined variable
# "Date" with "Time".
# The y-Axis uses "Global Active Power" and the x-Axis uses "dateandtime"
#
# SHA1-hash "01a798c2ed39b830447c85163ed83135543046b8 *plot2.png"
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
png(filename = "plot2.png",
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

# Producing a line plot of "Global Active Power" on y-axis and
# on the x-axis the corresponding time value of dataset$dateandtime.
# The label on the x-axis will be automatically set by plot function
with(dataset,
     plot(dateandtime,
          Global_active_power,
          type="l",
          ylab="Global Active Power (kilowatts)",
          xlab= ""))

Sys.setlocale(locale = "") 

# Close the device opened above
dev.off()

# Removing data.frame "dataset" and
# function "read.dataset" from environment
rm(dataset,read.dataset)
