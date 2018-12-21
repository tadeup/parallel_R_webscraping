library(rvest)

scrape_rds <- function(index){
  
  url_list_element <- sprintf("https://www.infomoney.com.br/mercados/noticia/%s", index)
  
  for(i in 1:10){
    try({
      pag1 <- read_html(url_list_element)
      
      date <- pag1 %>%
        html_node(".article__date") %>%
        html_text()
      
      title <- pag1 %>%
        html_node(".article__title") %>%
        html_text()
      
      res <- list(index = index, date = date, title = title)
      saveRDS(res, sprintf("res//page_%s.rds", index))
      
      break
    }, silent = F)
    Sys.sleep(2)
  }
}

interval <- 3000000:7821405

cl <- makeCluster(detectCores())
clusterEvalQ(cl, { library(rvest) })  # you need to export packages as well

parLapply(cl, interval, scrape_rds)

start_time - end_time
stopCluster(cl)