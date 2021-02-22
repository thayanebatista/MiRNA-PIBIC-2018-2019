# cria uma função com toda a logica para carregar a base do mirwalk encapsulada
loadPredictions = function() {
  
  # imports
  library(data.table)
  
  # local onde estao os arquivos do mirwalk
  path = 'data/predictions/mirwalk/'
  
  # busca todos os arquivos com extencao csv da pasta
  files = list.files(path, pattern='*.csv')
  
  # loop para carregar todos os arquivos em uma unica lista
  predictions = NULL
  for(file in files) {
    
    # caminhinho total do arquivo
    file = paste(path, file, sep = '')
    
    # colunas a serem carregadas
    select = c('mirnaid', 'genesymbol', 'position', 'validated')
    
    # carrega os dados do arquivo e já realiza o merge com os dados já carregados anteriormente
    predictions = rbind(predictions, fread(file, select = select))
  }
  
  # lower case nos id's dos miRNAs's
  predictions$mirnaid = tolower(predictions$mirnaid)

  save(predictions, file = 'data/predictions/processed-predictions.rda', compress = "xz")
  
  # retorna os dados
  return(predictions)
  
}
