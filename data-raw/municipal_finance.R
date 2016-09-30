# Download html file from: http://statdb.dgbas.gov.tw/pxweb/dialog/statfile9.asp

library(rvest)
library(stringi)
library(dplyr)
library(tidyr)

doc <- read_html("data-raw/CS2501A1A.htm", encoding = "big5")

cities <- doc %>%
  html_nodes('tr[align="LEFT"]') %>%
  .[2] %>%
  html_text(trim = T) %>%
  stri_replace_all_fixed(" ", "") %>%
  stri_split_lines1()

data_rows <- doc %>% html_nodes('tr[align="RIGHT"]')

extract_nodes_text <- function(doc, css) doc %>%
  html_nodes(css) %>% html_text(trim = T)

extract_row <- function(data_row){
  ths <- extract_nodes_text(data_row, "th")
  tds <- extract_nodes_text(data_row, "td")
  data_name <- ifelse(length(ths)==2, ths[1], NA)
  year <- ifelse(length(ths)==2, ths[2], ths[1])
  row <- c(data_name, year, tds)
  return(row)
}

municipal_finance_raw <- data_rows %>%
  lapply(extract_row) %>%
  do.call(rbind, .) %>%
  `colnames<-`(c("data_name", "year", cities)) %>%
  tbl_df() %>%
  fill(data_name)

municipal_finance <- municipal_finance_raw %>%
  gather(cities,value, -data_name, -year) %>%
  mutate(
    year = as.integer(year),
    value = as.numeric(value)
  ) %>%
  spread(data_name, value)

foot_notes <- doc %>%
  html_nodes("table > tr:last-child > td") %>%
  html_text()
foot_notes_group <- foot_notes %>%
  stri_split_regex(
    "------------------------------ ",
    omit_empty = T) %>%
  .[[1]]

extract_df_from_group <- function(group){
  col <- group %>%
    stri_match_first_regex("指標項：(.*)\\r\\n") %>% .[1,2]
  definition <- group %>%
    stri_match_first_regex("定義：(.*)\\r\\n") %>% .[1,2]
  formula <- group %>%
    stri_match_first_regex(
      "\\n公式：((.|\\r\\n)*)\\r\\n註記：") %>% .[1,2]
  note <- group %>%
    stri_match_first_regex("\\r\\n註記：((.|\\r\\n)*)") %>%
    .[1,2] %>%
    stri_replace_all_regex("(\\r\\n| )", "")
  return(
    data.frame(col, definition, formula, note,
               stringsAsFactors = F)
    )
}

# These are for testing
# foot_notes_group[46] %>% stri_match_first_regex("指標項：(.*)\\r\\n") %>% .[1,2]
# foot_notes_group[46] %>% stri_match_first_regex("定義：(.*)\\r\\n") %>% .[1,2]
# foot_notes_group[41] %>% stri_match_first_regex("\\n公式：((.|\\r\\n)*)\\r\\n註記：") %>% .[1,2]
# foot_notes_group[41] %>%stri_match_first_regex("\\r\\n註記：((.|\\r\\n)*)") %>% .[1,2] %>%
#   stri_replace_all_regex("(\\r\\n| )", "")
#
# foot_notes_group[46] %>% extract_df_from_group
# foot_notes_group[41] %>% extract_df_from_group

foot_note_df <- foot_notes_group %>%
  lapply(extract_df_from_group) %>%
  bind_rows() %>%
  mutate_if(
    function(col) is.character(head(col)),
    function(col) `Encoding<-`(col, "UTF-8")
  )


devtools::use_data(municipal_finance, overwrite = T)
devtools::use_data(foot_note_df, overwrite = T)
write(foot_notes, file = "data/foot_notes.txt")
