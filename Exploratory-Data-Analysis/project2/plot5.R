# import data
NEI <- readRDS("data/summarySCC_PM25.rds")
SCC <- readRDS("data/Source_Classification_Code.rds")

# data summarizing
temp <- merge(NEI[fips=="24510", ], SCC[substr(SCC$EI.Sector, 1, 16)=="Mobile - On-Road", c("SCC", "EI.Sector")], by="SCC")
temp$EI.Sector <- substr(temp$EI.Sector, 18, 50)
temp$year <- as.factor(temp$year)

library(ggplot2)

# create and export plot 5 from project 2 assignment
png("plot5.png", width=480, height=480)
g <- ggplot(temp, aes(year, Emissions))
g + geom_histogram(stat="identity", fill="steelblue") + labs(x="Year", y="PM2.5 emissions (tons)", title="Total emissions of PM2.5 in Baltimore City \n by motor vehicle sources")
dev.off()