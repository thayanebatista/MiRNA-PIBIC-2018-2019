
# funcao com a logica para gerar o correlation
generateCorrelationPlot = function(targetGene, transformationType = 'vsd', fileName = 'correlation-plot.png') {
    
  # para executar na mão, descomentar linhas abaixo
  #targetGene = 'CDK1'
  #transformationType = 'vsd'
  #fileName = 'correlation-plot.png'
  
  # imports
  library(corrplot)

  # carrega os dados necessarios ao heatmap
  load("data/analysis/processed-data.rda")
  load("data/predictions/processed-predictions.rda")
  
  # monta os dados conforme o tipo de analise do deseq
  if (transformationType == 'vsd') {
    dataMirna = data$mirna$vsd
    dataGene =  data$gene$vsd
  } else if (transformationType == 'non-normalized') {
    dataMirna = data$mirna$nonNormalized
    dataGene =  data$gene$nonNormalized
  } else if (transformationType == 'normalized') {
    dataMirna = data$mirna$normalized
    dataGene =  data$gene$normalized
  }
  
  ###################################################
  ################### DADOS MIRNA'S #################
  ###################################################
  
  # filtra dos resultados por padj, foldChange (diferencialmente expressos)
  filtered <- subset(data$mirna$results, abs(log2FoldChange)>0.5)
  #selected <- subset(res, padj < 0.01 & abs(log2FoldChange)>5)
  #selected = results
  
  # deixa na tabela somente os mirna filtrados
  dataMirna <- dataMirna[rownames(filtered),]
  
  # filta somente a expressao dos miRNA's associados ao gene alvo
  mirnas = predictions[predictions$genesymbol == targetGene]$mirnaid
  dataMirna = dataMirna[rownames(dataMirna) %in% mirnas,]
  
  ###################################################
  #################### DADOS GENES ##################
  ###################################################
  
  # filta somente a expressao do gene alvo
  dataGene = dataGene[targetGene,]
  
  ##########################################################
  ###################### TODOS OS DADOS ####################
  ##########################################################
  
  # concatena as informacoes de gene e miRNA
  dataCorrelation = as.data.frame(rbind(dataGene, dataMirna))
  
  # inverte as colunas com as linhas no dataFrame
  dataCorrelation = as.data.frame(t(dataCorrelation))
  
  # tranforma os valores de expressao para base 10
  dataCorrelation <- as.data.frame(apply(dataCorrelation, 1:2, function(x) as.integer(2^x)))
  
  # calcula a correlação
  dataCorrelation <- cor(dataCorrelation)
  
  ##########################################################
  ###################### GERA O CORRELATION PLOT ####################
  ##########################################################
  
  #calcula o tamanho do heatmap
  width = (ncol(dataCorrelation) * 50)
  height = (nrow(dataCorrelation) * 50)
  
  # nome do arquivo onde ficara o heatmap
  fileName = paste("graphics/", fileName, sep = '')
  png(filename=fileName, width = width, height = height)
  
  # gera o plot
  corrplot(dataCorrelation, method = "shade")
  
  # salva o arquivo
  graphics.off()
  
}
