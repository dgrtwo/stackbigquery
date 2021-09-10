#' Connect to Stack Overflow BigQuery database when the package is loaded
#'
#' @param libname Library
#' @param pkgname Package name
#'
#' @exportPattern tbl|query|execute|src
.onLoad <- function(libname, pkgname) {
    # Use the internal function to create a db connection (see connections.R)
    con <- stack_create_connection()

    # Add tbl, query, execute, etc functions to the package
    package_env <- parent.env(environment())
    dbcooper::dbc_init(con, "stack", env = package_env)
}

.onUnload <- function(libpath){
    dbcooper::dbc_clear_connections()
}
