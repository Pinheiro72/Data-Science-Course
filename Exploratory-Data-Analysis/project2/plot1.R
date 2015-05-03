# import data
NEI <- readRDS("data/summarySCC_PM25.rds")
SCC <- readRDS("data/Source_Classification_Code.rds")

# data summarizing
temp <- aggregate(NEI$Emissions, by=list(NEI$year), FUN=sum)

# create and export plot 1 from project 2 assignment
png("plot1.png", width=480, height=480)
barplot(temp$x/1000000, names.arg=temp$Group.1, border=NA, ylim=c(0,8), col="darkgrey", xlab="Year", ylab="PM2.5 emissions (million of tons)", main="Total emissions of PM2.5 in the United States", family="mono")
text(c(0.7, 1.9, 3.1, 4.3), temp$x/1000000 + 0.5, round(temp$x/1000000, 1), cex=1.2, family="mono") 
dev.off()