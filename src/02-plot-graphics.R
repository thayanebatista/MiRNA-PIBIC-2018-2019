
# importa a funcao do heatmap
source('src/graphics/heatmap.R')
source('src/graphics/volcano-plot.R')
source('src/graphics/correlation-plot.R')

# gera o heatmap conforme os parametros informados
#generateHeatMap('CDK1', 'vsd', 'condition-mean', 'heatmap-CDK1.png')

# gera o volcano-plot conforme os parametros informados
#generateVolcanoPlot('CDK1', 'volcano-CDK1.png')

# gera o correlation-plot conforme os parametros informados
generateCorrelationPlot('BRCA1', 'vsd', 'correlation-BRCA1.png')

# remove as funcoes
remove(list = ls())
