# Install packages - only need to do this once!

# Install packages from CRAN

install.packages(c(
    "Cairo",
    "cbcTools",
    "cowplot",
    "fastDummies",
    "ggrepel",
    "here",
    "janitor",
    "kableExtra",
    "knitr",
    "logitr",
    "MASS",
    "pak",
    "quarto",
    "remotes",
    "rmarkdown",
    "tidyverse",
    "viridis"
))

# Install development packages from GitHub

remotes::install_github("jhelvy/jph")
remotes::install_github("jhelvy/cbcTools")
