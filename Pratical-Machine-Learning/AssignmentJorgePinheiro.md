Prediciting exercise activities using Random Forests
========================================================

The objective of this assignment is to predict the activity done in 5 different ways of barbell lifts. For this purpose it was used data from accelerometers on the belt, forearm, arm and dumbbell of 6 participants, kindly ceded by Groupware.les.inf.

### Preprocessing
The test data consisted in 20 samples (observations) and 160 variables. Analyzing this variables was possible to exclude 108 variables since a few were not predictors (i.e. name of the athlete) and the majority didn't had values, although in the train data 406 observations had values for those specific variables.
```
testing <- read.csv("./pml-testing.csv", header=TRUE, sep=",", dec=".")  
training <- read.csv("./pml-training.csv", header=TRUE, sep=",", dec=".")  
trainingA <- training[ , -c(1:7,12:36,50:59,69:83,87:112,125:139,141:150)]  
testingF <- testing[ , -c(1:7,12:36,50:59,69:83,87:112,125:139,141:150)]  
```
As a preprocessing procedure it was used a center and scale method avaiable on the _caret_ package function _preProcess_.

### Variable selection
Since the train data consisted on 19622 observations, a computacional problem was posed. The processing time for each training model. For this reason the first split created by the function _createDataPartition_ consisted on 10% of the training data set observations and 51 variables as predictors. The computer has a 2.26GHz core duo processor and took 18 minutes to perform the first training using RStudio.
```
library(lattice); library(ggplot2); library(caret)  

inTrain <- createDataPartition(y=training2$classe, p=0.1, list=FALSE)  
training2 <- trainingA[inTrain, ]  
testing2 <- trainingA[-inTrain, ]  

library(e1071); library(randomForest)  

preProc <- preProcess(training2[ , -52], method=c("scale","center"))  
trainRF <- predict(preProc, training2[ , -52])  
modFit <- train(training2$classe ~., method="rf", data=trainRF, prox=TRUE)  
testRF <- predict(preProc, testing2[ , -52])  
confusionMatrix(testing2$classe, predict(modFit, testRF))  
```
After using the function _trControl=trainControl(method="oob")_ on the same training data set, the time went down to 1.5 minutes and the accuracy stayed within the confidence interval. Therefore, the training set was increased in a next step of the analysis.
```
modFit2 <- train(training3$classe ~., method="rf", trControl=trainControl(method="oob"), data=trainRF, prox=TRUE)  
testRF2 <- predict(preProc, testing2[ , -52])  
CM2 <- confusionMatrix(testing2$classe, predict(modFit2, testRF2))
```
![a](figure/RFGiniplot1.png)

As we can see in the above figure there is a big split between the 6th and 7th variable and probably the first 6 variables would be good predictors of the outcome _classe_, but after a few tests with 6, 9 and 11 variables, it was choosed the one with less variables, since the minimization of the in sample error, by including more variables was very small (approximately 1% on accuracy).
```
varImpPlot(modFit2$finalModel, main="Random Forests", cex=0.7)  
varImp(modFit2)  
colTrain <- rownames(which(varImp(modFit2)$importance > 35, arr.ind=TRUE))  
```

```
## Confusion Matrix and Statistics
## 
##           Reference
## Prediction    A    B    C    D    E
##          A 4963   36    6   12    5
##          B  217 3080  110   10    0
##          C    8  173 2828   70    0
##          D   38   20  131 2686   19
##          E    5   65   68   66 3042
## 
## Overall Statistics
##                                           
##                Accuracy : 0.94            
##                  95% CI : (0.9364, 0.9435)
##     No Information Rate : 0.2962          
##     P-Value [Acc > NIR] : < 2.2e-16       
##                                           
##                   Kappa : 0.924           
##  Mcnemar's Test P-Value : < 2.2e-16       
## 
## Statistics by Class:
## 
##                      Class: A Class: B Class: C Class: D Class: E
## Sensitivity            0.9488   0.9129   0.8998   0.9444   0.9922
## Specificity            0.9953   0.9764   0.9827   0.9860   0.9860
## Pos Pred Value         0.9883   0.9014   0.9185   0.9281   0.9372
## Neg Pred Value         0.9788   0.9794   0.9784   0.9893   0.9983
## Prevalence             0.2962   0.1911   0.1780   0.1611   0.1736
## Detection Rate         0.2811   0.1744   0.1602   0.1521   0.1723
## Detection Prevalence   0.2844   0.1935   0.1744   0.1639   0.1838
## Balanced Accuracy      0.9720   0.9446   0.9412   0.9652   0.9891
```
```
par(cex=0.7)  
plot(modFit$finalModel, main="")  
legend("topright", legend=colnames(modFit$finalModel$err.rate), col=1:6, pch=19)  
abline(v=300, lwd=2, col=2)  
```
![b](figure/ErrorTreeplot.png)

