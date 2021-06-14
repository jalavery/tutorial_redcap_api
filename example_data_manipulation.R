# pull data from REDCap API and separate by each repeating form vs all non-repeating forms
library(REDCapR)
library(tidyverse)

your_token <- "XXXXX"

# pull the data in from the REDCap database
# replace token with your API token
read_data_list <- redcap_read(
  redcap_uri = "https://redcap.mskcc.org/api/",
  token = your_token,
  raw_or_label = "label",
  export_checkbox_label = TRUE
)

# returns a list including the data and information about pulling from redcap
class(read_data_list)

# other than data, things returned include metadata about the API pull (messages, time, etc.)
names(read_data_list)

# only interested in the data
redcap_raw_data <- as.data.frame(read_data_list$data)

# separate the raw data by instrument
redcap_data_by_instrument <- redcap_raw_data %>% 
  split(.$redcap_repeat_instrument)

# look at names of instruments
names(redcap_data_by_instrument)

### keep variables by instrument

# variables that you want in each dataset, such as record_id
# increment the number of repetitions for form_name to correspond to the number of variables kept on each dataset
repeat_variables <- tibble(field_name = c(rep("record_id", 
                                              length(unique(redcap_raw_data$redcap_repeat_instrument)))),
                       form_name = str_replace_all(str_to_lower(rep(unique(redcap_raw_data$redcap_repeat_instrument), 
                                       1)), " ", "_"))


# also read in the data dictionary (codebook)
redcap_codebook <- bind_rows(
  REDCapR::redcap_metadata_read(redcap_uri = "https://redcap.mskcc.org/api/",
                                token = your_token)$data,
  repeat_variables)

# get names of variables in the data
# have to account for checkbox variables
# e.g. symptoms in data dictionary vs symptoms___1 - symptoms___16 in redcap data
redcap_var_names <- tibble(
  field_name = names(redcap_raw_data),
)

# remove variables that are in data dictionary but are not in data
# this could be variables that are marked as identifiers and didn't get exported
dictionary_subset <- inner_join(redcap_var_names,
                                redcap_codebook,
                                by = c("field_name"))

# get list of repeating forms (vs non-repeating forms, where redcap_repeat_instance is blank)
repeating_forms <- redcap_raw_data %>% 
  drop_na(redcap_repeat_instance) %>% 
  distinct(redcap_repeat_instrument) %>% 
  transmute(form_name = str_replace_all(str_to_lower(redcap_repeat_instrument), " ", "_"))


# keep only variables of interest on the dataset
# get data dictionary (restricted to available variables) as a list for each dataset
dictionary_split <- inner_join(dictionary_subset,
                               repeating_forms,
                               by = "form_name") %>% 
  split(.$form_name) %>%
  map(., select, field_name) %>%
  map(., as_vector) %>%
  # need to unname the vector so that the vector consists only of the variable names
  # otherwise each variable is field_name1, field_name2, etc.
  map(., unname)

# have to make sure that the order of these two lists are aligned
names(redcap_data_by_instrument)
names(dictionary_split)

# map over each dataset to keep only the variables belonging to that dataset
new_split <- mapply(select, redcap_data_by_instrument, dictionary_split)

names(new_split)

# rename to remove any spaces and capitalization
# label datasets according to cohort, will be used to combine later
for (i in 1:length(names(new_split))) {
  names(new_split)[i] = str_replace_all(str_to_lower(names(new_split)[i]), " ", "_")
}

# look at new names
names(new_split)

# return new datasets to the environment
list2env(new_split, envir = globalenv())

# remove intermediate objects
rm(dictionary_split, dictionary_subset, new_split, read_data_list, redcap_data_by_instrument, redcap_var_names, repeat_variables, repeating_forms)

# further manipulation needed if you want to separate out the instruments that are all 1 rec/patient
# currently they are all combined into a single instrument


