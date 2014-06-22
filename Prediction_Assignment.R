library(caret)
library(kernlab)
if (!file.exists("data")){
        dir.create("data")
}
fileUrl <- "https://d396qusza40orc.cloudfront.net/predmachlearn/pml-training.csv"
#download.file(fileUrl, destfile ="./data/pml-train.csv")
fileUrl <- "https://d396qusza40orc.cloudfront.net/predmachlearn/pml-testing.csv"
#download.file(fileUrl, destfile ="./data/pml-test.csv")
dateDownloaded <- date()
train <- read.csv("./data/pml-train.csv")
test <- read.csv("./data/pml-test.csv")
head(train)