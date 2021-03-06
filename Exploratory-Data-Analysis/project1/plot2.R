# import data
temp <- read.table("./data/household_power_consumption.txt", header=TRUE, sep=";", dec=".", colClasses=c("character", "character", rep("numeric", 7)), na.strings="?")

# transform data
temp$Date <- as.Date(temp$Date, format="%d/%m/%Y")
df_prj1 <- temp[temp$Date=="2007-02-01" | temp$Date=="2007-02-02", ]
rm(temp)
df_prj1$DateTime <- strptime(paste(df_prj1$Date, df_prj1$Time), "%Y-%m-%d %H:%M:%S")
rownames(df_prj1) <- 1:nrow(df_prj1)

# create and export plot 2 from project 1 assignment
png("plot2.png", width=480, height=480)
plot(df_prj1$DateTime, df_prj1$Global_active_power, type="l", xlab="", ylab="Global Active Power (kilowatts)", family="mono")
dev.off()

# The week on the x-axis is it in Portuguese and I didn't find a way to transform it in English, the only possibilty was through the text function, which seems to be too forced