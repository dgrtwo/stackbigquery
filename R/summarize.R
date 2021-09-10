#' Given a grouped remote table of posts, summarize tags
#'
#' @param tbl A remote grouped table based on
#' @param tags Optionally, a vector of tags to summarize
#' @param question_id Which column represents the question ID?
#'
#' @importFrom dplyr %>%
#'
#' @export
summarize_tags <- function(tbl, tags = NULL, question_id = "id") {
    g <- dplyr::group_vars(tbl)

    tag_tbl <- stack_question_tags()
    if (!is.null(tags)) {
        tag_tbl <- tag_tbl %>%
            dplyr::filter(tag %in% tags)
    }

    by <- stats::setNames("question_id", question_id)
    numerator <- tbl %>%
        dplyr::inner_join(tag_tbl, by = by) %>%
        dplyr::group_by(tag, .add = TRUE) %>%
        dplyr::summarize(number = n()) %>%
        dplyr::collect()

    totals <- tbl %>%
        dplyr::summarize(total = n()) %>%
        dplyr::collect()

    numerator %>%
        dplyr::inner_join(totals, by = g) %>%
        dplyr::mutate(percent = number / total) %>%
        dplyr::ungroup()
}
