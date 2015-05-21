---
title: "Reproducible research course assignment 1"
output: html_document
author: Pinheiro, Jorge
date: 2015, 15th of May
---

### Abstract
It is now possible to collect a large amount of data about personal movement using activity monitoring devices. These type of devices are part of the "quantified self" movement - a group of enthusiasts who take measurements about themselves regularly to improve their health, to find patterns in their behavior, or because they are tech geeks.

---

### Index
- Introduction
- Descriptive analysis

---

## Introduction
This analysis aims to give a superficial view of a person's activity beahviour under the assignment scope of the  Reproducible Reserach online Course from May'15. For this goal, it was used data from a device, that collects data at 5 minute intervals through out the day. The data consists of two months of data from an anonymous individual collected during the months of October and November, 2012 and include the number of steps taken in 5 minute intervals each day. The data can be obtain on the [assignment page](https://d396qusza40orc.cloudfront.net/repdata%2Fdata%2Factivity.zip).  

## Descriptive analysis

```r
activity = read.csv("./data/activity.csv")
totalSteps = aggregate(activity$steps, by=list(activity$date), FUN=sum, na.rm=TRUE)
```
In average the studied individual makes 9354 steps each day. This mean it's likely biased due to days reporting zero steps, which indicates that the data on those days were incorrectly collected.  

```r
library(ggplot2)
g = ggplot(totalSteps, aes(as.Date(Group.1), x), cex=0.7)
g + geom_histogram(stat="identity", fill="steelblue") + labs(x="Day", y="Number of steps", title="Total steps made by day") + geom_hline(aes(yintercept=mean(x)), color="darkred") + annotate("text", x=as.Date(totalSteps$Group.1)[3], y=mean(totalSteps$x)*1.05, label="mean", cex=3) + geom_hline(aes(yintercept=median(x)), color="darkgreen") + annotate("text", x=as.Date(totalSteps$Group.1)[3], y=median(totalSteps$x)*1.05, label="median", cex=3)
```

![plot of chunk unnamed-chunk-2](figure/unnamed-chunk-2-1.png) 
  

```r
# create a time frame for the data set
time = strsplit(as.character(activity$interval), "")
timeFrame = NULL
for(i in 1:length(time)){
      if(length(time[[i]])==1){
            timeFrame[i] = as.character(paste(activity[i, "date"], " 00:0", time[[i]][1], sep="")) 
      }else if(length(time[[i]])==2){
            timeFrame[i] = as.character(paste(activity[i, "date"], " 00:", time[[i]][1], time[[i]][2], sep=""))
      }else if(length(time[[i]])==3){
            timeFrame[i] = as.character(paste(activity[i, "date"], " 0", time[[i]][1], ":", time[[i]][2], time[[i]][3], sep=""))
      }else{
            timeFrame[i] = as.character(paste(activity[i, "date"], " ", time[[i]][1], time[[i]][2], ":", time[[i]][3], time[[i]][4], sep=""))
      }
      
}
timeFrame = strptime(timeFrame, format="%Y-%m-%d %H:%M")
```

```r
g = ggplot(activity, aes(timeFrame, steps), cex=0.7)
g + geom_line(color="steelblue") + geom_hline(aes(yintercept=mean(steps, na.rm=TRUE)), color="darkred") + labs(x="5 minutes period", y="Number of steps", title="Daily steps pattern") + annotate("text", x=timeFrame[3], y=mean(activity$steps, na.rm=TRUE)*1.2, label="mean", cex=3)
```

![plot of chunk unnamed-chunk-4](figure/unnamed-chunk-4-1.png) 

On average the individual usually makes more steps at 8:35 a.m.  

```r
maxSteps = aggregate(activity$steps, by=list(activity$interval), FUN=mean, na.rm=TRUE)
maxSteps[which.max(maxSteps$x), ]
```

```
##     Group.1        x
## 104     835 206.1698
```
The dataset contains 2304 missing values. To address this issue it was imputed the 5-minute interval mean to guarantee that the daily pattern isn't changed.  

```r
activity2 = merge(activity, aggregate(activity$steps, by=list(activity$interval), FUN=mean, na.rm=TRUE), by.x="interval", by.y="Group.1", all.x=TRUE)
names(activity2)[match("x", names(activity2))] = "interval_mean"
activity2[is.na(activity2$steps)==TRUE, "steps"] = round(activity2[is.na(activity2$steps)==TRUE, "interval_mean"], 0)
activity2 = activity2[order(activity2$date, activity2$interval), ]
totalSteps2 = aggregate(activity2$steps, by=list(activity2$date), FUN=sum, na.rm=TRUE)
```
After the missing value imputation, in average it's estimated that the studied individual makes 10766 steps each day and the median is 10762. Therefore, the data processing by imputing the 5-minute interval mean had increased the original mean and median.  

```r
g = ggplot(totalSteps2, aes(as.Date(Group.1), x), cex=0.7)
g + geom_histogram(stat="identity", fill="steelblue") + labs(x="Day", y="Number of steps", title="Total steps made by day") + geom_hline(aes(yintercept=mean(x)), color="darkred") + annotate("text", x=as.Date(totalSteps2$Group.1)[3], y=mean(totalSteps2$x)*1.08, label="mean", cex=3) + geom_hline(aes(yintercept=median(x)), color="darkgreen") + annotate("text", x=as.Date(totalSteps2$Group.1)[3], y=median(totalSteps2$x)*1.05, label="median", cex=3)
```

![plot of chunk unnamed-chunk-7](figure/unnamed-chunk-7-1.png) 

As we can verify the studied individual makes more steps on the weekends.  

```r
# crate the weekday variabe
activity$weekday = ifelse(as.factor(weekdays(as.Date(activity$date))) %in% c("s�bado", "domingo"), "weekend", "weekday") # the weekdays are written in portuguese, if needed change to your own language
# create a mean by weekday
weekSteps = aggregate(activity$steps, by=list(activity$weekday), FUN=mean, na.rm=TRUE)
names(weekSteps) = c("weekday", "steps")
```

```r
g = ggplot(activity, aes(timeFrame, steps), cex=0.7)
g + geom_line(color="steelblue") + labs(x="5 minutes period", y="Number of steps", title="Daily steps pattern") + geom_hline(aes(yintercept=steps), weekSteps, color="darkred") + facet_grid(.~weekday)
```

![plot of chunk unnamed-chunk-9](figure/unnamed-chunk-9-1.png) 