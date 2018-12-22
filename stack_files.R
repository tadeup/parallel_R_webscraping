
files <- list.files(path = "res",pattern = ".rds")

stack <- do.call("rbind", lapply(files, function(x)readRDS(sprintf("res/%s",x))))

new_stack_index <- list.files(path = "stacks",pattern = ".rds") %>%
  substring(6,6) %>%
  as.numeric() %>%
  sort(decreasing = F) %>%
  tail(1) + 1

saveRDS(stack, sprintf("stacks/stack%s.rds", new_stack_index))
