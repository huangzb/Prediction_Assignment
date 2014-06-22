Prediction Assignment Writeup
========================================================
Download the training and testing dataset from the course website. Read the downloaded csv files into R. 

```r
library(caret)
```

```
## Loading required package: lattice
## Loading required package: ggplot2
```

```r
library(kernlab)
setInternet2(TRUE)
if (!file.exists("data")){
        dir.create("data")
}
fileUrl <- "https://d396qusza40orc.cloudfront.net/predmachlearn/pml-training.csv"
download.file(fileUrl, destfile ="./data/pml-train.csv")
fileUrl <- "https://d396qusza40orc.cloudfront.net/predmachlearn/pml-testing.csv"
download.file(fileUrl, destfile ="./data/pml-test.csv")
dateDownloaded <- date()
train <- read.csv("./data/pml-train.csv", na.strings=c("NA",""))
test <- read.csv("./data/pml-test.csv", na.strings=c("NA",""))
#head(train)
dim(train)
```

```
## [1] 19622   160
```

Check number of NAs in different columns.

```r
sorted_column <- sort(colSums(is.na(train)), decreasing=TRUE)
sorted_column
```

```
##       kurtosis_roll_belt      kurtosis_picth_belt        kurtosis_yaw_belt 
##                    19216                    19216                    19216 
##       skewness_roll_belt     skewness_roll_belt.1        skewness_yaw_belt 
##                    19216                    19216                    19216 
##            max_roll_belt           max_picth_belt             max_yaw_belt 
##                    19216                    19216                    19216 
##            min_roll_belt           min_pitch_belt             min_yaw_belt 
##                    19216                    19216                    19216 
##      amplitude_roll_belt     amplitude_pitch_belt       amplitude_yaw_belt 
##                    19216                    19216                    19216 
##     var_total_accel_belt            avg_roll_belt         stddev_roll_belt 
##                    19216                    19216                    19216 
##            var_roll_belt           avg_pitch_belt        stddev_pitch_belt 
##                    19216                    19216                    19216 
##           var_pitch_belt             avg_yaw_belt          stddev_yaw_belt 
##                    19216                    19216                    19216 
##             var_yaw_belt            var_accel_arm             avg_roll_arm 
##                    19216                    19216                    19216 
##          stddev_roll_arm             var_roll_arm            avg_pitch_arm 
##                    19216                    19216                    19216 
##         stddev_pitch_arm            var_pitch_arm              avg_yaw_arm 
##                    19216                    19216                    19216 
##           stddev_yaw_arm              var_yaw_arm        kurtosis_roll_arm 
##                    19216                    19216                    19216 
##       kurtosis_picth_arm         kurtosis_yaw_arm        skewness_roll_arm 
##                    19216                    19216                    19216 
##       skewness_pitch_arm         skewness_yaw_arm             max_roll_arm 
##                    19216                    19216                    19216 
##            max_picth_arm              max_yaw_arm             min_roll_arm 
##                    19216                    19216                    19216 
##            min_pitch_arm              min_yaw_arm       amplitude_roll_arm 
##                    19216                    19216                    19216 
##      amplitude_pitch_arm        amplitude_yaw_arm   kurtosis_roll_dumbbell 
##                    19216                    19216                    19216 
##  kurtosis_picth_dumbbell    kurtosis_yaw_dumbbell   skewness_roll_dumbbell 
##                    19216                    19216                    19216 
##  skewness_pitch_dumbbell    skewness_yaw_dumbbell        max_roll_dumbbell 
##                    19216                    19216                    19216 
##       max_picth_dumbbell         max_yaw_dumbbell        min_roll_dumbbell 
##                    19216                    19216                    19216 
##       min_pitch_dumbbell         min_yaw_dumbbell  amplitude_roll_dumbbell 
##                    19216                    19216                    19216 
## amplitude_pitch_dumbbell   amplitude_yaw_dumbbell       var_accel_dumbbell 
##                    19216                    19216                    19216 
##        avg_roll_dumbbell     stddev_roll_dumbbell        var_roll_dumbbell 
##                    19216                    19216                    19216 
##       avg_pitch_dumbbell    stddev_pitch_dumbbell       var_pitch_dumbbell 
##                    19216                    19216                    19216 
##         avg_yaw_dumbbell      stddev_yaw_dumbbell         var_yaw_dumbbell 
##                    19216                    19216                    19216 
##    kurtosis_roll_forearm   kurtosis_picth_forearm     kurtosis_yaw_forearm 
##                    19216                    19216                    19216 
##    skewness_roll_forearm   skewness_pitch_forearm     skewness_yaw_forearm 
##                    19216                    19216                    19216 
##         max_roll_forearm        max_picth_forearm          max_yaw_forearm 
##                    19216                    19216                    19216 
##         min_roll_forearm        min_pitch_forearm          min_yaw_forearm 
##                    19216                    19216                    19216 
##   amplitude_roll_forearm  amplitude_pitch_forearm    amplitude_yaw_forearm 
##                    19216                    19216                    19216 
##        var_accel_forearm         avg_roll_forearm      stddev_roll_forearm 
##                    19216                    19216                    19216 
##         var_roll_forearm        avg_pitch_forearm     stddev_pitch_forearm 
##                    19216                    19216                    19216 
##        var_pitch_forearm          avg_yaw_forearm       stddev_yaw_forearm 
##                    19216                    19216                    19216 
##          var_yaw_forearm                        X                user_name 
##                    19216                        0                        0 
##     raw_timestamp_part_1     raw_timestamp_part_2           cvtd_timestamp 
##                        0                        0                        0 
##               new_window               num_window                roll_belt 
##                        0                        0                        0 
##               pitch_belt                 yaw_belt         total_accel_belt 
##                        0                        0                        0 
##             gyros_belt_x             gyros_belt_y             gyros_belt_z 
##                        0                        0                        0 
##             accel_belt_x             accel_belt_y             accel_belt_z 
##                        0                        0                        0 
##            magnet_belt_x            magnet_belt_y            magnet_belt_z 
##                        0                        0                        0 
##                 roll_arm                pitch_arm                  yaw_arm 
##                        0                        0                        0 
##          total_accel_arm              gyros_arm_x              gyros_arm_y 
##                        0                        0                        0 
##              gyros_arm_z              accel_arm_x              accel_arm_y 
##                        0                        0                        0 
##              accel_arm_z             magnet_arm_x             magnet_arm_y 
##                        0                        0                        0 
##             magnet_arm_z            roll_dumbbell           pitch_dumbbell 
##                        0                        0                        0 
##             yaw_dumbbell     total_accel_dumbbell         gyros_dumbbell_x 
##                        0                        0                        0 
##         gyros_dumbbell_y         gyros_dumbbell_z         accel_dumbbell_x 
##                        0                        0                        0 
##         accel_dumbbell_y         accel_dumbbell_z        magnet_dumbbell_x 
##                        0                        0                        0 
##        magnet_dumbbell_y        magnet_dumbbell_z             roll_forearm 
##                        0                        0                        0 
##            pitch_forearm              yaw_forearm      total_accel_forearm 
##                        0                        0                        0 
##          gyros_forearm_x          gyros_forearm_y          gyros_forearm_z 
##                        0                        0                        0 
##          accel_forearm_x          accel_forearm_y          accel_forearm_z 
##                        0                        0                        0 
##         magnet_forearm_x         magnet_forearm_y         magnet_forearm_z 
##                        0                        0                        0 
##                   classe 
##                        0
```

