contrasts21 <- function(x) {
  con.sum <- sum(abs(x)) / 2
  con.mul <- (1 - con.sum) / con.sum
  y <- as.numeric(x) * (1 + con.mul)
  return(y)
}


wtf_is <- function(x) {
  # For when you have no idea what something is.
  # https://stackoverflow.com/questions/8855589
  cat("1. typeof():\n")
  print(typeof(x))
  cat("\n2. class():\n")
  print(class(x))
  cat("\n3. mode():\n")
  print(mode(x))
  cat("\n4. names():\n")
  print(names(x))
  cat("\n5. slotNames():\n")
  print(slotNames(x))
  cat("\n6. attributes():\n")
  print(attributes(x))
  cat("\n7. str():\n")
  print(str(x))
}

# Data testing and visualisation function
# diagnorm <- function(df, testvar, testname, int1, int2, facet1){
#   testi <- get(testvar, df)
#   qqnorm(testi, main = paste0(testname, " Normal Q-Q Plot"))
#   qqline(testi)
#   
#   int1 <- get(int1, df)
#   int2 <- get(int2, df)
#   df %>%
#     ggplot(aes(testi, fill=interaction(int1, int2))) + 
#     geom_density(alpha=.4) + 
#     facet_wrap(~facet1, ncol=length(as.list(facet1))) + 
#     theme_bw()
# }

# helper functions to read a dir full of trials data

my_range <- function(dat){
  retval <- max(dat) - min(dat)
  retval
}

parse_recording <- function(fname, delim = ",", skip_lines = 0){
  fn <- unlist(strsplit(file_path_sans_ext(basename(fname)), '_'))[3]
  rec <- read.csv(fname, sep = delim, header = TRUE, skip = skip_lines)
  rec <- rec %>% filter(Resp == "EMG1") %>% 
    group_by(Distractors, Task) %>% 
    summarize_at(.vars = "RT", .funs = c(var, mad, min, max, my_range)) %>% 
    rename(RTV = fn1, RTmad = fn2, MIN = fn3, MAX = fn4, RNG = fn5)
  rec$Part <- rep(fn, nrow(rec))
  rec$Prtn <- rep(parse_number(fn), nrow(rec))
  rec$Grup <- rep(substr(fn, 1, 1), nrow(rec))
  rec
}

read_all_recordings <- function(basepath, pat="", ext="", delim = ",", skip = 0) {
  file_list <- list.files(basepath, pattern = paste0(".*", pat, ".*", ext), full.names = TRUE)
  if (length(file_list) == 0){
    print('No files found!')
    return()
  }
  i = 1
  out <- parse_recording(file_list[[1]], delim, skip)
  out$File <- rep(i, nrow(out))
  for (f in file_list[-1]) {
    i = i + 1
    rec <- parse_recording(f, delim, skip)
    rec$File <- rep(i, nrow(rec))
    out <- rbind(out, rec)
  }
  out
}