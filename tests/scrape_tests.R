library(rvest)

2000000:7821405
scrape_rds <- function(index){
  
  url_list_element <- sprintf("https://www.infomoney.com.br/mercados/noticia/%s", index)
  
  pag1 <- read_html(url_list_element) 
  
  date <- pag1 %>%
    html_node(".article__date") %>%
    html_text()
  
  title <- pag1 %>%
    html_node(".article__title") %>%
    html_text()
  
  res <- list(index = index, date = date, title = title)
  saveRDS(res, sprintf("res//page_%s.rds", index))
}

scrape_csv <- function(index){
  
  url_list_element <- sprintf("https://www.infomoney.com.br/mercados/noticia/%s", index)
  
  pag1 <- read_html(url_list_element) 
  
  date <- pag1 %>%
    html_node(".article__date") %>%
    html_text()
  
  title <- pag1 %>%
    html_node(".article__title") %>%
    html_text()
  
  res <- list(index = index, date = date, title = title)
  write.csv(res, sprintf("res//page_%s.csv", index))
}

start_time <- Sys.time()
lapply(31:40, scrape)
end_time <- Sys.time()

start_time - end_time



# Calculate the number of cores
no_cores <- detectCores()

# Initiate cluster
cl <- makeCluster(no_cores)
clusterEvalQ(cl, { library(rvest) })  # you need to export packages as well
start_time <- Sys.time()
parLapply(cl, 71:80, scrape_csv)
end_time <- Sys.time()
start_time - end_time
stopCluster(cl)

cl <- makeCluster(no_cores)
clusterEvalQ(cl, { library(rvest) })  # you need to export packages as well
start_time <- Sys.time()
parLapply(cl, 81:90, scrape_rds)
end_time <- Sys.time()
start_time - end_time
stopCluster(cl)



readRDS("res//page_1.rds")

