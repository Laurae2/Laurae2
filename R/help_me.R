#' Open Laurae2 package Vignette
#'
#' \code{help_me} opens the correspdoning vignette to the function you are asking for.
#'
#' @param func_name Type: character. A function name from the corresponding \code{package}.
#' @param package Type: character. The package the vignette must be looked for.
#'
#' @return Nothing.
#' @export
#'
#' @importFrom utils vignette
#'
#' @examples
#' \dontrun{
#' help_me("data.table.rc")
#' }

help_me <- function(func_name = NULL, package = "Laurae2") {
  vignette(func_name, package = package)
}
