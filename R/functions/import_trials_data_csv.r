# MOT ADHD Version
# Import subject trials data to R
# Last edit: Sami 06.03.2018

# Function to import trials data
import_trials_data <- function(dpath) {
  
  library(tidyverse)
  
  fnames <- list.files(path = dpath, recursive = TRUE)
  
  for (sub in 1:length(fnames)){
    
    # Get subject ID from filename (expects proper filename format, e.g.
    #   "trials_events_PXXXX.csv").
    sub_id <- strsplit(sub(".csv", "", fnames[sub]), "_")[[1]][3]
    
    subdata <- read_csv(file = file.path(dpath, fnames[sub]), 
                        col_names = TRUE)
    
    # Add ID & subject group to dataframe.
    subdata <- add_column(ID = sub_id, subdata, .before = 1)
    
    if(substring(sub_id, 1, 1) == "P"){
      tmp_group <- "ADHD"
    } else{
      tmp_group <- "Control"
    }
    
    subdata <- add_column(Group = tmp_group, subdata, .before = 2)
    
    # Aggregate.
    if(!exists("all_trials")){
      all_trials <- subdata
      
    } else{
      all_trials <- rbind(all_trials, subdata)
      
    }
  }
  
  return(all_trials)
  
}