It is clear to see that there are many columns with 19216 NAs on each column. Train has 19622 rows. Thus I remove the columns with many NAs.


```r
NAs <- colSums(is.na(train))
train_nona <- train[,which(NAs == 0)]
```

It is also clear that X, user_name, raw_timestamp_part_1, raw_timestamp_part_2, cvtd_timestamp, new_window, num_window are not sensor outputs that are related to the body position. The train dataset is thus subsetted to only include the columns with sensor outputs that are related to the body position.


```r
removeIndex <- grep("timestamp|X|user_name|new_window|num_window",names(train_nona))
train_nona <- train_nona[,-removeIndex]
```

Check correlated predictors.

```r
M <- abs(cor(train_nona[, -53]))
diag(M) <- 0
which(M>0.8, arr.ind=T)
```

```
##                  row col
## yaw_belt           3   1
## total_accel_belt   4   1
## accel_belt_y       9   1
## accel_belt_z      10   1
## accel_belt_x       8   2
## magnet_belt_x     11   2
## roll_belt          1   3
## roll_belt          1   4
## accel_belt_y       9   4
## accel_belt_z      10   4
## pitch_belt         2   8
## magnet_belt_x     11   8
## roll_belt          1   9
## total_accel_belt   4   9
## accel_belt_z      10   9
## roll_belt          1  10
## total_accel_belt   4  10
## accel_belt_y       9  10
## pitch_belt         2  11
## accel_belt_x       8  11
## gyros_arm_y       19  18
## gyros_arm_x       18  19
## magnet_arm_x      24  21
## accel_arm_x       21  24
## magnet_arm_z      26  25
## magnet_arm_y      25  26
## accel_dumbbell_x  34  28
## accel_dumbbell_z  36  29
## gyros_dumbbell_z  33  31
## gyros_forearm_z   46  31
## gyros_dumbbell_x  31  33
## gyros_forearm_z   46  33
## pitch_dumbbell    28  34
## yaw_dumbbell      29  36
## gyros_forearm_z   46  45
## gyros_dumbbell_x  31  46
## gyros_dumbbell_z  33  46
## gyros_forearm_y   45  46
```

There are many data points. To speed up the training process, I chose 20% of the training data for random forest training. The rest of the data for cross validation.

```r
# make training set
trainIndex <- createDataPartition(y = train_nona$classe, p=0.2,list=FALSE) # 3927 rows
trainData <- train_nona[trainIndex,]
testData <- train_nona[-trainIndex,]
```

Train the random forest model. 

```r
library(caret)
trControl = trainControl(method = "cv", number = 4, allowParallel=TRUE)
modFit <- train(classe~., data = trainData, method = "rf", prox = TRUE, trControl = trControl)
```

```
## Loading required package: randomForest
## randomForest 4.6-7
## Type rfNews() to see new features/changes/bug fixes.
```

```r
modFit
```

```
## Random Forest 
## 
## 3927 samples
##   52 predictors
##    5 classes: 'A', 'B', 'C', 'D', 'E' 
## 
## No pre-processing
## Resampling: Cross-Validated (4 fold) 
## 
## Summary of sample sizes: 2944, 2946, 2946, 2945 
## 
## Resampling results across tuning parameters:
## 
##   mtry  Accuracy  Kappa  Accuracy SD  Kappa SD
##   2     1         1      0.003        0.004   
##   30    1         1      0.004        0.005   
##   50    1         0.9    0.009        0.01    
## 
## Accuracy was used to select the optimal model using  the largest value.
## The final value used for the model was mtry = 27.
```

Estimate the error by cross validating the testData.

```r
pred <- predict(modFit, testData); testData$predRight <- pred == testData$classe;
accuracy <- sum(testData$predRight)/length(testData$predRight)
accuracy
```

```
## [1] 0.9718
```

Generate predictions for the test.

```r
pred <- predict(modFit, test); 
pred
```

```
##  [1] B A B A A E D B A A B C B A E E A B B B
## Levels: A B C D E
```
