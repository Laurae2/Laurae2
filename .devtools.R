setwd("E:/GitHub")

devtools::create("Laurae2")

setwd("E:/GitHub/Laurae2")
devtools::use_vignette("data.frame.rc")
devtools::use_vignette("data.table.rc")
devtools::use_vignette("optimize.bayesian")

devtools::check()

devtools::install(build_vignettes = TRUE)

devtools::install_github("Laurae2/Laurae2", build_vignettes = TRUE)
