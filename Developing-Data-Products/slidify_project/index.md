---
title       : Slidify Assignment
subtitle    : 
author      : Jorge Pinheiro
job         : 
framework   : io2012        # {io2012, html5slides, shower, dzslides, ...}
logo        : Logo_small.png
highlighter : highlight.js  # {highlight.js, prettify, highlight}
hitheme     : tomorrow      # 
widgets     : []            # {mathjax, quiz, bootstrap}
mode        : selfcontained # {standalone, draft}
knit        : slidify::knit2slides
---

{{{ content }}}
<footer class = 'logo_small'>
  <table><tr style="background-color:#FFFFFF"><td><img src = './assets/img/Logo_small.png' width="120" height="60"></img></td><td style="vertical-align:middle"><p align="left">Developing Data Projects Slidify Assignment</p></td></tr></table>
</footer>

## Assignment Objectives

Show some features of ggmap package:  
  
1. Mapping
2. Geocoding
3. Route planner
  
For more information:  
http://journal.r-project.org/archive/2013-1/kahle-wickham.pdf  
http://cran.r-project.org/web/packages/ggmap/ggmap.pdf  

--- .class #id
{{{ content }}}
<footer class = 'logo_small'>
  <table><tr style="background-color:#FFFFFF"><td><img src = './assets/img/Logo_small.png' width="120" height="60"></img></td><td style="vertical-align:middle"><p align="left">Developing Data Projects Slidify Assignment</p></td></tr></table>
</footer>

## Mapping using Google Maps

```r
library(ggplot2)
library(ggmap)
```

```
## Warning: package 'ggmap' was built under R version 3.1.3
```

```r
qmap('John Hopkins University, Condado de Baltimore, Maryland', zoom=16)
```

![plot of chunk unnamed-chunk-1](assets/fig/unnamed-chunk-1-1.png) 

---
{{{ content }}}
<footer class = 'logo_small'>
  <table><tr style="background-color:#FFFFFF"><td><img src = './assets/img/Logo_small.png' width="120" height="60"></img></td><td style="vertical-align:middle"><p align="left">Developing Data Projects Slidify Assignment</p></td></tr></table>
</footer>

## Geocoding using Google Maps

```r
geocode('John Hopkins University, Condado de Baltimore, Maryland', output="latlona")
```

```
##         lon      lat
## 1 -76.65354 39.36957
##                                                       address
## 1 johns hopkins at mount washington, baltimore, md 21209, usa
```
  
For more information:  
http://code.google.com/apis/maps/documentation/geocoding/

---
{{{ content }}}
<footer class = 'logo_small'>
  <table><tr style="background-color:#FFFFFF"><td><img src = './assets/img/Logo_small.png' width="120" height="60"></img></td><td style="vertical-align:middle"><p align="left">Developing Data Projects Slidify Assignment</p></td></tr></table>
</footer>

## Route using Google Maps

```r
rt <- route(from='BALTIMORE airport, Baltimore, Maryland', to='John Hopkins University, Condado de Baltimore, Maryland', 
mode='driving', structure='route')  
qmap('Cherry Hill, Condado de Baltimore, Maryland', zoom=12)+
geom_path(aes(x=lon, y=lat), colour='red', alpha=3/4, size=2, data=rt)
```

```
## Warning: Removed 7 rows containing missing values (geom_path).
```

![plot of chunk unnamed-chunk-3](assets/fig/unnamed-chunk-3-1.png) 
  
For more information:  
https://developers.google.com/maps/documentation/directions/




