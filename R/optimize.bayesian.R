#' Bayesian Optimization
#'
#' \code{optimize.bayesian} performs bayesian optimization on a given loss function and parameters. This is a wrapper to \code{mlrMBO} optimizer for quick and fast optimization.
#'
#' Please see vignette for demos: \code{vignette("optimize.bayesian", package = "Laurae2")} or \code{help_me("optimize.bayesian")}.
#'
#' @param loss_func Type: function. The loss function. Takes as input a list of elements.
#' @param param_set Type: ParamHelpers::makeParamSet. The parameters to optimize. Check out ParamHelpers::makeParamSet for more information.
#' @param seed Type: numeric. Seed for random number generation. Defaults to \code{1}.
#' @param maximize Type: logical. Whether to minimize (\code{FALSE}) or maximize (\code{TRUE}) the loss function. Defaults to \code{FALSE}.
#' @param absurd_value Type: numeric. An absurd value when an error or invalid value is provided by the loss function which is the reverse of the best possible loss value. Defaults to \code{ifelse(maximize == TRUE, -Inf, Inf)}.
#' @param exp_design Type: matrix. The default matrix used to initialize the optimizer. Defaults to \code{NULL}.
#' @param initialization Type: numeric. The number of \code{loss_func} initializations to provide a start point for the bayesian optimizer. Defaults to \code{nrow(exp_design)}.
#' @param max_evaluations Type: numeric. The number of times the loss function can be evaluated, including the initialization part. Defaults to \code{50}.
#' @param time_budget Type: numeric. The maximum time spent in the loss function globally. The optimization hands down the results to the user when the time budget is exhausted or the maximum number of evaluations is reached. Defaults to \code{NULL}.
#' @param verbose Type: logical. Whether to print debug messages. Defaults to \code{TRUE}.
#'
#' @return
#' @export
#'
#' @importFrom utils vignette
#'
#' @examples


optimize.bayesian <- function(loss_func, param_set, seed = 1, maximize = FALSE, absurd_value = ifelse(maximize == TRUE, -Inf, Inf), exp_design = NULL, initialization = nrow(exp_design), max_evaluations = 50, time_budget = NULL, verbose = TRUE) {

  set.seed(seed)

  opt_function <- smoof::makeSingleObjectiveFunction(
    name = "Loss function",
    fn = function(x) {loss_func(x)},
    par.set = param_set,
    minimize = !maximize
  )

  opt_control <- mlrMBO::makeMBOControl(impute.y.fun = function(x, y, opt.path, ..., absurd_value = absurd_value) {return(-absurd_value)})

  opt_control <- mlrMBO::setMBOControlInfill(opt_control,
                                             crit = mlrMBO::crit.ei)

  opt_control <- mlrMBO::setMBOControlTermination(opt_control,
                                                  max.evals = max_evaluations,
                                                  time.budget = time_budget)

  if (is.null(exp_design)) {
    experimental_design <- ParamHelpers::generateDesign(n = initialization,
                                                        par.set = ParamHelpers::getParamSet(opt_function),
                                                        fun = lhs::randomLHS)
  } else {
    experimental_design <- exp_design
  }

  surrogate_learner <- mlrMBO::makeMBOLearner(control = opt_control,
                                              fun = opt_function,
                                              config = list(show.learner.output = FALSE))

  solutions <- suppressWarnings(mlrMBO::mbo(fun = opt_function,
                                            design = experimental_design,
                                            learner = surrogate_learner,
                                            control = opt_control,
                                            show.info = verbose))

  return(solutions)

}
