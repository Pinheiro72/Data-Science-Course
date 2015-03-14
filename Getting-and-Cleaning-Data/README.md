Data Science Course on 2015
=============================

This file describes how the script "run_analysis.R" performs the analysis from the project of the Getting and Cleaning Data Course assignment of the Data Science Specialization on 2015.


### Contributor

Jorge Pinheiro

Special thanks to the Coursera staff.  
Brian Caffo  
Jeff Leek  
Roger Peng  
Nick Carchedi  
Sean Kross  


### License

These course materials are available under the Creative Commons Attribution NonCommercial ShareAlike (CC-NC-SA) license (http://www.tldrlegal.com/l/CC-NC-SA).


### Introduction

This file describe the steps done in the analysis preformed over the data obtained from a experiment carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, it was captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data.

The sensor signals (accelerometer and gyroscope) were pre-processed by applying noise filters and then sampled in fixed-width sliding windows of 2.56 sec and 50% overlap (128 readings/window). The sensor acceleration signal, which has gravitational and body motion components, was separated using a Butterworth low-pass filter into body acceleration and gravity. The gravitational force is assumed to have only low frequency components, therefore a filter with 0.3 Hz cutoff frequency was used. From each window, a vector of features was obtained by calculating variables from the time and frequency domain.  

The data can de downloaded from this URL:  
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip  

If you have installed the package devtools, you can download the files directly by running the R script into your R environment, otherwise you have to download the files from the above source or using download.file and read.table has is shown in the R script as an example.

### Analysis description

The R script is divided in 6 parts:
- Import the data files to make the analysis
- Create an data set based on the training and the test sets of 10299 observations and 561 variables (features)
- Label the data set with descriptive variable names
- Select only the measurements on the mean and standard deviation for each measurement
- Name the activities and subjects in the data set
- Calculate the average of each variable for each activity and each subject creating a new data set
