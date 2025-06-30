library(sidrar)
# Taxa de desocupação - Pernambuco
dados <- get_sidra(api = "t/10125/n3/26/n6/all/v/12785/p/all/c2/6794/c58/all", format = "csv")

#https://apisidra.ibge.gov.br/values/t/10125/n3/26/n6/all/v/12785/p/all/c2/6794/c58/all

library(httr)
library(jsonlite)
library(dplyr)

# URL da requisição
url <- "https://apisidra.ibge.gov.br/values/k/1148219473"

# Fazer GET e converter para data frame
resposta <- GET(url)

# Checar se deu certo
if (status_code(resposta) == 200) {
  conteudo <- content(resposta, as = "text", encoding = "UTF-8")
  dados_json <- fromJSON(conteudo)
  
  # Converter para data frame
  dados_df <- as_tibble(dados_json)
  
  # Visualizar os dados
  print(dados_df)
} else {
  stop("Erro ao acessar a API: ", status_code(resposta))
}
colnames(dados_df) <- dados_df[1,]
dados_df <- dados_df[-1,]
write.csv2(dados_df,"dados_brutos/dados_df.csv")
