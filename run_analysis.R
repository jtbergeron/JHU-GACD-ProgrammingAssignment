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
#
#
#
#
################################################################################


################################################################################
# 1. Identify, connect to, and load the files into R data structures.
################################################################################

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
	message <- cat(path, " --- GOOD\n")
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

# Validate loaded files 










}
