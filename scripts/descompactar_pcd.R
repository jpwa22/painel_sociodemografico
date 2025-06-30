library(tidyverse)
library(stringr)
library(fs)
library(zip)

# Caminho onde estão os arquivos .zip
pasta_zip <- "dados_brutos/indicadores_pcd"

# Pasta de destino onde os arquivos serão organizados por temática
pasta_destino <- "dados_brutos/pcd"

# Lista todos os arquivos .zip no diretório
arquivos_zip <- list.files(pasta_zip, pattern = "\\.zip$", full.names = TRUE)

# Loop pelos arquivos .zip
for (zip_file in arquivos_zip) {

  unzip(zip_file)

}

message("Processo concluído com sucesso!")

arquivos_csv_cor <- list.files(pasta_destino, pattern = "^cor_pcd_ ", full.names = TRUE)


df <- read.csv2(arquivos_csv_cor[1], skip = 1)
#df <- df[1:nrow(df)-1,]
df <- df [0,]

for (arquivo in arquivos_csv_cor) {
  message("Arquivo:",arquivo)
  temp_csv <- read.csv2(arquivo, skip = 1)
  df <- rbind(df,temp_csv)
  rm(temp_csv)
}
write.csv2(df,"dados_brutos/cor_pcd.csv")


arquivos_csv_pcd <- list.files(pasta_destino, pattern = "^pcd_ ", full.names = TRUE)


df <- read.csv2(arquivos_csv_pcd[1], skip = 1)
#df <- df[1:nrow(df)-1,]
df <- df [0,]

for (arquivo in arquivos_csv_pcd) {
  message("Arquivo:",arquivo)
  temp_csv <- read.csv2(arquivo, skip = 1)
  df <- rbind(df,temp_csv)
  rm(temp_csv)
}
write.csv2(df,"dados_brutos/pcd.csv")
