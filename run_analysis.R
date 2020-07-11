

path <- getwd()
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(url, file.path(path, "dataFiles.zip"))

unzip(zipfile = "dataFiles.zip")
actlab <- fread(file.path(path, "UCI HAR Dataset/activity_labels.txt"), col.names = c("classlabels", "activityname"))
features <- fread(file.path(path, "UCI HAR Dataset/features.txt"), col.names = c("index", "featureNames"))
featuresb <- grep("(mean|std)\\(\\)", features[, featurename])
measurements <- features[featuresb, featurename]
measurements <- gsub('[()]', '', measurements)

train <- fread(file.path(path, "UCI HAR Dataset/train/X_train.txt"))[, featuresb, with = FALSE]
data.table::setnames(train, colnames(train), measurements)
trainact <- fread(file.path(path, "UCI HAR Dataset/train/Y_train.txt"), col.names = c("Activity"))
trainaa <- fread(file.path(path, "UCI HAR Dataset/train/subject_train.txt"), col.names = c("SubjectNum"))
train <- cbind(trainaa, trainact, train)
test <- fread(file.path(path, "UCI HAR Dataset/test/X_test.txt"))[, featureb, with = FALSE]
data.table::setnames(test, colnames(test), measurements)
testact <- fread(file.path(path, "UCI HAR Dataset/test/Y_test.txt"), col.names = c("Activity"))
testaa <- fread(file.path(path, "UCI HAR Dataset/test/subject_test.txt"), col.names = c("SubjectNum"))
test <- cbind(testaa, testact, test)

binded <- rbind(train, test)

binded[["Activity"]] <- factor(binded[, Activity], levels = activityLabels[["classLabels"]], labels = activityLabels[["activityName"]])

binded[["SubjectNum"]] <- as.factor(binded[, SubjectNum])
binded <- reshape2::melt(data = binded, id = c("SubjectNum", "Activity"))
binded <- reshape2::dcast(data = binded, SubjectNum + Activity ~ variable, fun.aggregate = mean)
