# run_analysis.R

run_analysis <- function() {
################################################################################
# This script is written as a main driver function and is run by:
#   1. sourcing the file: run_analysis.R
#   2. running the run_analysis() function with no parameters.
#
# The structure of project and releated files is as follows: 
#
#   JHU-GACD-ProgrammingAssignment/    ## project directory
#       .gitignore      ## git directions to ignore the UCI HAR Dataset directory 
#       run_analysis.R  ## this script to process the data and make it tidy.
#
#       UCI HAR Dataset/  ## directory containing the data being processed
#           README.txt             ## information about the files
#           features_info.txt      ## information about the features
# (used)    features.txt           ## 561 names associated with 561 measures
# (used)    activity_labels.txt    ## 6 names associated with activity codes
#
#           test/                ## directory with the 30% test data
#               Inertial Signals/   ## (not used) directory of sensor signal files 
# (used)        X_test.txt          ## Each record has a 561-feature vector with  
#                                   ##   time and frequency domain variables  
# (used)        subject_test.txt    ## Each record has a numeric code identifying
#                                   ##   the test subject (person)
# (used)        y_test.txt          ## Each record has a code associated with the 
#                                   ##   activity (maps to activity_labels.txt) 
#
#           train/               ## directory with the 70% training data
#               Inertial Signals/   ## (not used) directory of sensor signal files 
# (used)        X_test.txt          ## Each record has a 561-feature vector with  
#                                   ##   time and frequency domain variables  
# (used)        subject_test.txt    ## Each record has a numeric code identifying
#                                   ##   the test subject (person)
# (used)        y_test.txt          ## Each record has a code associated with the 
#                                   ##   activity (maps to activity_labels.txt) 
#
# For more information on the "UCI HAR Dataset" see this web link:
#  http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones 
#
# The analysis process proceeds as follows:
#   1. Identify, connect to, and load the files into R data structures.
#   2. Validate the raw data structures and extract their dimensions.
#   3. Data content review and validation prior to merge.
#   4. Merging the Test and Train datasets into a single dataset.
#      4.a. Merge the Test files into a single Test dataset.
#      4.b. Merge the Train files into a single Train dataset.
#      4.c. Merge the Test and Train datasets into a single dataset.
#   5. Extract only the mean and standard deviation measurements.  
#   6. Enriching the dataset with the Activity Names that match to codes.  
#   7. Writing the Tidy Base dataset as a CSV file.
#   8. Summarize the Base Tidy dataset, providing averages for measures present.
#   9. Writing the Tidy Mean Summary dataset as a CSV file. 
#  10. Log the successful completion of the script.
#
# The resulting "Tidy Base" CSV file can be read in as follows:
#    tidy_dataset_path <- "./tidy-data/tidy_base_UCI_HAR_Dataset.csv"
#    test_tidy_df <- read.csv(tidy_dataset_path, stringsAsFactors=FALSE)
#
# The resulting "Tidy Mean Summary" CSV file can be read in as follows:
#    tidy_mean_dataset_path <- "./tidy-data/tidy_mean_UCI_HAR_Dataset.csv"
#    test_tidy_mean_df <- read.csv(tidy_mean_dataset_path, stringsAsFactors=FALSE)
#
################################################################################

################################################################################
# write_log - utility function to output timestamped messages to the console
################################################################################

write_log <- function(message) {
  cat(format(Sys.time(), "%Y-%m-%d %H:%M:%S"), ":", message, "\n")
  flush.console()
}

################################################################################
# 1. Identify, connect to, and load the files into R data structures.
################################################################################

# Write log entry or start of step

write_log("Loading raw data files...")

# Paths to the files... 

path_features <- "./UCI HAR Dataset/features.txt"
path_activity_labels <- "./UCI HAR Dataset/activity_labels.txt"

path_test_subject <- "./UCI HAR Dataset/test/subject_test.txt"
path_test_X <- "./UCI HAR Dataset/test/X_test.txt"
path_test_y <- "./UCI HAR Dataset/test/y_test.txt"

path_train_subject <- "./UCI HAR Dataset/train/subject_train.txt" 
path_train_X <- "./UCI HAR Dataset/train/X_train.txt"
path_train_y <- "./UCI HAR Dataset/train/y_train.txt"

# Verify paths... 

paths <- c(
	path_features, 
	path_activity_labels, 
	path_test_subject,
	path_test_X,
	path_test_y,
	path_train_subject,
	path_train_X,
	path_train_y)

verify_path <- function(path) { 
	if(!file.exists(path)) {
		message <- cat(path, " --- file is missing\n")
		stop(message)
	}
	cat(path, " --- GOOD\n")
}

lapply(paths,verify_path)

# Load the files into R 

load_file <- function(path, ...) {
	write_log(paste("Loading ---:", path))
	df <- read.table(path, ...)
}

raw_features          <- load_file(path_features, stringsAsFactors=FALSE)
raw_activity_labels   <- load_file(path_activity_labels, stringsAsFactors=FALSE)
raw_test_subject      <- load_file(path_test_subject, stringsAsFactors=FALSE)
raw_test_X            <- load_file(path_test_X, stringsAsFactors=FALSE)
raw_test_y            <- load_file(path_test_y, stringsAsFactors=FALSE)
raw_train_subject     <- load_file(path_train_subject, stringsAsFactors=FALSE)
raw_train_X           <- load_file(path_train_X, stringsAsFactors=FALSE)
raw_train_y           <- load_file(path_train_y, stringsAsFactors=FALSE)


################################################################################
# 2. Validate the raw data structures and extract their dimensions.
################################################################################

# Write log entry for start of step

write_log("Validating raw data files...")

# Features - 561 names associated with 561 measures
#
# Expected: 561 rows with 2 columns
#  o Each row corresponds to the 561 columns in the "X" files
#   (X_test.txt and X_train.txt)
#  o Col 1 - Integer number of the row / column in the "X" file.
#  o Col 2 - Name of the "feature" or measurement in the "X" file.

ncol_raw_features <- ncol(raw_features)
nrow_raw_features <- nrow(raw_features)

if (ncol_raw_features == 2 & nrow_raw_features == 561) {
	print("Features - file dimensions validated - 561 rows by 2 columns")
} else {
	stop("Features - file dimensions validation failed!")
}

# Activity Labels - 6 names associated with activity codes
#
# Expected: 6 rows with 2 columns
#  o Each row corresponds to one of the possible activity codes in the 
#    "y" files (y_train.txt and y_test.txt)
#  o Col 1 - Integer number matching the IDs in the "y" files.
#  o Col 2 - Name of the "activity" for the associated code.

ncol_raw_activity_labels <- ncol(raw_activity_labels)
nrow_raw_activity_labels <- nrow(raw_activity_labels)

if (ncol_raw_activity_labels == 2 & nrow_raw_activity_labels == 6) {
	print("Activity Labels - file dimensions validated - 6 rows by 2 columns")
} else {
	stop("Activity Labels - file dimensions validation failed!")
}

# -----------------------------------------------------------------------------
# Test Files: Subject, Activity(y), Measures(X) represent a 3 file dataset
#
# Each file should have the same number of rows, as each row is related, 
# identifing the Subject and Activity associated with the Measure (feature).
#
# Subject is a 1 column data frame with the subject ID.
# Activity (y file) is a 1 column data frame with the Activity ID.
# Measures (X file) is a 561 column data frame containing the "features/measures".
#
# The number of rows are variable, but all 3 should have the same number.
# -----------------------------------------------------------------------------

ncol_raw_test_subject <- ncol(raw_test_subject)
nrow_raw_test_subject <- nrow(raw_test_subject)

ncol_raw_test_X <- ncol(raw_test_X)
nrow_raw_test_X <- nrow(raw_test_X)

ncol_raw_test_y <- ncol(raw_test_y)
nrow_raw_test_y <- nrow(raw_test_y)

# Singular row count for the "test" dataset

rows_test <- nrow_raw_test_subject

# Validate rows

if (rows_test == nrow_raw_test_X & rows_test == nrow_raw_test_y) {
	cat("[1] Test dataset has", rows_test, "rows\n")
} else {
	stop("Test dataset files are not of equal length. Validation failed!")
}

# Validate "Test Subject" columns 

if (ncol_raw_test_subject == 1) {
	print("Test Subject - file dimensions validated - 1 column")
} else {
	stop("Test Subject - file dimension validation failed!  Not 1 column.")
}

# Validate "Test Activity Label" columns

if (ncol_raw_test_y == 1) {
	print("Test Activity Label (y file) - file dimensions validated - 1 column")
} else {
	stop("Test Activity Label (y file) - file dimension validation failed!  Not 1 column.")
}

# Validate "Test Measures" columns

if (ncol_raw_test_X  == 561) {
	print("Test Measures (X file) - file dimensions validated - 561 columns")
} else {
	stop("Test Measures (X file) - file dimension validation failed!  Not 561 columns.")
}


# -----------------------------------------------------------------------------
# Train Files: Subject, Activity(y), Measures(X) represent a 3 file dataset
#
# Each file should have the same number of rows, as each row is related, 
# identifing the Subject and Activity associated with the Measure (feature).
#
# Subject is a 1 column data frame with the subject ID.
# Activity (y file) is a 1 column data frame with the activity ID.
# Measures (X file) is a 561 column data frame containing the "features/measures".
#
# The number of rows are variable, but all 3 should have the same number.
# -----------------------------------------------------------------------------

ncol_raw_train_subject <- ncol(raw_train_subject)
nrow_raw_train_subject <- nrow(raw_train_subject)

ncol_raw_train_X <- ncol(raw_train_X)
nrow_raw_train_X <- nrow(raw_train_X)

ncol_raw_train_y <- ncol(raw_train_y)
nrow_raw_train_y <- nrow(raw_train_y)

# Singular row count for the "train" dataset

rows_train <- nrow_raw_train_subject

# Validate rows

if (rows_train == nrow_raw_train_X & rows_train == nrow_raw_train_y) {
	cat("[1] Train dataset has", rows_train, "rows\n")
} else {
	stop("Train dataset files are not of equal length. Validation failed!")
}

# Validate "Train Subject" columns 

if (ncol_raw_train_subject == 1) {
	print("Train Subject - file dimensions validated - 1 column")
} else {
	stop("Train Subject - file dimension validation failed!  Not 1 column.")
}

# Validate "Train Activity Label" columns

if (ncol_raw_train_y == 1) {
	print("Train Activity Label (y file) - file dimensions validated - 1 column")
} else {
	stop("Train Activity Label (y file) - file dimension validation failed!  Not 1 column.")
}

# Validate "Train Measures" columns

if (ncol_raw_train_X  == 561) {
	print("Train Measures (X file) - file dimensions validated - 561 columns")
} else {
	stop("Train Measures (X file) - file dimension validation failed!  Not 561 columns.")
}


################################################################################
# 3. Data content review and validation prior to merge.
################################################################################

# Write log entry for start of step

write_log("Data content review and validation prior to merge...")

# Activity Files (y files) contents review
#
# The test and train "y files" should only have ID numbers in them 
# that match the Activity Labels file (activity_labels.txt).

# This is the reference drawn from the Activity Labels file.  

reference_activity_labels <- as.numeric(raw_activity_labels$V1)

# Validate the test y file

t_raw_test_y <- table(raw_test_y, useNA="ifany") 
d_raw_test_y <- as.numeric(unlist(dimnames(t_raw_test_y)))

if (identical(reference_activity_labels, d_raw_test_y)) {
	print("Test Activity (y file) contents validate against Activity Labels - GOOD")
} else {
	stop("Test Activity (y file) contents does NOT align to Activity Labels - FAILED")
}

# Validate the train y file

t_raw_train_y <- table(raw_train_y, useNA="ifany") 
d_raw_train_y <- as.numeric(unlist(dimnames(t_raw_train_y)))

if (identical(reference_activity_labels, d_raw_train_y)) {
	print("Train Activity (y file) contents validate against Activity Labels - GOOD")
} else {
	stop("Train Activity (y file) contents does NOT align to Activity Labels - FAILED")
}


# Subject Files are less critical in that the subjects are identified, but there 
# is not master reference file they map to.
#
# Per the assignment there should be 30 subjects total.
#
# Looking at the data subjects were split between the test and training 
# exercised, indicating the data was split by subject.
#
# Here is the FYI information on the split.
#

t_raw_test_subject  <- table(raw_test_subject, useNA="ifany")
t_raw_train_subject <- table(raw_train_subject, useNA="ifany")
 
print(t_raw_test_subject)
print(t_raw_train_subject)

# .............................................................................
# These are informative tests and do not stop the script.
# .............................................................................

# Measure Files (X files) have 561 numeric measures (features) making it a very
# wide dataset.  This is just a quick examination to see if there are any NAs 
# present in the data.
#

# Test - Measures file 

nacs_raw_test_X <- colSums(is.na(raw_test_X)) # this can help you spot the col
nas_raw_test_X <- sum(nacs_raw_test_X)

if (nas_raw_test_X > 0) {
	print("Test Measures File (X_test.txt) has NAs present")
} else {
	print("Test Measures File (X_test.txt) does NOT have NAs present")
}

# Train - Measures file 

nacs_raw_train_X <- colSums(is.na(raw_train_X)) # this can help you spot the col
nas_raw_train_X <- sum(nacs_raw_train_X)

if (nas_raw_train_X > 0) {
	print("Train Measures File (X_train.txt) has NAs present")
} else {
	print("Train Measures File (X_train.txt) does NOT have NAs present")
}


# One last set of tests on the Measure Files - checking to make sure all
# the columns are numeric... 

# Test - Measures file 

ns_raw_test_X <- sum(sapply(raw_test_X, is.numeric))

if (ns_raw_test_X == ncol_raw_test_X) {
	print("Test Measures File (X_test.txt) is confirmed all numeric")
} else { 
	print("Test Measures File (X_test.txt) is NOT all numeric")
}

# One last set of trains on the Measure Files - checking to make sure all
# the columns are numeric... 

# Train - Measures file 

ns_raw_train_X <- sum(sapply(raw_train_X, is.numeric))

if (ns_raw_train_X == ncol_raw_train_X) {
	print("Train Measures File (X_train.txt) is confirmed all numeric")
} else { 
	print("Train Measures File (X_train.txt) is NOT all numeric")
}


################################################################################
# 4. Merging the Test and Train datasets into a single dataset.
################################################################################

# Write log entry for start of step

write_log("Merging the Test and Train datasets into a single dataset...")

# -----------------------------------------------------------------------------
# Applying names to the raw files - prior to combining via cbind()
#
# This will set up the combination of the Subject, Activity, and Measures 
# files into a single file for Test and a single file for Train.
#
# These will later be combined via rbind() to create a single dataset.
# -----------------------------------------------------------------------------

# Test Dataset naming... 

names(raw_test_subject) <- c("SubjectID")
names(raw_test_X) <-raw_features[,2]
names(raw_test_y) <- c("ActivityCode")

# Train Dataset naming... 

names(raw_train_subject) <- c("SubjectID")
names(raw_train_X) <-raw_features[,2]
names(raw_train_y) <- c("ActivityCode")

# Created the consolidated raw datasets

craw_test_df  <- cbind(raw_test_subject, raw_test_y, raw_test_X)  
craw_train_df <- cbind(raw_train_subject, raw_train_y, raw_train_X)  

# secure the dimensions for the consolidated data frames

ncol_craw_test_df <- ncol(craw_test_df)
nrow_craw_test_df <- nrow(craw_test_df)
print(paste("Combined raw Test dataset has", nrow_craw_test_df, "rows and", ncol_craw_test_df, "columns."))

ncol_craw_train_df <- ncol(craw_train_df)
nrow_craw_train_df <- nrow(craw_train_df)
print(paste("Combined raw Train dataset has", nrow_craw_train_df, "rows and", ncol_craw_train_df, "columns."))

# release the storage for the original data frames

rm(raw_test_subject)  
rm(raw_test_X) 
rm(raw_test_y)  

rm(raw_train_subject)  
rm(raw_train_X) 
rm(raw_train_y)  

# demonstrate the addition of the two columns on the front of each dataset

print("Test Dataset - 4X4 Upper Corner - Shows added columns")
print(craw_test_df[c(1:4),c(1:4)])

print("Train Dataset - 4X4 Upper Corner - Shows added columns")
print(craw_train_df[c(1:4),c(1:4)])

# -----------------------------------------------------------------------------
# Combining the two datasets via rbind() into a single collect dataset.
# -----------------------------------------------------------------------------

# do the rbind

sraw_df <- rbind(craw_test_df, craw_train_df)

# secure the dimensions for the consolidated data frames

ncol_sraw_df <- ncol(sraw_df)
nrow_sraw_df <- nrow(sraw_df)

# release the storage for the original data frames

rm(craw_test_df, craw_train_df)

# Quick review and presentation of the combined raw file... 

print(paste("Combined raw dataset has", nrow_sraw_df, "rows and", ncol_sraw_df, "columns."))
print("The train file was appended to the test file")
print("Here is the 4X4 upper corner of the new file, ")
print("     it should match the upper corner of the Test file")
print(sraw_df[c(1:4),c(1:4)])

train_offset <- c(1:4)
train_offset <- train_offset + nrow_craw_test_df

print(paste("Here is the 4X4 left section of the new file, starting at row:", train_offset[[1]] ))
print("     it should match the upper corner of the Train file")
print(sraw_df[train_offset,c(1:4)])


################################################################################
# 5. Extract only the mean and standard deviation measurements. 
################################################################################

# Write log entry for start of step

write_log("Extract the mean and standard deviation measures...")

# Selecting any feature that has "mean" or "std" in it.

feature_names <- names(sraw_df)
feature_subset <- grep("[Mm]ean|[Ss]td", feature_names)

# we want to keep the first 2 columns and the ones just identified. 

column_select <- c(1:2,feature_subset)

print("These are the columns being kept (Subject ID, Activity Code, and the measures)")
print(feature_names[column_select])

# Create the Trimmed version of the file 

trimmed_df <- sraw_df[,column_select]

# secure the dimensions for the consolidated data frames

ncol_trimmed_df <- ncol(trimmed_df)
nrow_trimmed_df <- nrow(trimmed_df)

# demonstrate the addition of the two columns on the front of each dataset

print("Trimmed Dataset - 4X6 Upper Corner - Shows the data for visual review")
print(trimmed_df[c(1:4),c(1:6)])

# release the storage for the original data frames

rm(sraw_df)


################################################################################
# 6. Enriching the dataset with the Activity Names that match to codes. 
################################################################################

# Write log entry for start of step

write_log("Enriching the dataset with the Activity Names that match to codes...")

# Add the Activity Name by translating it with the Activity Labels file. 
trimmed_df$ActivityName <- raw_activity_labels[as.numeric(trimmed_df$ActivityCode), 2]

# Move the new ActivityName column from the end to the 2nd position, replacing
# the ActivityCode

ncol_trimmed_df <- ncol(trimmed_df)  ## refresh the column count, given the new column
newCols <- c(1, ncol_trimmed_df, seq(3, (ncol_trimmed_df - 1)))

tidy_df <- trimmed_df[,newCols]

# secure the dimensions for the tidy data frame

ncol_tidy_df <- ncol(tidy_df)
nrow_tidy_df <- nrow(tidy_df)

# demonstrate the addition of the new ActivityName as the 3rd column

print("Tidy Dataset - 4X6 Upper Corner - Shows the data for visual review")
print(tidy_df[c(1:4),c(1:6)])

# release the storage for the original data frames

rm(trimmed_df)

# Showing that there are multiple records per activity, per subject, 
# consistent with the plans for the next script to summarize on those
# levels.

print("There are multpliple records per activity, per subject, as shown here.")
print(table(tidy_df$SubjectID, tidy_df$ActivityName))

################################################################################
# 7. Writing the Tidy Base dataset as a CSV file.
################################################################################

# Write log entry for start of step

write_log("Writing the Tidy Base dataset as a CSV file...")

# -----------------------------------------------------------------------------
# Storing the refined data in a separate directory within the project
# -----------------------------------------------------------------------------

# validate the current working directory.
expected_wd <- "C:/Users/John/Google Drive/00_Working_Directory/JHU-GACD-ProgrammingAssignment"

if(expected_wd != getwd()) stop("Unexpected starting directory")

# Created Data subdirectory if not already present

if(!file.exists("tidy-data")) {
  dir.create("tidy-data")
}

# -----------------------------------------------------------------------------
# Write the Tidy dataset
# -----------------------------------------------------------------------------

tidy_dataset_path <- "./tidy-data/tidy_base_UCI_HAR_Dataset.csv"

write.table(tidy_df, tidy_dataset_path, sep=",", row.name=FALSE)  

rm(tidy_df) # release the storage for tidy_df

# -----------------------------------------------------------------------------
# Read it back in to validate it. 
# -----------------------------------------------------------------------------

test_tidy_df <- read.csv(tidy_dataset_path, stringsAsFactors=FALSE)

# secure the dimensions for the test tidy data frame

ncol_test_tidy_df <- ncol(test_tidy_df)
nrow_test_tidy_df <- nrow(test_tidy_df)

# Present upper corner for comparison to origial

print("Tidy Dataset (CSV) - 4X6 Upper Corner - Shows the data for visual review")
print(test_tidy_df[c(1:4),c(1:6)])

# Final check on the dimenstions 

if ((ncol_test_tidy_df == ncol_tidy_df) & (nrow_test_tidy_df == nrow_tidy_df)) {
	print("Tidy CSV Dataset dimensions match the Tidy Data Frame dimenstions. -- GOOD")
} else {
	stop("Tidy CSV Dataset and Data Frame dimensions DO NOT match. -- FAILURE")
}

################################################################################
# 8. Summarize the Base Tidy datasets, providing averages for measures present.
################################################################################

# Write log entry for start of step

write_log("Writing the Tidy dataset as a CSV file...")

# Using the plyr package to do the summarizing.
# Setting the digits to 5 to match the input data granularity
 
library(plyr)
options(digits=5)

# Produce the summarized dataset

tidy_mean_df <- as.data.frame(test_tidy_df %>% 
                group_by(ActivityName, SubjectID) %>% 
		summarise_each(funs(mean)))

# secure the dimensions for the tidy data frame

ncol_tidy_mean_df <- ncol(tidy_mean_df)
nrow_tidy_mean_df <- nrow(tidy_mean_df)

# demonstrate the summarized nature of the file

print(paste("Tidy Mean Summary Dataset has", nrow_tidy_mean_df, "rows and", ncol_tidy_mean_df, "columns."))
print("Tidy Mean Summary Dataset - 4X6 Upper Corner - Shows the data for visual review")
print(tidy_mean_df[c(1:4),c(1:6)])


################################################################################
# 9. Writing the Tidy Mean Summary dataset as a CSV file.
################################################################################

# Write log entry for start of step

write_log("Writing the Tidy Mean Summary dataset as a CSV file...")

# -----------------------------------------------------------------------------
# Write the Tidy Mean Summary dataset
# -----------------------------------------------------------------------------

tidy_mean_dataset_path <- "./tidy-data/tidy_mean_UCI_HAR_Dataset.csv"

write.table(tidy_mean_df, tidy_mean_dataset_path, sep=",", row.name=FALSE)  

rm(tidy_mean_df) # release the storage for tidy_mean_df

# -----------------------------------------------------------------------------
# Read it back in to validate it. 
# -----------------------------------------------------------------------------

test_tidy_mean_df <- read.csv(tidy_mean_dataset_path, stringsAsFactors=FALSE)

# secure the dimensions for the test tidy data frame

ncol_test_tidy_mean_df <- ncol(test_tidy_mean_df)
nrow_test_tidy_mean_df <- nrow(test_tidy_mean_df)

# Present upper corner for comparison to origial

print("Tidy Mean Summary Dataset (CSV) - 4X6 Upper Corner - Shows the data for visual review")
print(test_tidy_mean_df[c(1:4),c(1:6)])

# Final check on the dimenstions 

if ((ncol_test_tidy_mean_df == ncol_tidy_mean_df) & (nrow_test_tidy_mean_df == nrow_tidy_mean_df)) {
	print("Tidy Mean Summary CSV Dataset dimensions match the data frame dimensions. -- GOOD")
} else {
	stop("Tidy Mean Summary CSV Dataset does NOT match the data frame dimensions. -- FAILURE")
}


################################################################################
# 10. Log the successful completion of the script.
################################################################################

write_log("QED - Script ended successfully.")

}
