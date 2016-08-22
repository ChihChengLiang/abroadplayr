library(magrittr)
library(dplyr)

reports <- unz("data-raw/report.csv.zip", "report .csv") %>%
  read.csv(
    stringsAsFactors = F,
    fileEncoding = "big5",
    encoding="utf8"
    ) %>%
  mutate_if(
    function(col) is.character(head(col)),
    function(col) `Encoding<-`(col, "UTF-8")
    )

devtools::use_data(reports, overwrite = T)
