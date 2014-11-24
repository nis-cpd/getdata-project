# Activity Recognition in Smartphones

The file run_analysis.R contains an R script for deriving tidy data from
http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

The script produces tidy data in the 'wide' format, meaning there is one column
per variable, one row per observation, and it includes no NAs.  The steps are
labelled in the code and are as follows.

0. The source data is read in.  There is both training and testing data,
consisting of the main body of measurements, the values for subject and
activity, and labels for measurements and activities.

1. The training and testing data are combined, so that they sit (temporarily) as
measurement, subject, and activity data.  (These are combined together later.)

2. Only measurements for 'mean' and 'std' are selected.  The source data also
has some measurements for 'meanfreq', but these are excluded because there is no
corresponding 'std' measurement so they cannot be incorporated without
introducing NAs (which are not desired for tidy data).

3. Descriptive activity names are attached.  (The step is somewhat wordy because
the ordering must be restored following the merge.)

4. Useful variable names are attached.  The labels were cleaned of bad
characters, filtered for the mean/std selection, and combined with the added
columns 'Subject' and 'Activity'.

5. The new dataset is derived by grouping the measurements according to
(subject, activity) pair and then applying the mean function across the
resulting columns.

The resulting file can be read via
```
td <- read.table("subject_activity_averages.txt")
```
