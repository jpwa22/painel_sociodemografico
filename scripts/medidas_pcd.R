library(readxl)
library(purrr)
library(tidyverse)
library(writexl)
library(fs)


# Caminho onde estão os arquivos .zip
pasta_pcd <- "dados_brutos/pcd_excel"

# Pasta de destino onde os arquivos serão organizados por temática
pasta_destino <- "dados_brutos/pcd"

# Lista todos os arquivos .zip no diretório
arquivos_pcd <- list.files(pasta_pcd, pattern = "\\.xlsx$", full.names = TRUE)

# Função auxiliar para extrair temática do nome do arquivo
extrair_tematica <- function(nome_arquivo) {
  str_match(nome_arquivo, "Censo 2022 - (.*?) -")[, 2]
}


# Loop pelos arquivos .zip
for (arquivo in arquivos_pcd) {
    nome_arquivo <- basename(arquivo)
    # Extrai a temática
    tematica <- extrair_tematica(nome_arquivo)
    
    if (!is.na(tematica)) {
      # # Cria a pasta da temática, se ainda não existir
      dir_tematica <- file.path(pasta_destino, tematica)
      dir_create(dir_tematica)
      # Move o arquivo para a pasta correspondente
      file_move(arquivo, file.path(dir_tematica, nome_arquivo))

    }
  }
  

message("Processo concluído com sucesso!")







concatenar_planilhas_com_log <- function(pasta) {
  arquivos <- list.files(pasta, pattern = "\\.xlsx$", full.names = TRUE)
  
  dados <- map_dfr(arquivos, function(arq) {
    message("📄 Lendo: ", basename(arq))
    
    tryCatch({
      df <- read_excel(arq)
      
      # Força a coluna "Pessoas com autismo (%)" para chr se existir
      if ("Pessoas com autismo (%)" %in% names(df)) {
        df[["Pessoas com autismo (%)"]] <- as.character(df[["Pessoas com autismo (%)"]])
      }
      
      return(df)
    }, error = function(e) {
      message("❌ Erro ao ler ", basename(arq), ": ", e$message)
      return(NULL)
    })
  })
  
  return(dados)
}

# Uso:
# df_final <- concatenar_planilhas_com_log("dados_brutos/pcd/Autismo, por sexo")
# df_final <- df_final %>% distinct()
# write_xlsx(df_final,"dados_brutos/pcd/Autismo.xlsx")

df_final <- concatenar_planilhas_com_log("dados_brutos/pcd/Deficiência, por sexo")
df_final <- df_final %>% distinct()
write_xlsx(df_final,"dados_brutos/pcd/def.xlsx")

# Taxa de analfabetismo de pessoas com deficiência
df_final <- concatenar_planilhas_com_log("dados_brutos/pcd/Taxa de analfabetismo de pessoas com deficiência")
df_final <- df_final %>% distinct()
write_xlsx(df_final,"dados_brutos/pcd/analfabetismo_pcd.xlsx")


# csv ---------------------------------------------------------------------


cor_pcd <- read_csv2("dados_brutos/pcd/cor_pcd.csv")
glimpse(cor_pcd)
pcd <- read_csv2("dados_brutos/pcd/pcd.csv")
glimpse(pcd)


unique(cor_pcd$Variável)
unique(pcd$Variável)

cor_pcd |> group_by(Variável, Tipos.de.dificuldades.funcionais ) |> summarise(Total = sum(as.numeric(Valor) , na.rm = TRUE))
pcd |> group_by(Variável) |> summarise(Total = sum(as.numeric(Valor) , na.rm = TRUE))


# Tabelas do Sidra
tabelas <- read_excel("docs/pcd_aux.xlsx", sheet = "tabelas")
