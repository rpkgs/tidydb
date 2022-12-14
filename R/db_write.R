#' Functions for writing data frames or delimiter-separated files to database tables.
#' 
#' @inheritParams db_read
#' @param name  a character string specifying a table name. SQLite table names
#' are not case sensitive, e.g., table names ABC and abc are considered equal.
#' @param value `data.frame` or `list` object
#' @param overwrite a logical specifying whether to overwrite an existing table
#' or not. Its default is FALSE.
#' @param append
#' a logical specifying whether to append to an existing table in the DBMS.
#' Its default is FALSE.
#' @param others to [DBI::dbWriteTable()]
#' 
#' @example R/examples/ex-db_write.R
#' @seealso [DBI::dbWriteTable()]
#' @export
db_write <- function(src, value, name = NULL, overwrite = FALSE, append = FALSE, 
  close = !is.dbi(src), ...) 
{
  .name = deparse(substitute(value))
  con = db_open(src)
  if (close) {
    on.exit(db_close(con))
  } else {
    if (!is.dbi(src) && !close) set_con(con)
  }

  if (is.data.frame(value)) {
    name %<>% `%||%`(.name)
    dbWriteTable(con, name, value, overwrite = overwrite, append = append, ...)
  } else if (is.list(value)) {
    name %<>% `%||%`(names(value))
    for (i in seq_along(value)) {
      dbWriteTable(con, name[i], value[[i]], overwrite = overwrite, append = append, ...)
    }
  }
}

write_sqlite <- db_write
