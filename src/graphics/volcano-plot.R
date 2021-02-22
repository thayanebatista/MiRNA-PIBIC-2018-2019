
# funcao com a logica para gerar o volcano-plot
generateVolcanoPlot = function(targetGene, fileName = 'volcano-plot.png') {
    
  #para executar na mão, descomentar linhas abaixo
  #targetGene = 'CDK1'
  #fileName = 'volcano-plot.png'
  
  # imports
  library(gplots)
  library(RColorBrewer)
  library(TCGAbiolinks)
  library(DESeq2)
  library(ggplot2)
  library(dplyr)
  library(EnhancedVolcano)
  
  
  # carrega os dados necessarios ao volcano-plot
  load("data/analysis/processed-data.rda")
  load("data/predictions/processed-predictions.rda")
  
  # monta os dados conforme o tipo de analise do deseq
  dataMirna = data$mirna$results

  ###################################################
  ################### DADOS MIRNA'S #################
  ###################################################

  # filtra dos resultados por padj, foldChange (diferencialmente expressos)
  #filtered <- subset(ddataMirna, abs(log2FoldChange)>0.5)
  #selected <- subset(res, padj < 0.01 & abs(log2FoldChange)>5)
  #selected = results
  
  # deixa na tabela somente os mirna filtrados
  #dataMirna <- dataMirna[rownames(filtered),]

  # filta somente a expressao dos miRNA's associados ao gene alvo
  mirnas = predictions[predictions$genesymbol == targetGene]$mirnaid
  dataMirna = dataMirna[rownames(dataMirna) %in% mirnas,]
  
  
  ###############################################################
  ###################### GERA O VOLCANO-PLOT ####################
  ###############################################################
  
  
  # nome do arquivo onde ficara o heatmap
  fileName = paste("graphics/", fileName, sep = '')
  #png(filename=fileName, width = 800, height = 600)  
  
  EnhancedVolcano(dataMirna,
                  lab = rownames(dataMirna),
                  x = 'log2FoldChange',
                  y = 'pvalue',
                  transcriptPointSize = 1.5,
                  FCcutoff = 1.5,
                  title = paste("VolcanoPlot ", targetGene, sep = '')
                  )
  
  # salva o arquivo
  ggsave(filename=fileName)
  graphics.off()
  
}
