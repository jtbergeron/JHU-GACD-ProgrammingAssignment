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

These files are located in the **`UCI HAR Dataset`** sub-directory.

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

This resulting file was output as the "Tidy Mean Summary" file **`tidy_mean_UCI_HAR_Dataset.csv`**


# The Tidy Analysis Datasets Provided 

## File names and locations - Content Overview

There were two files created and these were output to a separate sub-directory **`tidy-data`** from the original files to keep the original source files clear.
1. **`tidy_base_UCI_HAR_Dataset.csv`** - has one record for each capture of an activity by a subject.
	1. There are multiple records for each activity for a given subject.

2. **`tidy_mean_UCI_HAR_Dataset.csv`** - has one summarized record for each activity and subject.
	1. The measures in file are the average of the individual measures from the base file.


## A Closer Look at the Columns

<code>
 [1] "ActivityName" - character - Name of the Activity (self explanitory)
-      "WALKING"           
-      "WALKING_UPSTAIRS"  
-      "WALKING_DOWNSTAIRS"
-      "SITTING"           
-      "STANDING"          
-      "LAYING"
                     
 [2] "SubjectID" - integer - from 1 to 30 identifying the test subject.

All of the following are are **numeric averages** for the named measure.
-      These are detailed on the next section
                          
 [3] "tBodyAcc.mean...X"                   
 [4] "tBodyAcc.mean...Y"                   
 [5] "tBodyAcc.mean...Z"                   
 [6] "tBodyAcc.std...X"                    
 [7] "tBodyAcc.std...Y"                    
 [8] "tBodyAcc.std...Z"                    
 [9] "tGravityAcc.mean...X"                
[10] "tGravityAcc.mean...Y"                
[11] "tGravityAcc.mean...Z"                
[12] "tGravityAcc.std...X"                 
[13] "tGravityAcc.std...Y"                 
[14] "tGravityAcc.std...Z"                 
[15] "tBodyAccJerk.mean...X"               
[16] "tBodyAccJerk.mean...Y"               
[17] "tBodyAccJerk.mean...Z"               
[18] "tBodyAccJerk.std...X"                
[19] "tBodyAccJerk.std...Y"                
[20] "tBodyAccJerk.std...Z"                
[21] "tBodyGyro.mean...X"                  
[22] "tBodyGyro.mean...Y"                  
[23] "tBodyGyro.mean...Z"                  
[24] "tBodyGyro.std...X"                   
[25] "tBodyGyro.std...Y"                   
[26] "tBodyGyro.std...Z"                   
[27] "tBodyGyroJerk.mean...X"              
[28] "tBodyGyroJerk.mean...Y"              
[29] "tBodyGyroJerk.mean...Z"              
[30] "tBodyGyroJerk.std...X"               
[31] "tBodyGyroJerk.std...Y"               
[32] "tBodyGyroJerk.std...Z"               
[33] "tBodyAccMag.mean.."                  
[34] "tBodyAccMag.std.."                   
[35] "tGravityAccMag.mean.."               
[36] "tGravityAccMag.std.."                
[37] "tBodyAccJerkMag.mean.."              
[38] "tBodyAccJerkMag.std.."               
[39] "tBodyGyroMag.mean.."                 
[40] "tBodyGyroMag.std.."                  
[41] "tBodyGyroJerkMag.mean.."             
[42] "tBodyGyroJerkMag.std.."              
[43] "fBodyAcc.mean...X"                   
[44] "fBodyAcc.mean...Y"                   
[45] "fBodyAcc.mean...Z"                   
[46] "fBodyAcc.std...X"                    
[47] "fBodyAcc.std...Y"                    
[48] "fBodyAcc.std...Z"                    
[49] "fBodyAcc.meanFreq...X"               
[50] "fBodyAcc.meanFreq...Y"               
[51] "fBodyAcc.meanFreq...Z"               
[52] "fBodyAccJerk.mean...X"               
[53] "fBodyAccJerk.mean...Y"               
[54] "fBodyAccJerk.mean...Z"               
[55] "fBodyAccJerk.std...X"                
[56] "fBodyAccJerk.std...Y"                
[57] "fBodyAccJerk.std...Z"                
[58] "fBodyAccJerk.meanFreq...X"           
[59] "fBodyAccJerk.meanFreq...Y"           
[60] "fBodyAccJerk.meanFreq...Z"           
[61] "fBodyGyro.mean...X"                  
[62] "fBodyGyro.mean...Y"                  
[63] "fBodyGyro.mean...Z"                  
[64] "fBodyGyro.std...X"                   
[65] "fBodyGyro.std...Y"                   
[66] "fBodyGyro.std...Z"                   
[67] "fBodyGyro.meanFreq...X"              
[68] "fBodyGyro.meanFreq...Y"              
[69] "fBodyGyro.meanFreq...Z"              
[70] "fBodyAccMag.mean.."                  
[71] "fBodyAccMag.std.."                   
[72] "fBodyAccMag.meanFreq.."              
[73] "fBodyBodyAccJerkMag.mean.."          
[74] "fBodyBodyAccJerkMag.std.."           
[75] "fBodyBodyAccJerkMag.meanFreq.."      
[76] "fBodyBodyGyroMag.mean.."             
[77] "fBodyBodyGyroMag.std.."              
[78] "fBodyBodyGyroMag.meanFreq.."         
[79] "fBodyBodyGyroJerkMag.mean.."         
[80] "fBodyBodyGyroJerkMag.std.."          
[81] "fBodyBodyGyroJerkMag.meanFreq.."     
[82] "angle.tBodyAccMean.gravity."         
[83] "angle.tBodyAccJerkMean..gravityMean."
[84] "angle.tBodyGyroMean.gravityMean."    
[85] "angle.tBodyGyroJerkMean.gravityMean."
[86] "angle.X.gravityMean."                
[87] "angle.Y.gravityMean."                
[88] "angle.Z.gravityMean."              
</code>

