library(tidyverse)
library(stringr)
library(fs)
library(zip)

# Caminho onde estão os arquivos .zip
pasta_zip <- "dados_brutos/totais"

# Pasta de destino onde os arquivos serão organizados por temática
pasta_destino <- "dados_brutos/panorama_totais"

# Lista todos os arquivos .zip no diretório
arquivos_zip <- list.files(pasta_zip, pattern = "\\.zip$", full.names = TRUE)

# Função auxiliar para extrair temática do nome do arquivo
extrair_tematica <- function(nome_arquivo) {
  str_match(nome_arquivo, "Censo 2022 - (.*?) -")[, 2]
}

# Loop pelos arquivos .zip
for (zip_file in arquivos_zip) {
  # Cria uma pasta temporária para descompactar
  temp_dir <- tempfile()
  dir.create(temp_dir)
  
  # Descompacta o arquivo na pasta temporária
  unzip(zip_file, exdir = temp_dir)
  
  # Lista os arquivos descompactados
  arquivos <- list.files(temp_dir, pattern = "\\.xlsx$", full.names = TRUE)
  
  for (arquivo in arquivos) {
    nome_arquivo <- basename(arquivo)
    # Extrai a temática
    tematica <- extrair_tematica(nome_arquivo)
    
    if (!is.na(tematica)) {
      # Cria a pasta da temática, se ainda não existir
      dir_tematica <- file.path(pasta_destino, tematica)
      dir_create(dir_tematica)
      
      # Move o arquivo para a pasta correspondente
      file_move(arquivo, file.path(dir_tematica, nome_arquivo))
    }
  }
  
  # Remove a pasta temporária
  dir_delete(temp_dir)
}

message("Processo concluído com sucesso!")
