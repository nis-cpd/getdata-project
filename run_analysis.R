# 0. Read in the data from files
x_train <- read.table("x_train.txt")
x_test <- read.table("x_test.txt")
y_train <- read.table("y_train.txt")
y_test <- read.table("y_test.txt")
subject_train <- read.table("subject_train.txt")
subject_test <- read.table("subject_test.txt")
features <- read.table("features.txt")
activity_labels <- read.table("activity_labels.txt")

# 1. Combine constituent data into single data set
measurements <- rbind(x_train, x_test)
subjects <- rbind(subject_train, subject_test)
activities <- rbind(y_train, y_test)

# 2. Select only measurements of mean & std
# 2a. Remove unhelpful chars
col_names <- make.names(features$V2)
# 2b. Make pick-list of wanted columns
want <- grepl("mean\\.|std\\.", col_names)
# 2c. Apply pick-list to body of data
measurements <- measurements[, want]

# 3. Attach descriptive activity names
# 3a. Add a sequence to later restore ordering
activities <- data.frame(cbind(seq_along(activities$V1), activities$V1))
# 3b. Give dataframe column names for manipulation
names(activities) <- c("Index", "V1")
# 3c. Join activity labels
activities <- merge(activities, activity_labels, by = "V1")
# 3d. Restore ordering following the merge
activities <- activities[order(activities$Index), "V2"]

# 1b. Combine parts
data <- cbind(measurements, subjects, activities)

# 4. Attach useful var names
names(data) <- c(col_names[want], "Subject", "Activity")

# 5. Derive new dataset
# 5a. Split into groups
parts <- split(data, list(data$Subject, data$Activity))
# 5b. Construct first row
td <- data.frame(t(apply(parts[[1]][1:66], 2, mean)))
td[1, 67] <- parts[[1]][1, 67]  # Subject value
names(td)[67] <- "Subject"
td[1, 68] <- parts[[1]][1, 68]  # Activity value
names(td)[68] <- "Activity"
# 5c. Construct remaining rows
for (row in 2:180) {
  means <- apply(parts[[row]][1:66], 2, mean)  # Calculate means
  td[row,] <- c(t(means), parts[[row]][1, 67:68])  # Construct row into data.frame
}
# 5d. Output
write.table(td, file = "subject_activity_averages.txt", row.names = FALSE)