setwd("C:/Biblioteca/Docs/E_formação/Coursera 201502 Data Science/201406 Pratical Machine Learning/project")

testing <- read.csv("./pml-testing.csv", header=TRUE, sep=",", dec=".")
training <- read.csv("./pml-training.csv", header=TRUE, sep=",", dec=".")

trainingA <- training[ , -c(1:7,12:36,50:59,69:83,87:112,125:139,141:150)]
testingF <- testing[ , -c(1:7,12:36,50:59,69:83,87:112,125:139,141:150)]

trainingO <- training[is.na(training[ , 18])==FALSE , ]
trainingO <- training3[ , -c(6,14,17,26,89,92,101,127,130,139)]

library(lattice)
library(ggplot2)
library(caret)
set.seed(333)
inTrain <- createDataPartition(y=training2$classe, p=0.1, list=FALSE)
training2 <- trainingA[inTrain, ]
testing2 <- trainingA[-inTrain, ]

library(e1071)
library(randomForest)
preProc <- preProcess(training2[ , -52], method=c("scale","center"))
trainRF <- predict(preProc, training2[ , -52])
set.seed(333)
modFit <- train(training2$classe ~., method="rf", data=trainRF, prox=TRUE)
#system.time(train(training3$classe ~., method="rf", data=trainRF, prox=TRUE))
testRF <- predict(preProc, testing2[ , -52]) 
confusionMatrix(testing2$classe, predict(modFit, testRF))

set.seed(333)
modFit2 <- train(training3$classe ~., method="rf", trControl=trainControl(method="oob"), data=trainRF, prox=TRUE)
#system.time(train(training3$classe ~., method="rf", trControl=trainControl(method="oob"), data=trainRF, prox=TRUE))
testRF2 <- predict(preProc, testing2[ , -52]) 
CM2 <- confusionMatrix(testing2$classe, predict(modFit2, testRF2))

varImpPlot(modFit2$finalModel, main="Random Forests", cex=0.7)
varImp(modFit2)
colTrain <- rownames(which(varImp(modFit2)$importance > 35, arr.ind=TRUE))

par(cex=0.7)
plot(modFit$finalModel, main="")
legend("topright", legend=colnames(modFit$finalModel$err.rate), col=1:6, pch=19)
abline(v=300, lwd=2, col=2)

inTrain <- createDataPartition(y=trainingA$classe, p=0.4, list=FALSE)
training3 <- trainingA[inTrain, c(colTrain, "classe")]
testing3 <- trainingA[-inTrain, c(colTrain, "classe")]
preProc3 <- preProcess(training3[ , -7], method=c("scale", "center"))
trainRF3 <- predict(preProc3, training3[ , -7])
set.seed(333)
fitControl <- trainControl(method="oob", number = 5, repeats = 10, classProbs = TRUE, summaryFunction = twoClassSummary)
modFit3 <- train(training3$classe ~., method="rf", trControl=fitControl, data=trainRF3, prox=TRUE)
testRF3 <- predict(preProc3, testing3[ , -7])
CM3 <- confusionMatrix(testing3$classe, predict(modFit3, testRF3))

varImpPlot(modFit3$finalModel, main="Random Forests")
varImp(modFit3)
x <- varImp(modFit3)$importance
colTrain2 <- rownames(x)[order(x, decreasing=T)]; rm(x)

library(RColorBrewer)
n <- length(unique(testing3$classe))
activities <- unique(testing3$classe)
col_activ <- as.data.frame(cbind(as.character(activities), brewer.pal(n, "Dark2"))); rm(n)
colnames(col_activ) <- c("classe", "colours")

MapData <- merge(testing3[ , c("classe", colTrain2)], col_activ, by="classe", all.x=T) 
MapData <- MapData[order(MapData[ , 1], MapData[ , 2], MapData[ , 3], MapData[ , 4], MapData[ , 5], MapData[ , 6], MapData[ , 7]), ]

par(mfrow=c(2,3), mar=c(1, 4, 1, 1))
for(i in 2:7){plot(sort(MapData[ , i]), pch=19, cex=0.5, col="Blue", lwd=2, xaxt="n", xlab="", ylab=colnames(MapData)[i])}
dev.off()

nrow(MapData)
MapData <- MapData[MapData$yaw_belt>-120 & MapData$magnet_dumbbell_y>-1000, ]
nrow(MapData)

for(i in 2:7){MapData[ , i] <- (MapData[ , i] - mean(MapData[ , i])) / sd(MapData[ , i])}; rm(i)
rownames(MapData) <- 1:nrow(MapData)

