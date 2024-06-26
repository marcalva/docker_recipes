repo <- "http://cran.us.r-project.org"

remotes::install_cran("languageserver", upgrade = "never")
remotes::install_cran("GGally", repos = repo, upgrade = "never")
BiocManager::install("org.Hs.eg.db")
BiocManager::install("BSgenome.Hsapiens.UCSC.hg38")
BiocManager::install("BSgenome.Hsapiens.UCSC.hg19")
BiocManager::install("TxDb.Hsapiens.UCSC.hg19.knownGene")
BiocManager::install("TxDb.Hsapiens.UCSC.hg38.knownGene")
BiocManager::install("edgeR")
devtools::install_github("immunogenomics/presto")
devtools::install_github("GreenleafLab/chromVARmotifs")
remotes::install_cran("MatrixEQTL", repos = repo, upgrade = "never")
remotes::install_cran("optparse", repos = repo, upgrade = "never")