In the above figure we can see the error rate across the number of trees used to fit the model. As we can see above 300th tree there isn't any significant aditional error reduction on any category of _classe_.

### Predicting using Random Forests
After a variable reduction, the training data set was again split by the function _createDataPartition_, resulting on a training data set of 40% and the remaining stayed as the testing data set. The training set wasn't larger because ocurred an error saying that cannot allocate a vector of size 1.0 Gb. Even so, as expected, the model accuracy increased.  
<b>The final model it was made with cross validation by spliting the training data set in 5 fold repeated 10 times. The expected out sample error is 4%.</b>
```
inTrain <- createDataPartition(y=trainingA$classe, p=0.4, list=FALSE)  
training3 <- trainingA[inTrain, c(colTrain,"classe")]  
testing3 <- trainingA[-inTrain, c(colTrain,"classe")]  

preProc3 <- preProcess(training3[ , -7], method=c("scale","center"))  
trainRF3 <- predict(preProc3, training3[ , -7])  
fitControl <- trainControl(method="oob", number = 5, repeats = 10, classProbs = TRUE, summaryFunction = twoClassSummary)  
modFit3 <- train(training3$classe ~., method="rf", trControl=fitControl, data=trainRF3, prox=TRUE)  
testRF3 <- predict(preProc3, testing3[ , -7])  
CM3 <- confusionMatrix(testing3$classe, predict(modFit3, testRF3))  
```

```
## Confusion Matrix and Statistics
## 
##           Reference
## Prediction    A    B    C    D    E
##          A 3272   38   22   16    0
##          B   33 2155   56   31    3
##          C    2   41 1930   78    2
##          D   12   28   40 1844    5
##          E    2   28   10   19 2105
## 
## Overall Statistics
##                                           
##                Accuracy : 0.9604          
##                  95% CI : (0.9567, 0.9639)
##     No Information Rate : 0.2821          
##     P-Value [Acc > NIR] : < 2.2e-16       
##                                           
##                   Kappa : 0.95            
##  Mcnemar's Test P-Value : 1.096e-10       
## 
## Statistics by Class:
## 
##                      Class: A Class: B Class: C Class: D Class: E
## Sensitivity            0.9852   0.9410   0.9378   0.9276   0.9953
## Specificity            0.9910   0.9870   0.9873   0.9913   0.9939
## Pos Pred Value         0.9773   0.9460   0.9401   0.9559   0.9727
## Neg Pred Value         0.9942   0.9858   0.9868   0.9854   0.9990
## Prevalence             0.2821   0.1945   0.1748   0.1689   0.1797
## Detection Rate         0.2779   0.1831   0.1639   0.1566   0.1788
## Detection Prevalence   0.2844   0.1935   0.1744   0.1639   0.1838
## Balanced Accuracy      0.9881   0.9640   0.9626   0.9594   0.9946
```
### Conclusions
```
varImpPlot(modFit3$finalModel, main="Random Forests")  
```
As we can see in the following graphic the "Roll Belt" and "Yaw Belt" variabels are the ones that contribute more to classify the type of activity done by the athletes.

![c](figure/RFGiniplot2.png)

Analysing the values from each feature (variable), we can indentify some outliers in "Yaw Belt" and "Magnet Dumbbell Y", that should have been excluded from the analsyis.

![d](figure/FinalFeatures.png)

A smaller number of variables, even in such a complex models like random forests, makes more easier to understand the results obtained. Like the example shown in the below figure by a square, where we can see that median values of Yaw Belt are associated with the exercise activity "E".

![e](figure/FinalHeatmap.png)

### Citations
Ugulino, W., Cardador, D., Vega, K., Velloso, E., Milidiu, R., Fuks, H. Wearable Computing: Accelerometers Data Classification of Body Postures and Movements. Proceedings of 21st Brazilian Symposium on Artificial Intelligence. Advances in Artificial Intelligence - SBIA 2012. In: Lecture Notes in Computer Science. , pp. 52-61. Curitiba, PR: Springer Berlin / Heidelberg, 2012. ISBN 978-3-642-34458-9. DOI: 10.1007/978-3-642-34459-6_6.  

Velloso, E., Bulling, A., Gellersen, H., Ugulino, W., Fuks, H. Qualitative Activity Recognition of Weight Lifting Exercises. Proceedings of 4th International Conference in Cooperation with SIGCHI (Augmented Human 13) . Stuttgart, Germany: ACM SIGCHI, 2013.
