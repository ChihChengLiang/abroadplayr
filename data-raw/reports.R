library(magrittr)

reports <- unz("data-raw/report.csv.zip", "report .csv") %>%
  read.csv(
    stringsAsFactors = F,
    fileEncoding = "big5",
    encoding="utf8"
    )

devtools::use_data(reports)
