Title
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
```

```
## Error: there is no package called 'kernlab'
```

```r
if (!file.exists("data")){
        dir.create("data")
}
fileUrl <- "https://d396qusza40orc.cloudfront.net/predmachlearn/pml-training.csv"
#download.file(fileUrl, destfile ="./data/pml-train.csv")
fileUrl <- "https://d396qusza40orc.cloudfront.net/predmachlearn/pml-testing.csv"
#download.file(fileUrl, destfile ="./data/pml-test.csv")
dateDownloaded <- date()
train <- read.csv("./data/pml-train.csv", na.strings=c("NA",""))
```

```
## Warning: cannot open file './data/pml-train.csv': No such file or
## directory
```

```
## Error: cannot open the connection
```

```r
test <- read.csv("./data/pml-test.csv", na.strings=c("NA",""))
```

```
## Warning: cannot open file './data/pml-test.csv': No such file or directory
```

```
## Error: cannot open the connection
```

```r
head(train)
```

```
##                         
## 1 function (x, ...)     
## 2 {                     
## 3     UseMethod("train")
## 4 }
```

```r
dim(train)
```

```
## NULL
```

Check number of NAs in different columns.

```r
sorted_column <- sort(colSums(is.na(train)), decreasing=TRUE)
```

```
## Warning: is.na() applied to non-(list or vector) of type 'closure'
```

```
## Error: 'x' must be an array of at least two dimensions
```

```r
sorted_column
```

```
## Error: object 'sorted_column' not found
```
It is clear to see that there are many columns with 19216 NAs on each column. Train has 19622 rows. Thus I remove the columns with many NAs.

Check number of NAs in different columns.

```r
NAs <- colSums(is.na(train))
```

```
## Warning: is.na() applied to non-(list or vector) of type 'closure'
```

```
## Error: 'x' must be an array of at least two dimensions
```

```r
train_nona <- train[,which(NAs == 0)]
```

```
## Error: object 'NAs' not found
```

It is also clear that X, user_name, raw_timestamp_part_1, raw_timestamp_part_2, cvtd_timestamp, new_window, num_window are not sensor outputs that are related to the body position. The train dataset is thus subsetted to only include the columns with sensor outputs that are related to the body position.


```r
removeIndex <- grep("timestamp|X|user_name|new_window|num_window",names(train_nona))
```

```
## Error: object 'train_nona' not found
```

```r
train_nona <- train_nona[,-removeIndex]
```

```
## Error: object 'train_nona' not found
```

Check correlated predictors.

```r
M <- abs(cor(train_nona[, -53]))
```

```
## Error: object 'train_nona' not found
```

```r
diag(M) <- 0
```

```
## Error: object 'M' not found
```

```r
which(M>0.8, arr.ind=T)
```

```
## Error: object 'M' not found
```


```r
# make training set
trainIndex <- createDataPartition(y = train_nona$classe, p=0.2,list=FALSE) # 3927 rows
```

```
## Error: object 'train_nona' not found
```

```r
trainData <- train_nona[trainIndex,]
```

```
## Error: object 'train_nona' not found
```


```r
library(caret)
trControl = trainControl(method = "cv", number = 4, allowParallel=TRUE)
modFit <- train(classe~., data = trainData, method = "rf", prox = TRUE, trControl = trControl)
```

```
## Error: object 'trainData' not found
```

```r
modFit
```

```
## Error: object 'modFit' not found
```

```r
pred <- predict(modFit, testing); testing$predRight <- pred == testing$classe
```

```
## Error: object 'modFit' not found
```

```
## Error: object 'pred' not found
```
