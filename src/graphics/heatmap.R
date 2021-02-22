
# funcao com a logica para gerar o heatmap
generateHeatMap = function(targetGene, transformationType = 'vsd', centerType = 'condition-mean', fileName = 'heatmap.png') {
    
  #para executar na mão, descomentar linhas abaixo
  #targetGene = 'CDK1'
  #transformationType = 'vsd'
  #centerType = 'condition-mean'
  #fileName = 'heatmap.png'
  
  # imports
  library(gplots)
  library(RColorBrewer)
  library(TCGAbiolinks)
  library(DESeq2)
  
  # carrega os dados necessarios ao heatmap
  load("data/analysis/processed-data.rda")
  load("data/analysis/sample-condition.rda")
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
  dataHeatMap = as.data.frame(rbind(dataGene, dataMirna))
  
  # tranforma os valores de expressao para base 10
  dataHeatMap <- as.data.frame(apply(dataHeatMap, 1:2, function(x) as.integer(2^x)))
  
  # centraliza os dados antes de gerar o heatmap
  if (centerType == 'scale') {  # centraliza os dados de maneira generalizada independente da sua condiçao (modo ribeirão)
    dataHeatMap = scale(dataHeatMap)
  } else if (centerType == 'deseq-mean') {# centraliza os dados com base no mean do deseq
    for (i in 1:nrow(dataHeatMap)) {
      name = rownames(dataHeatMap[i,])
      if (i == 1) { # a primeira linha sempre será o gene
        dataHeatMap[name,] = log2(dataHeatMap[name,]/data$gene$results[name,'baseMean'])
      } else { # as demais serão os mirna's
        dataHeatMap[name,] = log2(dataHeatMap[name,]/data$mirna$results[name,'baseMean'])
      }
    }    
  } else if (centerType == 'condition-mean') { # media calculada com base na media individual de cada grupo, utilizando o mesmo peso para cada grupo independente do número de amostras.
    
    # separa em tumores e nao tumomres
    dataTP = dataHeatMap[,sampleCondition$condition == 'TP'] 
    dataNT = dataHeatMap[,sampleCondition$condition == 'NT']
    
    for (i in 1:nrow(dataHeatMap)) {
      
      # calcula a media de cada grupo
      meanTP = mean(as.matrix(dataTP[i,]))
      meanNT = mean(as.matrix(dataNT[i,]))
      
      # calcula dos dois grupos com o mesmo peso
      mean = (meanTP + meanNT) / 2
      
      dataHeatMap[i,] = log2(dataHeatMap[i,] / mean)
    }    
  }
  
  ##########################################################
  ###################### GERA O HEATMAP ####################
  ##########################################################
  
  #calcula o tamanho do heatmap
  width = (ncol(dataHeatMap) * 30) + 300
  height = (nrow(dataHeatMap) * 30) + 200
  
  # nome do arquivo onde ficara o heatmap
  fileName = paste("graphics/", fileName, sep = '')
  png(filename=fileName, width = width, height = height)
  
  # defina as anotacoes do HeatMap
  heatmap.2( as.matrix(dataHeatMap),
             scale="none", 
             trace="none", 
             dendrogram="none",
             Rowv = F,
             Colv = F,
            # lmat= rbind(c(2,4),c(3,1)),
             lwid = c(300, width),
            # lhei = c(200, height),
             cexRow = 1,
             cexCol = 1,
             margins = c(11,8),
             col = colorRampPalette(rev(brewer.pal(9, "RdBu")) )(255),
             ColSideColors = c( NT="blue", NP="red" )[sampleCondition$condition]
             )
  
  # salva o arquivo
  graphics.off()
  
}
