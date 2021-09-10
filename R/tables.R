# There are some tables that would be useful in bigquery but don't exist
# Define functions for them here (ideally they would be late binding
# or materialized views)

#' Match question IDs to tags
stack_question_tags <- function() {
    stack_query("SELECT id AS question_id, tag FROM posts_questions,
                    UNNEST(split(tags, '|')) AS tag") %>%
        dplyr::select(question_id, tag)
}
