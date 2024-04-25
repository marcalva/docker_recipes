repo <- "http://cran.us.r-project.org"
BiocManager::install("org.Hs.eg.db")
BiocManager::install("BSgenome.Hsapiens.UCSC.hg38")
BiocManager::install("BSgenome.Hsapiens.UCSC.hg19")
BiocManager::install("TxDb.Hsapiens.UCSC.hg19.knownGene")
BiocManager::install("TxDb.Hsapiens.UCSC.hg38.knownGene")
devtools::install_github("immunogenomics/presto")
devtools::install_github("GreenleafLab/chromVARmotifs")
