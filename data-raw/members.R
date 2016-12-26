library(dplyr)
library(rlist)
library(stringi)
library(abroadplayr)
library(tidyr)

FIX <- list(
  "C09201174" = list(member_job = "副教授兼研發長,教授兼造船系主任,教授|前任研發長|系主任"),
  "C10004718" = list(
    member_office = "國立清華大學,UniversityofWesternSydney&HaskinsL|GraduateCenter,CityUniversityofNew,HaskinsLaboratories",
    member_unit = "法國國家研究院,UniversityofWesternSydney&HaskinsL|GraduateCenter,CityUniversityofNew,HaskinsLaboratories"),
  "C09100725" = list(
    member_job = "警正,警正,警正,警正,警正,警正,警正,警佐,警正,警佐,警正,警佐,比照警佐,警正,警正,警正,警正,警正,警正,警正"
  ),
  "C09101267" = list(
    member_job = "副主席,代表,代表,代表,代表,代表,代表,組員"
  ),
  "C09500466" = list(
    member_job = "總經理,秘書,副教授,主任,專門委員,四等專員"
  )
)

to_member_df_ <- function(row) {
  id <- row$id
  n_members <- row$member_name %>% strsplit(",") %>% .[[1]] %>% length()
  str_split_choose_n <- function(string){
    splitted_str <- string %>% stringi::stri_split_fixed(., ",") %>% .[[1]]
    if (length(splitted_str) > n_members) message(id, "bad split:", string)
    return(splitted_str[1:n_members])
  }
  if (n_members == 1){
    df <- row[1:6] %>% as.data.frame(stringsAsFactors=F)
  } else{
    df <- row[2:6] %>%
      lapply(str_split_choose_n) %>%
      rlist::list.cbind() %>%
      as.data.frame(stringsAsFactors=F) %>%
      mutate(id = id) %>%
      select(id, everything())
  }
  return(df)
}

to_member_df <- function(row){
  tryCatch(
    to_member_df_(row),
    warning = function(w) message(row$id, ":", w))
}

fix_data <- function(dat){
  dat_ <- dat
  for (id in names(FIX)) {
    for (col in names(FIX[[id]])){
      dat_[dat_$id ==id, col] <- FIX[[id]][[col]]
    }
  }
  return(dat_)
}

members_raw <- reports %>%
  select(id, starts_with("member_")) %>%
  filter(member_num !=0) %>%
  fix_data()


members <- members_raw %>% rowwise() %>% do(to_member_df(.)) %>% ungroup()

devtools::use_data(members, overwrite = T)
