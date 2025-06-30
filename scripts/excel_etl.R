library(tidyverse)
library(openxlsx)
library(writexl)

# Define o caminho da pasta
caminho_base <- "dados_brutos/panorama"

# Lista todos os arquivos dentro de "panorama" e subpastas
arquivos <- list.files(path = caminho_base, recursive = TRUE, full.names = TRUE)

# Filtra os que têm "- Brasil" no nome do arquivo (não no caminho completo)
arquivos_brasil <- arquivos[grepl("- Brasil", basename(arquivos))]

# Remove os arquivos encontrados
file.remove(arquivos_brasil)
rm(arquivos)


# Lista apenas os diretórios dentro da pasta "panorama"
pastas <- list.dirs(path = caminho_base, full.names = TRUE, recursive = FALSE)

# Visualiza o resultado
print(pastas)

shape <- function(x){
  print(paste(nrow(x),",",ncol(x)))
}

for (j in 1:length(pastas)) {
  message("Nome da pasta: ",str_sub(pastas[j],23))
  list_of_files <- list.files(path = pastas[j],
                              recursive = TRUE,
                              pattern = "\\.xlsx$",
                              full.names = TRUE)
  dados <- read.xlsx(list_of_files[1])
  dados <- dados[0,]
    for (i in 1:length(list_of_files) ){
      message("Arquivo: ",list_of_files[i])
      dtemp <- read.xlsx(list_of_files[i])
      dados <- rbind(dados,dtemp)
      rm(dtemp)
    }

  
  write_xlsx(dados, paste0("dados_tratados/",str_sub(pastas[j],23),".xlsx"))
  rm(dados)
  message("Todos os arquivos Agrupados!")
  
}