x1 <- 1.5
x2 <- 2.5
y1 <- nrow(MapData) - 50
y2 <- nrow(MapData) - 1150
t1 <- (as.numeric(rownames(MapData[MapData$classe==activities[2], ])[1]) -1 ) / 2
t2 <- (as.numeric(rownames(MapData[MapData$classe==activities[3], ])[1]) + as.numeric(rownames(MapData[MapData$classe==activities[2], ])[3])) / 2
t3 <- (as.numeric(rownames(MapData[MapData$classe==activities[4], ])[1]) + as.numeric(rownames(MapData[MapData$classe==activities[3], ])[1])) / 2
t4 <- (as.numeric(rownames(MapData[MapData$classe==activities[5], ])[1]) + as.numeric(rownames(MapData[MapData$classe==activities[4], ])[1])) / 2
t5 <- (nrow(MapData) + as.numeric(rownames(MapData[MapData$classe==activities[5], ])[1])) / 2

par(xpd=NA)
heatmap(as.matrix(MapData[ , 2:7]), Rowv=NA, Colv=NA, RowSideColors=as.character(MapData$colours), ylab="Activities", labRow=NA, labCol=c("Roll\n Belt", "Yaw\n Belt", "Magnet\n Dumbbell\n Y", "Magnet\n Dumbbell\n Z", "Pitch\n Forearm", "Roll\n Forearm"), cexCol=1.2, add.expr=list(lines(c(x1, x2), c(y1, y1), lwd=2), lines(c(x1, x2), c(y2, y2), lwd=2), lines(c(x1, x1), c(y1, y2), lwd=2), lines(c(x2, x2), c(y1, y2), lwd=2), text(0, t1, activities[1], cex=1.2), text(0, t2, activities[2], cex=1.2), text(0, t3, activities[3], cex=1.2), text(0, t4, activities[4], cex=1.2), text(0, t5, activities[5], cex=1.2)))

rm(x1, x2, y1, y2, t1, t2, t3, t4, t5)



#pairs(training3[ , 1:3], pch=19, col=c(2:6))

#library(RColorBrewer)
#MDSplot(modFit3$finalModel, training3$classe, k=2, palette=brewer.pal(5, "Set1"))

#getTree(modFit3$finalModel, k=1)

#library(corrplot)
#cortrainRF3 <- cor(trainRF3)
#corrplot(cortrainRF3, order = "hclust")
#corrplot(cortrainRF3, method="ellipse", order = "original")

#classe_col <- as.numeric(rep(2, nrow(training3)))
#partraining3 <- cbind(training3, classe_col)
#rm(classe_col)
#colnames(partraining3)[11] <- "classe_col"
#partraining3[partraining3[ ,10]=="B", 11] <- 3
#partraining3[partraining3[ ,10]=="C", 11] <- 4
#partraining3[partraining3[ ,10]=="D", 11] <- 5
#partraining3[partraining3[ ,10]=="E", 11] <- 6
#library(MASS)
#par(cex=0.7)
#parcoord(partraining3[ , -11], col = partraining3$classe_col, lty = 1)

#library(foreach))
#library(iterators)
#library(parallel)
#library(doParallel)
# check data for skewness
#classeName <- names(training) %in% c("classe") 
#testForSkewness <- training[!classeName]
# apply the skewnes function to each numeric column of our training set
#skewValues <- apply(testForSkewness, 2, skewness)
# create a data frame for fancier printing
#skewValuesDf <- data.frame(skewValues)
#hist(skewValues, col=heat.colors(17), xlab="Skewness of all predictors", breaks=20)
# Create clusters for all available cores communicating over sockets
#cl <- makeCluster(detectCores() / 2)
#registerDoParallel(cl)
# global settings used for for all models
#ctrl <- trainControl(method='cv', number=10, allowParallel=TRUE)

testRFF <- predict(preProc3, testingF[ , c(colTrain)])
answers <- predict(modFit3, newdata=testRFF)
pml_write_files <- function(x){
  n <- length(x)
  for(i in 1:n){
    filename = paste0("./problem_id_",i,".txt")
    write.table(x[i], file=filename, quote=FALSE, row.names=FALSE, col.names=FALSE)
  }
}
pml_write_files(answers)

# B A B A A E D B A A B C B A E E A B B B, on 2014
# D A B A A E D B A A B C B A E E A B B B, on 2015

library(knitr)
library(markdown)
knit("./AssignmentJorgePinheiro.rmd")
markdownToHTML("./AssignmentJorgePinheiro.md", "./AssignmentJorgePinheiro.html")

save.image("./AssignmentJorgePinheiro.RData")