* OPTION 2: Access API via SAS directly via PROC HTTP;
* Code from: https://www.mwsug.org/proceedings/2013/RX/MWSUG-2013-RX02.pdf;

/**********************************************************
Step 1. Initial setup
***********************************************************/
* Text file for API parameters that the define the request sent to REDCap API. Extension can be .csv, .txt, .dat;
* This file is created by this program, just specify location here;
filename my_in "C:\Users\laveryj\Desktop\tutorial_redcap_api\sas_option2_api_parameter.txt";

* .csv output file to contain the exported data;
filename my_out "C:\Users\laveryj\Desktop\tutorial_redcap_api\redcap_raw_data.csv";

* Output file to contain PROC HTTP status information returned from REDCap API (this is optional);
filename status "C:\Users\laveryj\Desktop\tutorial_redcap_api\sas_option2_redcap_status.txt";

* Project- and user-specific token obtained from REDCap;
* do NOT put quotes around token;
%let mytoken = XXXX;

/**********************************************************
Step 2. Request all observations from REDCap and 
write to CSV file
***********************************************************/

* Create the text file to hold the API parameters (should not need to modify);
data _null_ ;
	file my_in ;
	put "%NRStr(token=)&mytoken%NRStr(&content=record&type=flat&format=csv)&";
run;

* PROC HTTP call. Everything except HEADEROUT= is required. ***;
* this creates redcap_raw_data.csv;
proc http
	in= my_in
	out= my_out
	headerout = status
	url ="https://redcap.mskcc.org/api/"
	method="post";
run;

/**********************************************************
Step 3. Read CSV file back into SAS
***********************************************************/
PROC IMPORT OUT= WORK.redcap_raw_data 
            DATAFILE= "C:\Users\laveryj\Desktop\tutorial_redcap_api\redcap_raw_data.csv" 
            DBMS=CSV REPLACE;
     GETNAMES=YES;
     DATAROW=2; 
RUN;
