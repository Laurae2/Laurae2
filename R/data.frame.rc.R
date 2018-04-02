#' data.frame Creation, [R,C] defined
#'
#' \code{data.frame.rc} creates a \code{data.frame} using the [R,C] format like `matrix` (arguments: `nrow`, `ncol`).
#'
#' Please see vignette for demos: \code{vignette("data.frame.rc", package = "Laurae2")} or \code{help_me("data.frame.rc")}.
#'
#' @param values Type: list or vector to repeat. The values inside the data.frame.
#' @param nrow Type: numeric. The number of rows in the data.frame to create.
#' @param ncol Type: numeric. The number of columns in the data.frame to create. Defaults to \code{length(values)}.
#' @param column_names Type: character. The names of the columns in the data.frame to create. Defaults to \code{names(values)}.
#'
#' @return A data.frame with [nrow, ncol] strucure specified, along with column names (defaults to \code{V1, V2, V3...})
#' @export
#'
#' @examples
#'
#' # Create default named [5, 5] data.frame
#' data.frame.rc(0, nrow = 5, ncol = 5)
#'
#' # Create named [5, 5] data.frame
#' data.frame.rc(0, nrow = 5, ncol = 5,
#'               column_names = c("car", "minicooper", "truck", "porsche", "speedo"))
#'
#' # Create named [5, 5] data.frame with values
#' data.frame.rc(list(1:5,
#'                    c(TRUE, FALSE, TRUE, FALSE, TRUE),
#'                    5:1,
#'                    c("has", "not", "has", "not", "has"),
#'                    c(150L, 200L, 250L, 300L, 350L)),
#'               nrow = 5, ncol = 5)
#'
#' # Create named [5, 5] data.frame with named values
#' data.frame.rc(list(1:5,
#'                    c(TRUE, FALSE, TRUE, FALSE, TRUE),
#'                    5:1,
#'                    c("has", "not", "has", "not", "has"),
#'                    c(150L, 200L, 250L, 300L, 350L)),
#'               nrow = 5, ncol = 5,
#'               column_names = c("car", "minicooper", "truck", "porsche", "speedo"))
#'
#' # Create named [5, 5] data.frame with values
#' data.frame.rc(list(car = 1:5,
#'                    minicooper = c(TRUE, FALSE, TRUE, FALSE, TRUE),
#'                    truck = 5:1,
#'                    porsche = c("has", "not", "has", "not", "has"),
#'                    speedo = c(150L, 200L, 250L, 300L, 350L)),
#'               nrow = 5, ncol = 5)

data.frame.rc <- function(values, nrow, ncol = length(values), column_names = names(values)) {

  if (is.list(values)) {

    if (is.null(column_names)) {
      names(values) <- paste0("V", seq_len(ncol))
      return(structure(values, .Names = paste0("V", seq_len(ncol)), row.names = c(NA, -nrow), class = "data.frame"))
    } else {
      return(structure(values, .Names = column_names, row.names = c(NA, -nrow), class = "data.frame"))
    }

  } else {

    if (is.null(column_names)) {
      return(structure(lapply(paste0("V", seq_len(ncol)), function(x, n, val) {rep_len(val, length.out = n)}, n = nrow, val = values), .Names = paste0("V", seq_len(ncol)), row.names = c(NA, -nrow), class = "data.frame"))
    } else {
      return(structure(lapply(column_names, function(x, n, val) {rep_len(val, length.out = n)}, n = nrow, val = values), .Names = column_names, row.names = c(NA, -nrow), class = "data.frame"))
    }

  }

}

