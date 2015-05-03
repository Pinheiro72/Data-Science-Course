# import data
NEI <- readRDS("data/summarySCC_PM25.rds")
SCC <- readRDS("data/Source_Classification_Code.rds")

# data summarizing
temp <- NEI[NEI$fips=="24510", ]
temp$type <- as.factor(temp$type)
temp$year <- as.factor(temp$year)

library(ggplot2)     

# create and export plot 3 from project 2 assignment
png("plot3.png", width=480, height=480)
g <- ggplot(temp, aes(year, Emissions))
g + geom_histogram(stat="identity", fill="steelblue") + labs(x="Year", y="PM2.5 emissions (tons)", title="Total emissions of PM2.5 in Baltimore City by source") + facet_grid(.~type)
dev.off()