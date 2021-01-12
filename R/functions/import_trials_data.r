# MOT ADHD Version
# Import subject data to R
# Last edit: Sami 15.08.2017

setwd('O:/MOT/MOT_Data/adhd/data/behavioral/data')

#### Read subject data from demographics file -------------------
demographics_fpath <- paste0("O:/MOT/MOT_Data/adhd/documentation/demographics/", 
                             "adhd_mot_demographics.xlsx")

demographics_data <- readxl::read_xlsx(demographics_fpath)


#### Read trials data for subjects -------------------
for (sub in demographics_data$id_mot) {
  
  demographics_data %>% 
    filter(id_mot == sub) %>% 
    select(id) -> tmp_id
  
  # Read single subject trials data
  sub_file_path <- paste0("adhd_sub", formatC(sub, width=2, flag=0), ".dat")
  
  if(file.exists(sub_file_path)) {
  
    sub_trials <- as.data.frame(read.csv(sub_file_path, header = FALSE))
    
    sub_trials <- as_tibble(data.frame(id = tmp_id$id, sub_trials))
  
    colnames(sub_trials) <- c("id", "trial_index", "trial_type", "coord_x", 
                              "coord_y", "task", "distractor_state", "response", 
                              "reaction_time")
    
    # Recode variable types & levels
    sub_trials$trial_type <- factor(sub_trials$trial_type, 
                                    labels=c("real", "catch"), 
                                    levels=c("84", "67") )
    
    sub_trials$response <- factor(sub_trials$response,
                                  labels = c("hit", "miss", "false_alarm"),
                                  levels = c("1", "2", "3"))
    
    
    sub_trials$distractor_state <- factor(sub_trials$distractor_state,
                                          labels = c("present", "absent"),
                                          levels = c("1", "2"))
    
    sub_trials$task <- factor(sub_trials$task, 
                              labels = c("attend_left", "attend_right",
                                        "attend_full", "attend_none"),
                              levels = c("0", "1", "2", "3"))
    
    cat(sprintf("Imported data for subject %d.\n", sub))
    
    # Combine with rest
    if(!exists("trials_data")) {
      trials_data <- sub_trials
      
    } else{
      trials_data <- rbind(trials_data, sub_trials)
      
    }
  
  }
  
}

rm(sub_trials, tmp_id, demographics_fpath, sub, sub_file_path)
# 
# ## Get subject data
# if ((file.exists("all_trials_data.csv")) & (file.exists("group_data.csv"))) {
#   # Read files
#   all_trials_data <- read.csv(file = "all_trials_data.csv")
#   group_data <- read.csv(file = "group_data.csv")
#   
#   # Adjust for read.csv mistakes...
#   all_trials_data$ID <- as.factor(all_trials_data$ID)
#   group_data$ID <- as.factor(group_data$ID)
#   
#   # Check which subjects exist
#   existing_subs <- as.integer(levels(all_trials_data$ID))
#   new_subs <- subjects[!is.element(subjects, existing_subs)]
#   
# } else {
#   
#   new_subs <- subjects
#   
# }
# 
# ## Analyze & add new subjects if needed
# if (length(new_subs)>0) {
#   for (sub in new_subs) {
#     
#     cat(sprintf("Processing subject %d\
#", sub))
#     sub_file_path <- paste0("adhd_sub", formatC(sub, width=2, flag=0), ".dat")
#     
#     # Get subject trials
#     sub_trials <- clean_data(sub_file_path)
#     sub_trials <- preprocess_data(sub_trials, rt_min, rt_max)
#     sub_trials <- add_demographics(id=sub,
#                                     group=subject_variables[[sub]][[2]],
#                                     sex=subject_variables[[sub]][[3]],
#                                     age=subject_variables[[sub]][[4]],
#                                     handedness=subject_variables[[sub]][[5]],
#                                     response_hand=subject_variables[[sub]][[6]],
#                                     sub_trials)
#     
#     # Get subject performance
#     sub_performance <- get_single_subject_task_performance(sub_trials)
#     sub_performance <- add_demographics(id=sub,
#                                         group=subject_variables[[sub]][[2]],
#                                         sex=subject_variables[[sub]][[3]],
#                                         age=subject_variables[[sub]][[4]],
#                                         handedness=subject_variables[[sub]][[5]],
#                                         response_hand=subject_variables[[sub]][[6]],
#                                         sub_performance)
#     
#     # Append existing data
#     if(!exists("group_data")) {
#       all_trials_data <- sub_trials
#       group_data <- sub_performance
#     } else {
#       all_trials_data <- rbind(all_trials_data, sub_trials)
#       group_data <- rbind(group_data, sub_performance)
#     }
#     
#     # Save
#     write.csv(all_trials_data, file="all_trials_data.csv", row.names=FALSE)
#     write.csv(group_data, file="group_data.csv", row.names=FALSE)
#     
#   }
#   
#   assign("all_trials_data", all_trials_data, envir=.GlobalEnv)
#   assign("group_data", group_data, envir=.GlobalEnv)
#   
# }
