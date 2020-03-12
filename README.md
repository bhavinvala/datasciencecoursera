# datasciencecoursera
Repository created for Getting and Cleaning Data
-------------------------------------------------
Run_analysis.R program is combining the Human Activity Recognition Using Smartphones Datasets and converting them to tidy data.

Sequence of steps that programs follows:
1.reading the activity_labels and features data, renaming the variables with meaningful name. 
2.load dplyr package
3.combining the X test (2974 observations,561 variables) and train (7352 observations,561 varaibles) datasets
  combined dataset X_all has 10299 obsevations and 561 variables.
4.combining the Y test (2974 observations,1 variable) and train (7352 observations, 1 variable) datasets
  combined dataset Y_all has 10299 obsevations and 1 variable.
  merging with activity label dataset to add character variable of activity to Y_all data
5.combining the subject test (2974 observations,1 variable) and train (7352 observations, 1 variable) datasets
  combined dataset subject_all has 10299 obsevations and 1 variable. renaming the V1 variable to subject.
6. combining horizonatally the subject_all, X_all and Y_all data using cbind. 
   since there is no common variable to do the merge, it had to be combined using cbind. subject_X_Y_all created with 10299 observations
   and 564 variables
7. load tidyr package
8. transpose the data using gather function to convert all 561 result variable to column Value.
9. merge transposed data with features to create comb1, with feature data information
10. write the final data .txt file to be uploaded.
11. group the comb1 data to do the average per subject per feature per activity.
12. create dataset avg with the average per subject per feature per activity.


