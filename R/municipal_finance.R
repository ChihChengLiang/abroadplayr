#' ROC Municipal Financial Statistics
#'
#' Historical ROC municipal financial statistics fetched from
#' the website of Directorate General of Budget, Accounting
#' and Statistics, Executive Yuan.
#'
#' @source \url{http://statdb.dgbas.gov.tw/pxweb/dialog/statfile9.asp}, downloaded 2016-09-11
#' @format Data frame with columns
#' \describe{
#' \item{year}
#' \item{cities}
#' \item{financial report items}{items of statistics, check foot note for detail}
#' }
#' @examples
#'    municipal_finance[municipal_finance$year == 2015,]
#'
#'    # Here are some options you can view the foot note
#'    View(foot_note_df)
#'    foot_note_df[46, ]
#'    write(foot_notes, "foot_notes.txt")
"municipal_finance"
