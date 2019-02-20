# Cleaning Data Project


This is the final project for the "Getting and Cleaning Data" course.  While it
 saddens us to have to depart, we have six more courses to look forward to!  So, as Churchill once said, this is not the end.  It is not even the beginning of the end, though it is perhaps the end of the beginning.



## Key Files
* CodeBook.md:  Detailed information about the software and data used, as well as various assumptions and approaches taken while manipulating the data.
* tidyData.rTableData:  The output data, consisting of mean values for all measurements, grouped by activity and subject.
* run_analysis.R:  The complete, unabridged script used to generate the output file



## Overview
Data were obtained here:
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

The run_analysis.R script then performs the following tasts:
> 1. Merges the training and the test sets to create one data set.
> 1. Extracts only the measurements on the mean and standard deviation for each measurement.
> 1. Uses descriptive activity names to name the activities in the data set
> 1. Appropriately labels the data set with descriptive variable names.
> 1. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

For more detailed information, please consult the CodeBook.md.

## Acknowledgments
We found the blog post, [Getting and Cleaning the Assignment](https://thoughtfulbloke.wordpress.com/2015/09/09/getting-and-cleaning-the-assignment/) to be of assistance.