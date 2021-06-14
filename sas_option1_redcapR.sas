/* Code to read data from REDCap API */
* OPTION 1: Call R through SAS;

/* prior to running:
	1. Specify -rlang on SAS startup option list
	2. Install REDCapR and RCurl in R
*/

PROC OPTIONS OPTION=RLANG;RUN;
PROC IML;
SUBMIT/R;
library(REDCapR)
library(RCurl)

read_data_list <- REDCapR::redcap_read(
  redcap_uri = "https://redcap.mskcc.org/api/",
  token = "XXXX",
  raw_or_label = "label",
  export_checkbox_label = TRUE
)

redcap_raw_data <- as.data.frame(read_data_list$data)

ENDSUBMIT;
call ImportDataSetFromR("Work.MyData", "redcap_raw_data");
QUIT;
PROC PRINT DATA=MYDATA; RUN;
