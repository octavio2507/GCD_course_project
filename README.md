# GCD_course_project
Final course project for the Getting and Cleaning data course in the Data Science specialization

## What is in this code?

On the run_analysis.R file you will find all the necessary instructions for obtaining the data from the Samsung accelerometers.
The code starts with the download of the data and the creation of a workspace in which to store the data, so feel free to change it as ot suits you.

## The tidying process

The code starts reading the data files, assigning them the corresponding names and then merging the training and testing data sets.
After that, we subset the data in a data frame that contains only the Mean and the Standard deviation of the measures. Following this, we assign the corresponding activity name to the subsetted data frame, as it originally only had an index of the activity.
The next step consists in re-labeling the columns as to make them more understandable.
Finally, the code summarizes the information for each subject and performed activity and allows you to write it to a new file.
