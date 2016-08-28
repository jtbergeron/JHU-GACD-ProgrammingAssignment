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
#   3. Merging the Test and Train datasets into a single dataset.
#
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
	flush.console()
}

lapply(paths,verify_path)

# Load the files into R 

raw_features          <- read.table(path_features, stringsAsFactors=FALSE)
raw_activity_labels   <- read.table(path_activity_labels, stringsAsFactors=FALSE)
raw_test_subject      <- read.table(path_test_subject, stringsAsFactors=FALSE)
raw_test_X            <- read.table(path_test_X, stringsAsFactors=FALSE)
raw_test_y            <- read.table(path_test_y, stringsAsFactors=FALSE)
raw_train_subject     <- read.table(path_train_subject, stringsAsFactors=FALSE)
raw_train_X           <- read.table(path_train_X, stringsAsFactors=FALSE)
raw_train_y           <- read.table(path_train_y, stringsAsFactors=FALSE)


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
# Activity (y file) is a 1 column data frame with the activity ID.
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
# 3. Merging the Test and Train datasets into a single dataset.
################################################################################

# Write log entry for start of step

write_log("Merging the Test and Train datasets into a single dataset...")








}
