library(tidyverse)


# Define o caminho da pasta
caminho_base <- "dados_brutos/panorama"

# Lista apenas os diretórios dentro da pasta "panorama"
pastas <- list.dirs(path = caminho_base, full.names = TRUE, recursive = FALSE)

# Visualiza o resultado
print(pastas)




# Caminho da pasta onde estão os arquivos CSV
caminho <- "dados_brutos/pop_res"

list_of_files <- list.files(path = caminho,
                            recursive = TRUE,
                            pattern = "\\.csv$",
                            full.names = TRUE)

cabecalho <- colnames(read_csv2(list_of_files[1],skip = 1))



for (i in 1:length(list_of_files) ){
dtemp <- read_csv2(list_of_files[i],skip = 2, col_names = FALSE)
dados <- rbind(dados,dtemp)
rm(dtemp)
}
colnames(dados) <- cabecalho
write_csv2(dados,"dados_tratados/pop_res.csv")


