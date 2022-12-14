#' open data.base
#' 
#' @inheritParams DBI::dbConnect
#' @param con A [DBI::dbConnect()] object or db path
#' 
#' @example R/examples/ex-db_write.R
#' 
#' @seealso [DBI::dbConnect()]
#' @import DBI
#' @export 
db_open <- function(con = ":memory:", ...) {
  # con = path
  if (is.null(con)) con = .options$con
  if (!("SQLiteConnection" %in% class(con)) && is.character(con)) {
    con <- DBI::dbConnect(RSQLite::SQLite(), dbname = con, ...)
  }
  con
}

#' @rdname db_open
#' @export
is.dbi <- function(con) {
  ("SQLiteConnection" %in% class(con))
}

db_is_opened <- is.dbi

# also named as `sqlite_con`
sqlite_con <- db_open
db_sqlite <- db_open

#' @rdname db_open
#' @export
db_close <- function(con = NULL) {
  if (is.null(con)) con = .options$con
  if (!is.null(con)) {
    dbDisconnect(con)
    .options$con = NULL
  } else {
    message(sprintf("No dbConnect in backends."))
  }
  invisible()
}


set_con <- function(con) {
  if (!is.null(.options$con)) {
    message("[set_con]: close previous con")
    db_close(.options$con)
  }
  if (!is.null(con)) {
    message("[set_con]: set new con")
    .options$con <- db_open(con)
  }
}

get_con <- function() {
  .options$con
}
