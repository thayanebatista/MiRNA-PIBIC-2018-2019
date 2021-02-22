# funcao com a logica para gerar o DESeq

loadSampleCondition = function() {

  library(TCGAbiolinks)
  
  # enviroment global para sobreescrever as listas de expressão
  env = globalenv()
  
  # mantem somente as amostras presentes em ambas as listas de expressao
  env$geneExpression = geneExpression[,colnames(geneExpression) %in% colnames(mirnaExpression)]
  env$mirnaExpression = mirnaExpression[,colnames(mirnaExpression) %in% colnames(geneExpression)]
  
  # nomes de todas as amostras
  samples = colnames(geneExpression)

  # nomes das amostras nao tumorais
  samplesNT = TCGAquery_SampleTypes(samples, "NT")
  
  # nomes das amostras tumorais
  samplesTP = TCGAquery_SampleTypes(samples, "TP")
    
  # mantem nas listas de expressao somente as amostras tumorais e nao tumorais
  env$geneExpression = geneExpression[, c(samplesNT, samplesTP)]
  env$mirnaExpression = mirnaExpression[, c(samplesNT, samplesTP)]
  
  # nomes de todas as amostras que sobraram apos a filtragem
  samples = c(samplesNT, samplesTP)
  
  # cria uma tabela com a condicao de cada amostra
  sampleCondition = data.frame(condition = c(rep("NT", length(samplesNT)), rep("TP", length(samplesTP))))
  rownames(sampleCondition) = samples
  
  # persiste as condicoes das amostras
  save(sampleCondition, file = 'data/analysis/sample-condition.rda', compress = "xz")
  
  return(sampleCondition)
}