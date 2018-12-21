install.packages("Rcrawler")

setwd("C:\\Users\\tadeu\\Desktop\\FGV\\code\\anthony")

library(Rcrawler)
library(dplyr)
library(parallel)
library(xlsx)
detectCores()


#########################################################


Rcrawler(Website = "https://www.infomoney.com.br/mercados/noticia/", no_cores = 4, no_conn = 4, ExtractCSSPat = c(".article__date",".article__title"), PatternsNames = c("Date","Title"))

Data<-ContentScraper(Url = "https://www.infomoney.com.br/mercados/noticia/1", CssPatterns = c(".article__date",".article__title"))

Rcrawler(Website = "https://www.infomoney.com.br/",
         no_cores = 4, no_conn = 4,
         ExtractCSSPat = c(".article__date",".article__title"),
         PatternsNames = c("Date","Title"),
         dataUrlfilter = "/noticia/", crawlUrlfilter ="/noticia/")

df<- as.data.frame(do.call("rbind", DATA)) %>%
  complete.cases()

df <- lapply(DATA, function (m) data.frame(m, stringsAsFactors = F)) %>%
  do.call(what = rbind) %>%
  .[complete.cases(.),2:3]


url_list <- sprintf("https://www.infomoney.com.br/mercados/noticia/%s",2000000:7821405)

for( i in 0:(length(url_list)/1000)){
  ContentScraper(url_list[(i*1000+1):((i+1)*1000)], CssPatterns = c(".article__date",".article__title"),
                 PatternsName = c("Date","Title")) %>%
    lapply(function (m) data.frame(m, stringsAsFactors = F)) %>%
    do.call(what = rbind) %>%
    write.table("infomoney\\anthony.csv",
                append = T,
                row.names = F,
                sep = ",",
                col.names=!file.exists("infomoney\\anthony.csv"))
  print(i)
}

(i*1000+1):((i+1)*1000)
write.xlsx(df, "anthony.xlsx")

##########################################################################

df <- read.csv("infomoney\\anthony.csv", stringsAsFactors = F)
df2 <- df[!grepl("LEILAO", df$Title),] %>%
  .[!grepl("OFERTAS DISPONIVEIS NO BANCO DE TITULOS", .$Title),] %>%
  .[complete.cases(.),]
