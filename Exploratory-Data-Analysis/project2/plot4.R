# import data
NEI <- readRDS("data/summarySCC_PM25.rds")
SCC <- readRDS("data/Source_Classification_Code.rds")
fips <- read.table("data/national_county.txt", sep=",", colClasses=rep("character", 5), col.names=c("state", "statefp", "countyfp", "countyname", "classfp"), quote="\"")                         
states <- read.table("data/national_states.txt", sep="\t", colClasses=rep("character", 2), col.names=c("state", "statename"))  

# data summarizing
daux <- merge(NEI, SCC[SCC$EI.Sector=="Fuel Comb - Comm/Institutional - Coal" | SCC$EI.Sector=="Fuel Comb - Electric Generation - Coal" | SCC$EI.Sector=="Fuel Comb - Industrial Boilers, ICEs - Coal", c("SCC", "EI.Sector")], by="SCC")

fips$fips <- paste(fips$statefp, fips$countyfp, sep="")
daux <- merge(daux, fips[ , c("state", "fips")], by="fips")

temp2 <- aggregate(daux$Emissions, by=list(daux$year, daux$fips), FUN=sum)
# define a sequential period
for(i in unique(temp2$Group.2)){temp2[temp2$Group.2==i, "ID"] <- 1:nrow(temp2[temp2$Group.2==i, ])}

# calculate the total and yearly average growth emissions
temp3 <- temp2[temp2$ID>1, ]
temp3$ID <- temp3$ID-1 # to merge an period with the previous one
temp4 <- merge(temp2[temp2$ID<4, ], temp3, by=c("Group.2", "ID"))
# assuming a constant rate across measured years
temp4$emissions_growth <- as.numeric((temp4$x.y - temp4$x.x) / (temp4$x.x * (temp4$Group.1.y - temp4$Group.1.x)))
temp4[is.nan(temp4$emissions_growth)==TRUE, "emissions_growth"] <- 0
# from 0 it's assumed an 33% yearly growth
temp4[temp4$emissions_growth==Inf, "emissions_growth"] <- 1 / (temp4[temp4$emissions_growth==Inf, "Group.1.y"] - temp4[temp4$emissions_growth==Inf, "Group.1.x"])
# emissions yearly average growth by county
temp_fips <- aggregate(temp4$emissions_growth, by=list(temp4$Group.2), FUN=mean)
# joining the total emissions by county
temp_fips <- merge(temp_fips, aggregate(temp$Emissions, by=list(temp$fips), FUN=sum), by="Group.1")
names(temp_fips) <- c("fips", "Emissions Growth", "Emissions") 
rm(i, temp2, temp3, temp4)

# mapping the total and yearly average growth emissions
library(ggplot2)
library(maps)
library(RColorBrewer)     

# defining the mapping classes
class1 <- c(-10, -5, 0, 5, 10, 50, max(temp_fips[ , "Emissions Growth"]))
class2 <- c(1, 5, 10, 50, 100, 500, max(temp_fips[ , "Emissions"])) 
for(i in 7:1){
  temp_fips[temp_fips[ , "Emissions Growth"] <= class1[i]/100, "Emissions Growth Class"] <- brewer.pal(7, "RdYlGn")[8-i]
  temp_fips[temp_fips[ , "Emissions"] <= class2[i] , "Emissions Class"] <- brewer.pal(7, "OrRd")[i]
}

