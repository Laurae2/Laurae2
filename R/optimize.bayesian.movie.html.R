#' Bayesian Optimization, Movie Maker, HTML
#'
#' \code{optimize.bayesian.movie.html} generates an optimization movie from \code{optimize.bayesian}.
#'
#' Please see vignette for demos: \code{vignette("optimize.bayesian", package = "Laurae2")} or \code{help_me("optimize.bayesian")}.
#'
#' @param optimized Type: List returned from \code{optimize.bayesian}. The object to make the movie from.
#' @param folder Type: character. The output folder for the images of the HTML movie. Defauls to \code{"movie"}.
#' @param file Type: character. The output file for the HTML movie, without path. Defauls to \code{"index.html"}.
#' @param title Type: character. The title of the HTML movie. Defaults to \code{"Bayesian Optimization in R"}.
#' @param autobrowse Type: logical. Whether to open the HTML movie once finished. Defaults to \code{TRUE}.
#' @param width Type: numeric. Width in pixels. Note that 40 pixels are removed for the borders to fit the provided width. Defaults to \code{1280}.
#' @param height Type: numeric. Height in pixels. Note that 88 pixels are removed for the borders to fit the provided height. Defaults to \code{720}.
#' @param navigator Type: logical. Whether to provide a progress bar on the HTML file. Defaults to \code{TRUE}.
#'
#' @return None.
#' @export
#'
#' @importFrom graphics plot
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
#'
#' # Make movie from the optimization
#' optimize.bayesian.movie.html(optimization)
#' }

optimize.bayesian.movie.html <- function(optimized, folder = "movie", file = "index.html", title = "Bayesian Optimization in R", autobrowse = TRUE, width = 1280, height = 720, navigator = TRUE) {

  animation::saveHTML({
    for (i in 0:max(optimized$opt.path$env$dob)) {
      plot(optimized, iters = i)
    }
  }, ani.width = width - 40, ani.height = height - 88, title = title, imgdir = folder, htmlfile = file, navigator = navigator, autobrowse = autobrowse, verbose = FALSE)

}
