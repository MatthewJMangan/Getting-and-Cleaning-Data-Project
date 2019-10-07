### README

## Getting and Cleaning Data Course Project
This is a repository by Matt Mangan containing files to run data clean-up and
analysis on the UCI Human Activity Recognition Using Smartphones Data Set, which
can be found at:
        
http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

## Files

# CodeBook.md contains description of code, data, and ouput of the file 
"run_analysis.R".

# run_analysis.R 
- Merges training and test data sets with corresponding names and subject data
- Extracts only measurements pertaining to mean or standard deviation
- Adds descriptive activity names into the data set
- Adjusts variable names to be more descriptive and read.table
- Creates a final data set which contains the mean of all variable columns
- Exports the final data into a text file Final_Data.txt

# Final_Data.txt is the final output data returned by run_analysis.R