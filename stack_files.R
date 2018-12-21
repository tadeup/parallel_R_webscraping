library(tidyverse)

files <- list.files(path = "res",pattern = ".rds")
stack <- do.call("rbind", lapply(files, function(x)readRDS(sprintf("res/%s",x))))


completed <- substring(files, 6, 12) %>% as.numeric()

new_interval <- interval[!(interval %in% completed)]
