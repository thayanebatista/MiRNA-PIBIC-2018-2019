
# cria uma função com toda a logica para carregar a base dos genes do TCGA de maneira encapsulada
loadGeneExpression = function() {
  
  # imports
  library(TCGAbiolinks) #bioconductor
  library(SummarizedExperiment) #bioconductor
  
  # seta o diretorio de trabalho
  setwd('data/expressions/gdc/raw')
  
  # arquivo onde será salvo os dados do TCGA
  fileName = "TCGA-BRCA-Gene-Expression.rda"
  
  # verifica se o arquivo com os genes carregados já existe, caso não exista realiza o download utilizando a api do TCGA
  if (!file.exists(fileName)) {
    
    # define quais arquivos serão consultados na base do GDC
    query = GDCquery(legacy = T,
                    project = "TCGA-BRCA",
                    data.category = "Gene expression",
                    data.type = "Gene expression quantification",
                    platform = "Illumina HiSeq",
                    file.type = "results")
    
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
  
  # transforma os dados em uma matriz
  data <- assay(data)

  # limpa os nomes dos genes
  rownames(data) = gsub("\\|.*", "", rownames(data))
  
  # arredonda os resultados
  data = round(data)
  
  # transforma a matriz em um dataframe
  data = as.data.frame(data)
  
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