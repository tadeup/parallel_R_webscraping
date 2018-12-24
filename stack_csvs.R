path <- "python\\results"

files <- list.files(path = "python/results",pattern = ".csv")

all_files <- lapply(files, function(x)read.csv(sprintf("python/results/%s",x), stringsAsFactors = F)) %>%
  do.call(what = "rbind.data.frame")

completed_stacks <- list.files(path = "stacks",pattern = ".rds") %>%
  lapply(function(x)readRDS(sprintf("stacks/%s",x))) %>%
  do.call(what = "rbind.data.frame")

saveRDS(all_files, "python/results/stack1.rds")
