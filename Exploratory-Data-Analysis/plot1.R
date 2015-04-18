# import data
temp <- read.table("./data/household_power_consumption.txt", header=TRUE, sep=";", dec=".", colClasses=c("character", "character", rep("numeric", 7)), na.strings="?")

# transform data
temp$Date <- as.Date(temp$Date, format="%d/%m/%Y")
df_prj1 <- temp[temp$Date=="2007-02-01" | temp$Date=="2007-02-02", ]
rm(temp)
df_prj1$DateTime <- strptime(paste(df_prj1$Date, df_prj1$Time), "%Y-%m-%d %H:%M:%S")
rownames(df_prj1) <- 1:nrow(df_prj1)

# create and export plot 1 from project 1 assignment
png("plot1.png", width=480, height=480)
hist(df_prj1$Global_active_power, col="red", xlab="Global Active Power (kilowatts)", main="Global Active Power", family="mono")
dev.off()