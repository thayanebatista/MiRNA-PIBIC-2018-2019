
# funcao com a logica para salvar os dados que serão utilizados da analise
persistAnalysis = function() {

  ###################################################
  ################### DADOS MIRNA'S #################
  ###################################################

  # carrega o arquivo do deseq
  load("data/analysis/deseq/mirna.rda")

  # carrega todas as analises que utilizaremos dos deseq's
  mirna = list()
  mirna$vsd = as.data.frame(assay(deseq$vsd))
  mirna$nonNormalized = as.data.frame(log2(1+counts(deseq$dds, normalized=F)))
  mirna$normalized = as.data.frame(log2(1+counts(deseq$dds, normalized=T)))
  mirna$results = as.data.frame(deseq$res)
  
  # filtra somente os miRNA encontrados nas predicoes
  mirna$vsd = mirna$vsd[rownames(mirna$vsd) %in% unique(predictions$mirnaid),]
  mirna$nonNormalized = mirna$nonNormalized[rownames(mirna$nonNormalized) %in% unique(predictions$mirnaid),]
  mirna$normalized = mirna$normalized[rownames(mirna$normalized) %in% unique(predictions$mirnaid),]
  mirna$results = mirna$results[rownames(mirna$results) %in% unique(predictions$mirnaid),]

  ###################################################
  #################### DADOS GENES ##################
  ###################################################
  
  # carrega o arquivo do deseq
  load("data/analysis/deseq/gene.rda")

  # carrega todas as analises que utilizaremos dos deseq's
  gene = list()
  gene$vsd =  as.data.frame(assay(deseq$vsd))
  gene$nonNormalized =  as.data.frame(log2(1+counts(deseq$dds, normalized=F)))  
  gene$normalized =  as.data.frame(log2(1+counts(deseq$dds, normalized=T)))
  gene$results = as.data.frame(deseq$res)
  
  # filtra somente os genes encontrados nas predicoes
  gene$vsd = gene$vsd[unique(predictions$genesymbol),]  
  gene$nonNormalized = gene$nonNormalized[unique(predictions$genesymbol),]  
  gene$normalized = gene$normalized[unique(predictions$genesymbol),]  
  gene$results = gene$results[unique(predictions$genesymbol),]  
  

  ######################################################
  #################### TODOS OS DADOS ##################
  ######################################################
  
  # variavel que sera salva com todos os dados fitrados
  data = list(mirna = mirna, gene = gene)
  
  # persiste os dados
  save(data, file = 'data/analysis/processed-data.rda', compress = "xz")
}
