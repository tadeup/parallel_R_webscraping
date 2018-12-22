library(rvest)
library(dplyr)
library(parallel)


#### SET WORKING DIRECTORIES ####
setwd("C:\\Users\\tadeu\\Desktop\\FGV\\code\\anthony")
setwd('/home/tadeup/Documents/code/anthony')

#### DECLARE SCRAPING FUNCTION ####
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


#### DETECT REMAINING INTERVAL ####

## PC 1 ##
interval <- 3000000:4000000

## PC 2 ##
interval <- 4000001:7821405


files <- list.files(path = "res",pattern = ".rds")
completed_files <- substring(files, 6, 12) %>% as.numeric()

stacks <- list.files(path = "stacks",pattern = ".rds")
completed_stacks <- lapply(stacks, function(x)readRDS(sprintf("stacks/%s",x))) %>%
  do.call(what = "rbind.data.frame") %>%
  select(index) %>%
  unlist() %>%
  as.character() %>%
  as.numeric()
  

new_interval <- interval[!(interval %in% completed_files)]
new_interval <- new_interval[!(new_interval %in% completed_stacks)]


#### INIT CLUSTER AND START SCRAPING ####
cl <- makeCluster(detectCores())
clusterEvalQ(cl, { library(rvest) })

parLapply(cl, new_interval, scrape_rds)

stopCluster(cl)
