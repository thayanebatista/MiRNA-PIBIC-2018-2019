
# cria uma função com toda a logica para carregar a base dos miRNA do TCGA de maneira encapsulada
loadMirnaExpression = function() {
  
  # imports
  library(TCGAbiolinks) #bioconductor
  library(SummarizedExperiment) #bioconductor

  # seta o diretorio de trabalho
  setwd('data/expressions/gdc/raw')
  
  # arquivo onde será salvo os dados do TCGA
  fileName = "TCGA-BRCA-miRNA-Expression.rda"
  
  # verifica se o arquivo com os genes carregados já existe, caso não exista realiza o download utilizando a api do TCGA
  if (!file.exists(fileName)) {
    
    # define quais arquivos serão consultados na base do GDC
    query = GDCquery(legacy = T,
                    project = "TCGA-BRCA",
                    data.category = "Gene expression",
                    data.type = "miRNA gene quantification",
                    file.type = "mirna")
    
    # persite os arquivos do GDC no computador
    GDCdownload(query, method = 'api')
    
    # remove dos resultados o casos duplicados
    results = query$results[[1]]
    query$results[[1]] = results[!duplicated(results$cases),]
    
    # processa os arquivos e salva o resultado no computador
    GDCprepare(query, save=TRUE, save.filename = fileName)
  }
  
  # carrega os dados processados
  load(fileName)
  
  # seta o noma das linha com o nomes do miRNA's
  rownames(data) = data$miRNA_ID
  
  # remove as colunas sem a contagem de miRNA
  data <- data[,grep('read_count_', colnames(data))]
  
  # limpa os nomes das colunas
  colnames(data) <- gsub("read_count_", "", colnames(data))
  
  # remove as informacoes nao utilizadas dos nomes das amostras (Ex: de 'TCGA-3X-AAVA-01A-11R-A41I-07' para 'TCGA-3X-AAVA-01')
  colnames(data) = substr(colnames(data), 1, 15)
  
  # remove as amostras duplicadas
  duplicatedNames = colnames(data)[duplicated(colnames(data))]
  data = data[, !colnames(data) %in% duplicatedNames]
  
  # ordena os nomes das amostras
  data = data[, order(colnames(data))]
  
  # seta o diretorio de trabalho
  setwd('../../../..')
  
  # retorna os dados
  return(data)
}