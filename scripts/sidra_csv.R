# Carregar pacotes
library(tidyverse)

# Pasta onde estão os arquivos CSV
caminho_pasta <- "dados_brutos/pcd/sidra"

# Listar todos os arquivos CSV
arquivos <- list.files(path = caminho_pasta, pattern = "\\.csv$", full.names = TRUE)

# Função para extrair o número da tabela
extrai_numero <- function(nome_arquivo) {
  # Captura o número entre pcd_ e _
  str_match(
    basename(nome_arquivo),
    "pcd_\\s*(\\d+)\\s*_"
  )[,2]
}


#extrai_numero("pcd_ 10138 _ 2601607 .csv")

# Criar um tibble com nomes de arquivos e o número da tabela
df_arquivos <- tibble(
  arquivo = arquivos,
  tabela = sapply(arquivos, extrai_numero)
)

# Checar se a extração funcionou
print(df_arquivos)

# Função que lê um arquivo e adiciona a coluna 'tabela'
ler_arquivo <- function(arq, num_tabela) {
  read_csv2(arq, show_col_types = FALSE) %>%
    mutate(tabela = num_tabela)
}

# Para armazenar todos os data.frames agrupados
lista_dfs <- list()

# Agrupar pelos números da tabela e concatenar cada grupo
numeros_unicos <- unique(df_arquivos$tabela)

for (num in numeros_unicos) {
  arquivos_grupo <- df_arquivos %>% filter(tabela == num)
  
  # Lê e concatena todos os arquivos deste grupo
  df_grupo <- map_dfr(
    arquivos_grupo$arquivo,
    ~ ler_arquivo(.x, num)
  )
  
  # Armazena na lista
  lista_dfs[[num]] <- df_grupo
}

# Se quiser concatenar tudo em um único data.frame:
df_final <- bind_rows(lista_dfs)

# Visualizar resultado
print(df_final)

write_xlsx(df_final,"dados_brutos/pcd/sidra.xlsx")
write_xlsx(unique(df_final |> filter(NC == "Nível Territorial (Código)")),"dados_brutos/pcd/sidra_rotulos.xlsx")