fips <- merge(fips, states, by="state", all.x=TRUE)
# make names compatible between sources
idx <- NULL
temp <- gregexpr("County|Parish", fips$countyname)
for(i in 1:nrow(fips)){idx[i] <- temp[[i]][1] - 2}
fips$names <- paste(tolower(fips$statename), ",", tolower(substr(fips$countyname, 1, idx)), sep="")
fips[fips$state=="DC", "names"] <- "district of columbia,washington"
idy <- grep("[Cc]ity", fips$countyname) 
fips[idy, "names"] <- paste(tolower(fips[idy, "statename"]), ",", tolower(fips[idy, "countyname"]), sep="")
idy <- grep("DeKalb|DeWitt|DeSoto|DuPage", fips$countyname)
fips[idy, "names"] <- paste(tolower(fips[idy, "statename"]), ",", tolower(substr(fips[idy, "countyname"], 1, 2)), " ", tolower(substr(fips[idy, "countyname"], 3, 6)), sep="")
idy <- grep("LaSalle|LaPorte|LaMoure", fips$countyname)
fips[idy, "names"] <- paste(tolower(fips[idy, "statename"]), ",la ", tolower(substr(fips[idy, "countyname"], 3, 7)), sep="")
idy <- grep("St\\.", fips$countyname)
fips[idy, "names"] <- paste(tolower(fips[idy, "statename"]), ",st ", tolower(substr(fips[idy, "countyname"], 5, idx[idy])), sep="")
# counties not mapped
fips[fips$state %in% c("AK", "AS", "GU", "HI", "MP", "PR", "UM", "VI"), "names"] <- ""

temp <- data.frame(names=map(database="county")$names, ord=1:length(map(database="county")$names))
temp <- merge(temp, fips[ , c("fips", "names")], by="names", all.x=TRUE)
# correct last names differences between sources
temp[temp$names %in% c("florida,okaloosa:main", "florida,okaloosa:spit"), "fips"] <- "12091"
temp[temp$names %in% c("louisiana,st martin:north", "louisiana,st martin:south"), "fips"] <- "22099"
temp[temp$names %in% c("north carolina,currituck:knotts", "north carolina,currituck:main", "north carolina,currituck:spit"), "fips"] <- "37053"
temp[temp$names %in% c("texas,galveston:main", "texas,galveston:spit"), "fips"] <- "48167"
temp[temp$names %in% c("virginia,accomack:main", "virginia,accomack:chincoteague"), "fips"] <- "51001"
temp[temp$names %in% c("washington,pierce:main", "washington,pierce:penrose"), "fips"] <- "53053"
temp[temp$names %in% c("washington,san juan:lopez island", "washington,san juan:orcas island", "washington,san juan:san juan island"), "fips"] <- "53055"
temp <- merge(temp, temp_fips, by="fips", all.x=TRUE)
temp <- temp[order(temp$ord), ]
temp[is.na(temp$fips)==TRUE, ]
table(is.na(temp$fips))
#fips[fips$names=="washington,san juan", "fips"]

# total emissions on US
temp2 <- aggregate(daux$Emissions, by=list(daux$year), FUN=sum)

# create and export plot 4 from project 2 assignment
png("plot4.png", width=480, height=480)
layout(matrix(c(1,2,3,4), 2, 2, byrow = TRUE))
par(cex.main=0.8, xpd=TRUE)

plot.new()
text(0.4, 0.5, "Emissions of PM2.5 in USA \n from coal \n combustion-related sources on \n 1999, 2002, 2005 and 2008", cex=1, family="mono")

par(mar=c(1,0,2,0))
barplot(temp2$x/10^6, names.arg=temp2$Group.1, border=NA, ylim=c(0,1), col="darkgrey", xlab="Year", ylab="PM2.5 emissions (million of tons)", main="Total emissions(tons) by year", family="mono")
text(c(0.7, 1.9, 3.1, 4.3), temp2$x/10^6 + max(temp2$x/10^6) * 0.08, round(temp2$x/10^6, 2), cex=1, family="mono")

par(mar=c(0,0,2,0))
map(database="county", lty=0, fill=TRUE, col=temp[ , "Emissions Growth Class"])
title("Yearly average emissions growth by county", family="mono")
legend("bottomright", legend=c(paste("<=", class1[1:6], "%"), paste(">", class1[6], "%")), fill=brewer.pal(7, "RdYlGn")[7:1], box.lty=0, bg=NA, cex=0.7)

map(database="county", lty=0, fill=TRUE, col=temp[ , "Emissions Class"])
title("Total emissions (tons) by county", family="mono")              
legend("bottomright", legend=c(paste("<=", class2[1:6]), paste(">", class2[6])), fill=brewer.pal(7, "OrRd"), box.lty=0, bg=NA, cex=0.7)
dev.off()
rm(daux, class1, class2, temp, temp2, idx, idy, i)