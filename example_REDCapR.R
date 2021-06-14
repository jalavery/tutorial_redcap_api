library(REDCapR)

# pull the data in from the REDCap database
# replace token with your API token
read_data_list <- redcap_read(
  redcap_uri = "https://redcap.mskcc.org/api/",
  token = "XXXXXX",
  raw_or_label = "label",
  export_checkbox_label = TRUE
)

# returns a list including the data and information about pulling from redcap
class(read_data_list)

# other than data, things returned include metadata about the API pull (messages, time, etc.)
names(read_data_list)

# only interested in the data
redcap_raw_data <- as.data.frame(read_data_list$data)
