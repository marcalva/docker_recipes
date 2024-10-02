repo = "http://cran.us.r-project.org"
install.packages("remotes", repos = repo)
remotes::install_cran("devtools", repos = repo, upgrade = "never")
remotes::install_cran("languageserver", repos = repo, upgrade = "never")
remotes::install_cran("lintr", repos = repo, upgrade = "never")
remotes::install_cran("styler", repos = repo, upgrade = "never")
remotes::install_cran("tidyverse", repos = repo, upgrade = "never")
remotes::install_cran("ggplot2", repos = repo, upgrade = "never")
