Readme for Getting and Cleaning Data Course Project
Bryan Brudevold

Steps to run this script:

1. Download the original data from this link:
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
2. Extract the data to folder "UCI HAR Dataset" in your RStudio working directory
3. Run script "run_analysis.R" in RStudio
4. The script produces an output tidy dataset called "tidyOutput.txt". This dataset was obtained by loading the original dataset, and extracting only fields that included a mean or standard deviation measurement. Then the mean of each mean or standard deviation measurement was computed, for all combinations of subject and activity.