# Details on the measures

The following is taken directly from the **`features_info.txt`** file, which was provided in the original data.

<code>
Feature Selection 
=================

The features selected for this database come from the accelerometer and gyroscope 3-axial raw signals tAcc-XYZ and tGyro-XYZ. These time domain signals (prefix 't' to denote time) were captured at a constant rate of 50 Hz. Then they were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. Similarly, the acceleration signal was then separated into body and gravity acceleration signals (tBodyAcc-XYZ and tGravityAcc-XYZ) using another low pass Butterworth filter with a corner frequency of 0.3 Hz. 

Subsequently, the body linear acceleration and angular velocity were derived in time to obtain Jerk signals (tBodyAccJerk-XYZ and tBodyGyroJerk-XYZ). Also the magnitude of these three-dimensional signals were calculated using the Euclidean norm (tBodyAccMag, tGravityAccMag, tBodyAccJerkMag, tBodyGyroMag, tBodyGyroJerkMag). 

Finally a Fast Fourier Transform (FFT) was applied to some of these signals producing fBodyAcc-XYZ, fBodyAccJerk-XYZ, fBodyGyro-XYZ, fBodyAccJerkMag, fBodyGyroMag, fBodyGyroJerkMag. (Note the 'f' to indicate frequency domain signals). 

These signals were used to estimate variables of the feature vector for each pattern:  
'-XYZ' is used to denote 3-axial signals in the X, Y and Z directions.

tBodyAcc-XYZ
tGravityAcc-XYZ
tBodyAccJerk-XYZ
tBodyGyro-XYZ
tBodyGyroJerk-XYZ
tBodyAccMag
tGravityAccMag
tBodyAccJerkMag
tBodyGyroMag
tBodyGyroJerkMag
fBodyAcc-XYZ
fBodyAccJerk-XYZ
fBodyGyro-XYZ
fBodyAccMag
fBodyAccJerkMag
fBodyGyroMag
fBodyGyroJerkMag

The set of variables that were estimated from these signals are: 

mean(): Mean value
std(): Standard deviation
mad(): Median absolute deviation 
max(): Largest value in array
min(): Smallest value in array
sma(): Signal magnitude area
energy(): Energy measure. Sum of the squares divided by the number of values. 
iqr(): Interquartile range 
entropy(): Signal entropy
arCoeff(): Autorregresion coefficients with Burg order equal to 4
correlation(): correlation coefficient between two signals
maxInds(): index of the frequency component with largest magnitude
meanFreq(): Weighted average of the frequency components to obtain a mean frequency
skewness(): skewness of the frequency domain signal 
kurtosis(): kurtosis of the frequency domain signal 
bandsEnergy(): Energy of a frequency interval within the 64 bins of the FFT of each window.
angle(): Angle between to vectors.

Additional vectors obtained by averaging the signals in a signal window sample. These are used on the angle() variable:

gravityMean
tBodyAccMean
tBodyAccJerkMean
tBodyGyroMean
tBodyGyroJerkMean

The complete list of variables of each feature vector is available in 'features.txt'

</code>



