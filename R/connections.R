# Logic responsible for creating the bigquery connection
# In other database packages, this could be very specific

#' Get the BigQuery billing project ID
#'
#' If bigquery_billing_project isn't set, raises an error.
bigquery_billing_project <- function() {
    ret <- Sys.getenv("BIGQUERY_BILLING_PROJECT")

    if (!nzchar(ret)) {
        stop("Must set BIGQUERY_BILLING_PROJECT, and perhaps ",
             "(if you have multiple accounts) BIGQUERY_EMAIL, in your ",
             ".Renviron to use stackbigquery")
    }

    email <- Sys.getenv("BIGQUERY_EMAIL")

    if (nzchar(email) && is.null(getOption("gargle_oauth_email"))) {
        options(gargle_oauth_email = email)
    }

    ret
}

stack_create_connection <- function() {
    DBI::dbConnect(bigrquery::bigquery(),
                   project = "bigquery-public-data",
                   dataset = "stackoverflow",
                   billing = bigquery_billing_project())
}
