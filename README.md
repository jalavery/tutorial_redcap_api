# Downloading Data via the REDCap API

This repository includes a presentation with a high level overview of REDCap alongside code to abstract data from REDCap via the REDCap API using SAS or R.

The files include:
1. PowerPoint presentation with high-level overview of REDCap, the REDCap API and the code outlined below
2. `example_REDCapR.R`: R file with example code to pull data from REDCap using the R package {REDCapR}
3. `example_sas_option1_REDCapR.sas`: SAS file with example code to pull data from REDCap by running R via SAS, again using the R package {REDCapR}
4. `example_sas_option2_proc_http.sas`: SAS file with example code to use PROC HTTP to pull data from REDCap. The code in this file is based on the 2013 paper [SAS and REDCap API: Efficient and Reproducible Data Import and Export](https://user-images.githubusercontent.com/46568753/121939555-24320100-cd1b-11eb-91ee-3145b7672df7.png) by Worley and Yang (also in this repository).
5. `example_data_manipulation.R`: R code for post-processing after data are read in from API to separate the data by repeating forms and non-repeating forms. 
