# UCI Data Analysis Codebook

## Source Data
A description of the original project and its data is located here:
http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

The source data:
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

The zip file contained the following primary files:
* README.txt:  A plain text file, with information about the experiment and the various files contained there-in.
* activity_labels.txt:  An R data table file.  Maps the activity (walking, lying down, etc.) to its ID value.
* features.txt:  An R data table file.  Maps the column ID values to the original column names used by the X_train and X_test data files.
* test and train subdirectories:
	* X_...txt : An R data table file.  Experimental data.
	* y_...txt : An R data table file.  Maps an activity to each row in the X_ dataset.
	* subject_...txt : An R data table file.  Maps a subject to each row in the X_ dataset
* Inertial Signals subdirectory
	* Contains additional data files, which were not used in this analysis.

## Software Used
* R version 3.5.2 (2018-12-20)
* dplyr Version 0.7.8
* reshape2 Version 1.4.3
* Windows 10 operating system

## Analysis
__Output results are contained here__:
* tidyData.txt:  An R data table file.  Note that, because the instructions were to set "row.names=FALSE" when exporting this data, the nice column names will not be visible if this file is read back in via read.table().  You will, however, see the wonderful column names if you view this file directly on GitHub.
	* This file consists of 180 rows, each with 563 columns
	* The "activity" and "subject" columns served as the primary "group by" columns.
	* The remaining columns represent the mean value of measurements for the associated activity and subject.

__All steps performed upon the data are contained here__:
* run_analysis.R:  The entry point for this script is the function "AssignmentMain()."  Running that method inside R will download the zip file and perform all analysis steps, in the order in which they were originally performed, and will generate a new tidyData.txt output file.

### Steps Performed
* Column names for the test and training data files (561 columns) was read in from the "features.txt" file.  This file contained two separate columns, "V1" serving as the ordinal location of the column, with "V2" being the name of the column.
	* Because some of the column names were not unique, we created unique column names by appending the ordinal column ID to the column name.
	* Non-alphanumeric characters were removed from the column names.
	* Originally, we converted the column names to all lowercase letters, but this rendered them much more difficult to read, so this step was later abandoned in favor of camel casing.
	* Similarly, we made an attempt to expand various abbreviations used in the original column names.  However, this resulted in inordinately long and unwieldy column names.  As a result, we left the abbreviations alone.
* The X_, y_, and subject_ files were concatenated, first for the test data, then for the training data.  The column name for the y_ data was changed to "activity," and for the subject_ data was changed to "subject."  Finally, the resulting combined data were merged into a single dataset.
* The GetMeanAndStdMeasurements() metod from the run_analysis.R file retrieves only those columns containing the strings "std" or "mean"; that is, those columns containing standard deviation and mean measurements.
* Descriptive activity names were applied to the filtered dataset from the previous step, by reading in the "activity_labels.txt" file, and using the names from the $V2 column, minus any non-alphanumeric characters, in place of the activity ID values.
* An independent tidy dataset was created, containing the average values for each measurement, grouped by activity and subject.  This dataset was then written out to "tidyData.txt" using the row.names=FALSE, as directed.
	* Our approach made use of the "melt" and "dcast" methods from the reshape2 package, varying first by activity and then by subject.

