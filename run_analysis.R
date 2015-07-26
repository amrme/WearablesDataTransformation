
require("data.table")
require("reshape2")

# load the data
colNames <- read.table("./UCI HAR Dataset/features_info.txt")[,2]
actLabels <- read.table("./UCI HAR Dataset/activity_labels.txt")[,2]

# get the data for the means and sd only
extract_colNames <- grepl("mean|std", colNames)
names(X_test) = colNames
X_test = X_test[,extract_colNames]

# Load and process X_test and y_test data.
X_test <- read.table("./UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("./UCI HAR Dataset/test/y_test.txt")
subjTest <- read.table("./UCI HAR Dataset/test/subject_test.txt")


# Load activity labels
y_test[,2] = actLabels[y_test[,1]]
names(y_test) = c("Activity_ID", "Activity_Label")
names(subjTest) = "subject"

# Bind data
test_data <- cbind(as.data.table(subjTest), y_test, X_test)

# Load and process X_train & y_train data.
X_train <- read.table("./UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("./UCI HAR Dataset/train/y_train.txt")

subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt")

names(X_train) = colNames

# Extract only the measurements on the mean and standard deviation for each measurement.
X_train = X_train[,extract_colNames]

# Load activity data
y_train[,2] = actLabels[y_train[,1]]
names(y_train) = c("Activity_ID", "Activity_Label")
names(subject_train) = "subject"

# Bind data
train_data <- cbind(as.data.table(subject_train), y_train, X_train)

# Merge test and train data
data = rbind(test_data, train_data)

id_labels   = c("subject", "Activity_ID", "Activity_Label")
data_labels = setdiff(colnames(data), id_labels)
melt_data   = melt(data, id = id_labels, measure.vars = data_labels)

tidy_data   = dcast(melt_data, subject + Activity_Label ~ variable, mean)
write.table(tidy_data, file = "./tidy_data.txt")

