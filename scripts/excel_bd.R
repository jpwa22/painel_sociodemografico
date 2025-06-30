library(tidyverse)
library(openxlsx)
library(writexl)

# Define o caminho da pasta
caminho_base <- "dados_tratados/panorama"

# Lista todos os arquivos dentro de "panorama" e subpastas
arquivos <- list.files(path = caminho_base, recursive = TRUE, full.names = TRUE)

write(arquivos,"arquivos.txt")

# Função para tratar um arquivo
tratar_arquivo <- function(arquivo) {
  df <- readxl::read_excel(arquivo)
  
  # Remove colunas não desejadas
  df <- df %>% select(-Município, -Sigla.UF)
  
  # Identifica colunas
  colunas_char <- names(df)[sapply(df, is.character) & names(df) != "Código.do.Município"]
  colunas_num  <- names(df)[sapply(df, is.numeric)]
  
  # Pivota os dados
  df_char <- df %>%
    select(Código.do.Município, all_of(colunas_char)) %>%
    pivot_longer(
      -Código.do.Município,
      names_to = "Atributo",
      values_to = "Valor"
    )
  
  df_num <- df %>%
    select(Código.do.Município, all_of(colunas_num)) %>%
    pivot_longer(
      -Código.do.Município,
      names_to = "Atributo",
      values_to = "Valor"
    )
  
  bind_rows(df_char, df_num) %>%
    mutate(Fonte = basename(arquivo))
}

# Aplica a função em todos os arquivos
banco_dados <- map_dfr(arquivos[2], tratar_arquivo)

# Exibe as primeiras linhas
print(head(banco_dados))

##########################################
# Função para tratar um arquivo


arquivo <- arquivos[1]

df <- read_excel(arquivo)
# Força o tipo da chave como string com 7 dígitos
df <- df %>%
  mutate(Código.do.Município = sprintf("%07d", as.integer(Código.do.Município))) %>%
  select(-Município, -Sigla.UF)

# Detecta colunas 'character' que são numéricas com vírgula
possivelmente_numericas <- names(df)[sapply(df, function(x) {
  is.character(x) && all(grepl("^[-+]?[0-9.]*,?[0-9]+$", na.omit(x)))
})]

# Converte essas colunas para numeric (trocando vírgula por ponto)
df[possivelmente_numericas] <- lapply(df[possivelmente_numericas], function(x) {
  as.numeric(gsub(",", ".", x))
})

  
  # Identifica colunas

  colunas_char <- names(df)[sapply(df, is.character) & names(df) != "Código.do.Município"]
  colunas_num  <- names(df)[sapply(df, is.numeric)]
  
  
  # Pivota os dados
  df_char <- df %>%
    select(Código.do.Município, all_of(colunas_char)) %>%
    pivot_longer(
      -Código.do.Município,
      names_to = "Atributo",
      values_to = "Valor"
    )
  
  
  df_num <- df %>%
    select(Código.do.Município, all_of(colunas_num)) %>%
    pivot_longer(
      -Código.do.Município,
      names_to = "Atributo",
      values_to = "Valor"
    )
  
  df <- df %>%
        pivot_longer(
      -Código.do.Município,
      names_to = "Atributo",
      values_to = "Valor"
    )
  
  
  bind_rows(df_char, df_num) %>%
    mutate(Fonte = basename(arquivo))
