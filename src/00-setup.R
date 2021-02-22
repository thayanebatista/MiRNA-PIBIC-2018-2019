# instala as libs necessárias ao projeto

if (!requireNamespace("BiocManager", quietly = TRUE)) {
  install.packages("BiocManager")
}

if (!requireNamespace("gplots", quietly = TRUE)) {
  install.packages("gplots")
}

if (!requireNamespace("ggplot2", quietly = TRUE)) {
  install.packages("ggplot2")
}

if (!requireNamespace("dplyr", quietly = TRUE)) {
  install.packages("dplyr")
}

if (!requireNamespace("TCGAbiolinks", quietly = TRUE)) {
  BiocManager::install("TCGAbiolinks", update = F)
}

if (!requireNamespace("sesameData", quietly = TRUE)) {
  BiocManager::install("sesameData", update = F)
}

if (!requireNamespace("DESeq2", quietly = TRUE)) {
  BiocManager::install("DESeq2", update = F)
}

if (!requireNamespace("apeglm", quietly = TRUE)) {
  BiocManager::install("apeglm", update = F)
}

if (!requireNamespace("BiocParallel", quietly = TRUE)) {
  BiocManager::install("BiocParallel", update = F)
}

if (!requireNamespace("EnhancedVolcano", quietly = TRUE)) {
  BiocManager::install("EnhancedVolcano", update = F)
}  

if (!requireNamespace("corrplot", quietly = TRUE)) {
  install.packages("corrplot")
}
