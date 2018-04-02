# Laurae2 R-package

The sequel to [Laurae](https://github.com/Laurae2/Laurae) R-package.

Each function has at least one corresponding vignette to look up for an example using `help_me("my_function_name")`.

## Installation

It can be computationally expensive to build vignettes. Build without vignettes using the following:

```r
devtools::install_github("Laurae2/Laurae2")
```

If you want to build vignettes to get a significantly better help:

```r
devtools::install_github("Laurae2/Laurae2", build_vignettes = TRUE)
```

Pre-requirement installation:

```r
install.packages("devtools")
install.packages(c("knitr", "rmarkdown", "mlrMBO", "lhs", "smoof", "ParamHelpers", "animation"))
```

xgboost installation, commit dmlc/xgboost@017acf5 seems best currently as it has gblinear improvements. Make sure to use the right compiler below:

```r
devtools::install_github("Laurae2/xgbdl")

# gcc
xgbdl::xgb.dl(compiler = "gcc", commit = "017acf5", use_avx = FALSE, use_gpu = FALSE)

# Visual Studio 2015, use AVX if you wish to
xgbdl::xgb.dl(compiler = "Visual Studio 14 2015 Win64", commit = "017acf5", use_avx = FALSE, use_gpu = FALSE)

# Visual Studio 2017, use AVX if you wish to
xgbdl::xgb.dl(compiler = "Visual Studio 15 2017 Win64", commit = "017acf5", use_avx = FALSE, use_gpu = FALSE)
```

## What can it do?

What can it do:

* Bayesian Optimization (time-limited, iteration-limited, initialization-limited)
* Create data.frame from [R,C] matrix-like format
* Create data.table from [R,C] matrix-like format

Package requirements:

* knitr
* rmarkdown
* mlrMBO
* lhs
* smoof
* ParamHelpers
* animation
* xgboost
