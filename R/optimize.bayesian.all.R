#' Bayesian Optimization, All Results Set
#'
#' \code{optimize.bayesian.all} gets all the results issued from \code{optimize.bayesian}.
#'
#' Please see vignette for demos: \code{vignette("optimize.bayesian", package = "Laurae2")} or \code{help_me("optimize.bayesian")}.
#'
#' @param optimized Type: List returned from \code{optimize.bayesian}. The object to look for all the results.
#'
#' @return A data.frame containing all the results set from the bayesian optimization. A column y refers to the loss function value for the according parameters on the same row.
#' @export
#'
#' @examples

optimize.bayesian.all <- function(optimized) {
  return(optimized$opt.path$env$path)
}
