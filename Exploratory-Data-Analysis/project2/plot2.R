# import data
NEI <- readRDS("data/summarySCC_PM25.rds")
SCC <- readRDS("data/Source_Classification_Code.rds")

# data summarizing
temp <- aggregate(NEI[NEI$fips=="24510", "Emissions"], by=list(NEI[NEI$fips=="24510", "year"]), FUN=sum)

# create and export plot 2 from project 2 assignment
png("plot2.png", width=480, height=480)
barplot(temp$x, names.arg=temp$Group.1, border=NA, ylim=c(0,4000), col="darkgrey", xlab="Year", ylab="PM2.5 emissions (tons)", main="Total emissions of PM2.5 in Baltimore City", family="mono")
text(c(0.7, 1.9, 3.1, 4.3), temp$x + max(temp$x) * 0.08, round(temp$x, 1), cex=1.2, family="mono") 
dev.off()