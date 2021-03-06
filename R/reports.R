#' ROC Government Travel Reports
#'
#' This dataset covers reports of government travel.
#' See \url{https://g0v.hackpad.com/E0G6gZDQ2ZZ} for more detail.
#'
#' @source \url{https://drive.google.com/drive/folders/0B44pNgi6s_pGRDlsSWdUck5fZ1k}, downloaded 2016-08-22
#' @format Data frame with columns
#' \describe{
#' \item{gov}{Central or municipal government}
#' \item{id}{}
#' \item{plan_name}{}
#' \item{report_name}{}
#' \item{main_file}{Download url of the full report}
#' \item{other_file}{other attachment of the report}
#' \item{report_date}{}
#' \item{report_page}{}
#' \item{office}{}
#' \item{member_name}{}
#' \item{member_office}{}
#' \item{member_unit}{}
#' \item{member_job}{}
#' \item{member_level}{}
#' \item{member_num}{How many members in this travel}
#' \item{start_date}{}
#' \item{end_date}{}
#' \item{area}{}
#' \item{visit}{What are members paying a visit to}
#' \item{type}{Type of traveling purpose}
#' \item{keyword}{}
#' \item{note}{}
#' \item{topic_cat}{Category by topic}
#' \item{adm_cat}{Administration category}
#' \item{summary}{}
#' \item{word}{}
#' \item{wiki_page}{}
#' }
#' @examples
#' reports_df<- reports
"reports"

#' Members of The Travel Reports
#'
#' Extracted from reports
#'
#' @format Data frame with columns
#' \describe{
#' \item{id}{Report id, join this id with table 'reports'}
#' \item{member_name}{}
#' \item{member_office}{}
#' \item{member_unit}{}
#' \item{member_job}{}
#' \item{member_level}{}
#' }
#' @examples
#' members
"members"
