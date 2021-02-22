
source('src/predictions/mirwalk.R')
source('src/expressions/tcga-gene.R')
source('src/expressions/tcga-mirna.R')
source('src/analysis/sample-condition.R')
source('src/analysis/deseq.R')
source('src/analysis/persist-analysis.R')

# carrega as predicoes de mirna's
predictions = loadPredictions()

# carrega as expressões dos genes
geneExpression = loadGeneExpression()

# carrega as expressões dos mirna's
mirnaExpression = loadMirnaExpression()

# carrega a condicao das amostras
sampleCondition = loadSampleCondition()

# gera o deseq da lista de genes
calculateDESeq('gene')

# gera o deseq da lista de mirna
calculateDESeq('mirna')

# persiste os dados levantados pelo deseq
persistAnalysis()

# remove todas as variaveis que ficaram no ambiente
remove(list = ls())

