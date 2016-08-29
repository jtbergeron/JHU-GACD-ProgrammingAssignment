# JHU-GACD-ProgrammingAssignment #
## Human Activity Recognition Using Smartphones Data Set - Tidy Data Code Book ##

# Source Data Defined - Overview 

The source data documentation can be found here: 
[http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones)

Here is a link to the actual data used to test the script:
[https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip)

The source data is from the UCI Machine Learning Repository. 

<b>The README.txt file that is included with the data includes this overall summary...</b> 


#Human Activity Recognition Using Smartphones Dataset
Version 1.0<br>
----------
Jorge L. Reyes-Ortiz, Davide Anguita, Alessandro Ghio, Luca Oneto.<br>
Smartlab - Non Linear Complex Systems Laboratory<br>
DITEN - Università degli Studi di Genova.<br>
Via Opera Pia 11A, I-16145, Genoa, Italy.<br>
activityrecognition@smartlab.ws<br>
www.smartlab.ws
----------

The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, we captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. The experiments have been video-recorded to label the data manually. The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data. 

The sensor signals (accelerometer and gyroscope) were pre-processed by applying noise filters and then sampled in fixed-width sliding windows of 2.56 sec and 50% overlap (128 readings/window). The sensor acceleration signal, which has gravitational and body motion components, was separated using a Butterworth low-pass filter into body acceleration and gravity. The gravitational force is assumed to have only low frequency components, therefore a filter with 0.3 Hz cutoff frequency was used. From each window, a vector of features was obtained by calculating variables from the time and frequency domain. See 'features_info.txt' for more details. 

For each record it is provided:<br>
- Triaxial acceleration from the accelerometer (total acceleration) and the estimated body acceleration.<br>
- Triaxial Angular velocity from the gyroscope. <br>
- A 561-feature vector with time and frequency domain variables. <br>
- Its activity label. <br>
- An identifier of the subject who carried out the experiment. <br>
    
    
----------


# Source Data Defined - Looking at the files

##There are 4 sets of files:

1.  Informational about the data and files contained:
	1.  **README.txt** - information about the files.
	2.  **features_info.txt** - information about the features (measures).
        
2.  There are two files that translate/describe the data in the other two sets:
	1.  **features.txt** - 561 names associated with 561 features/measures.
	2.  **activity_labels.txt** - 6 names associated with the activity codes.

3.  The **Test dataset**, consisting of 3 files, each with an equal number of records:
	1.  **X_test.txt** - Each record has a 561-feature vector with time and frequency domain variables.
	2.  **subject_test.txt** - Each record has a numeric code identifying the test subject (person).
	3.  **y_test.txt** - Each record has a code associated with the activity (maps to activity_labels.txt).

4.  The **Train dataset**, consisting of 3 files, each with an equal number of records:
	1.  **X_train.txt** - Each record has a 561-feature vector with time and frequency domain variables.
	2.  **subject_train.txt** - Each record has a numeric code identifying the test subject (person).
	3.  **y_train.txt** - Each record has a code associated with the activity (maps to activity_labels.txt).
<br><br>
**Note: The Test and Train datasets also include a sub-directory "Inertial Signals", but that data is not included in this analysis.**
 

# Transformations Applied

There was a limited amount of transformation work done on the file, with almost all of it dealing with it shape versus it contents.

1. The 3 files that comprise a give Test or Train dataset were combined into a single file.
	1. One file for Test.  One file for Train.
	2. The Activity Code from the "y file" was added to the Measures/Features (X file).
	3. The SubjectID from the "subject file" as added to the Measures/Features (X file).
	4. Resulting in a combined file with 2 more columns on the left for a total of 563 columns.
	5. Appropriate column names were added at this stage.
		1. ActivityID and SubjectID were added names.
		2. The rest of the names were taken directly from the features.txt file, aligning to the existing documentation.

2. The Test and Train files were then combined to create a single dataset.
	1. The Train dataset was appended to the Test dataset.
	2. No changes to the columns.

3. The number of columns were reduced from 563 to 88 by keeping only the mean and standard deviation measurements, along with the ActivityCode and SubjectID.

4. The ActivityCode column was replaced with an ActivityName column.
	1. The **activity_labels.txt** was used to translate the codes in meaningful names.

At this point the file has the same number of rows, but is nicely formatted into a single file.
	1. This file was output as the **"Tidy Base"** file - **`tidy_base_UCI_HAR_Dataset.csv`**. 

The final transformation was to summarize the records by Activity Name and SubjectID providing an average (mean) for each of the measures.  This significantly reduced the number of records, but did not change the number of columns.
- The column names were retain unchanged, but the records now have average (mean) values.







