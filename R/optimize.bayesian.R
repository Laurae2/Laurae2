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
#' \dontrun{
#' library(xgboost)
#' library(mlrMBO)
#'
#' # Load demo data
#' data(EuStockMarkets)
#'
#' # Transform dataset to "quantiles"
#' for (i in 1:4) {
#'   EuStockMarkets[, i] <- (ecdf(EuStockMarkets[, i]))(EuStockMarkets[, i])
#' }
#'
#' # Create datasets: 1500 observations for training, 360 for testing
#' # Features are:
#' # -- Deutscher Aktienindex (DAX),
#' # -- Swiss Market Index (SMI),
#' # -- and Cotation Assistee en Continu (CAC)
#' # Label is Financial Times Stock Exchange 100 Index (FTSE)
#' dtrain <- xgb.DMatrix(EuStockMarkets[1:1500, 1:3], label = EuStockMarkets[1:1500, 4])
#' dval <- xgb.DMatrix(EuStockMarkets[1501:1860, 1:3], label = EuStockMarkets[1501:1860, 4])
#'
#' # Create watchlist for monitoring metric
#' watchlist <- list(train = dtrain, eval = dval)
#'
#' # Our loss function to optimize: minimize RMSE
#' xgboost_optimization <- function(x) {
#'
#'   # Train the model
#'   gc(verbose = FALSE)
#'   set.seed(1)
#'   model <- xgb.train(params = list(max_depth = x[1],
#'                                    subsample = x[2],
#'                                    tree_method = x[3],
#'                                    eta = 0.2,
#'                                    nthread = 1,
#'                                    objective = "reg:linear",
#'                                    eval_metric = "rmse"),
#'                      data = dtrain, # Warn: Access using parent environment
#'                      nrounds = 9999999,
#'                      watchlist = watchlist, # Warn: Access using parent environment
#'                      early_stopping_rounds = 5,
#'                      verbose = 0)
#'   score <- model$best_score
#'   rm(model)
#'   return(score)
#'
#' }
#'
#' # The paramters: max_depth in [1, 15], subsample in [0.1, 1], and tree_method IN {exact, hist}
#' my_parameters <- makeParamSet(
#'   makeIntegerParam(id = "max_depth", lower = 1, upper = 15),
#'   makeNumericParam(id = "subsample", lower = 0.1, upper = 1),
#'   makeDiscreteParam(id = "tree_method", values = c("exact", "hist"))
#' )
#'
#' # Perform optimization
#' optimization <- optimize.bayesian(loss_func = xgboost_optimization,
#'                                   param_set = my_parameters,
#'                                   seed = 1,
#'                                   maximize = FALSE,
#'                                   initialization = 10,
#'                                   max_evaluations = 25,
#'                                   time_budget = 30,
#'                                   verbose = TRUE)
#' }

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
