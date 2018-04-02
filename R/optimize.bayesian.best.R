#' Bayesian Optimization, Best Result Set
#'
#' \code{optimize.bayesian.best} gets the best result issued from \code{optimize.bayesian}.
#'
#' Please see vignette for demos: \code{vignette("optimize.bayesian", package = "Laurae2")} or \code{help_me("optimize.bayesian")}.
#'
#' @param optimized Type: List returned from \code{optimize.bayesian}. The object to look for the best result.
#'
#' @return A list where \code{x} is the list of the best parameter set, where \code{y} is the loss value at the \code{x} parameters, and where \code{iter} is the best iteration number.
#' @export
#'
#' @examples

optimize.bayesian.best <- function(optimized) {
  return(list(x = optimized$x, y = optimized$y, iter = optimized$best.ind))
}
