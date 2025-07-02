# Carregar pacotes
library(writexl)
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
saveRDS(df_final,"dados_brutos/pcd/sidra_pcd.rds")
# Visualizar resultado
print(df_final)

sidra <- df_final
sidra |> glimpse()
sidra <- sidra |> select(D1C,D2N,D4N,D5N,D6N,V,MN,tabela)

sidra <- sidra |> mutate(V = as.numeric(str_replace(V,"-","")))

sidra_rotulos <- unique(sidra |> filter(D1C == "Município (Código)"))
sidra <- sidra |> filter(D1C != "Município (Código)")
sidra <- sidra |> mutate(Atributo = paste(D2N,"|",D4N,"|",D5N,"|",D6N))


write_xlsx(sidra,"dados_brutos/pcd/sidra.xlsx")
write_xlsx(sidra_rotulos,"dados_brutos/pcd/sidra_rotulos.xlsx")
