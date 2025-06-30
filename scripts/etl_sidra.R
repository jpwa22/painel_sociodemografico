library(httr)
library(jsonlite)
library(dplyr)

# Lista de municípios de PE (códigos IBGE)
get_municipios_pe <- function() {
  url <- "https://servicodados.ibge.gov.br/api/v1/localidades/estados/26/municipios"
  municipios_json <- fromJSON(url)
  tibble(
    nome = municipios_json$nome,
    codigo_ibge = as.character(municipios_json$id)
  )
}

municipios <- get_municipios_pe()


# Deficiência ------------------------------------------------------------


tabela <- as.character("10125") #   Tabela 10125 - Pessoas residentes de 2 anos ou mais de idade, total e pessoas com deficiência, por sexo e grupos de idade
#### Grupo de Idade 
"3302,73770,104578" # 2,15,59 (3 faixas)
faixa_etaria <- "1143,1144,1145,1146,1147,1148,1149,1150,1151,3302,73770" # Várias


for (i in seq_len(nrow(municipios))) {
  
  cod_mun <- municipios$codigo_ibge[i]
  nome_mun <- municipios$nome[i]
  url <- paste0("https://apisidra.ibge.gov.br/values/t/",tabela,"/n6/",cod_mun, "/v/11852,12785/p/last/c2/6794/c58/",faixa_etaria)
  resposta <- GET(url)
  conteudo <- content(resposta, as = "text", encoding = "UTF-8")
  dados_json <- fromJSON(conteudo)
  write.csv2(dados_json,paste("dados_brutos/pcd/pcd_",tabela,"_",trimws(cod_mun),".csv"))
}

"https://apisidra.ibge.gov.br/values/t/10127/n1/all/n6/2600054/v/11852,12785/p/all/c1509/73771,73772,73773,73789,73790"

tabela <- as.character("10127") # Tabela 10127 - Pessoas residentes de 2 anos ou mais de idade com deficiência por tipos de dificuldades funcionais

for (i in seq_len(nrow(municipios))) {
  
  cod_mun <- municipios$codigo_ibge[i]
  nome_mun <- municipios$nome[i]
  url <- paste0("https://apisidra.ibge.gov.br/values/t/",tabela,"/n6/",cod_mun, "/v/11852,12785/p/all/c1509/73771,73772,73773,73789,73790")
  resposta <- GET(url)
  conteudo <- content(resposta, as = "text", encoding = "UTF-8")
  dados_json <- fromJSON(conteudo)
  write.csv2(dados_json,paste("dados_brutos/pcd/cor_pcd_",tabela,"_",trimws(cod_mun),".csv"))
}




# Favela ------------------------------------------------------------------
"https://apisidra.ibge.gov.br/values/t/9884/n6/2611606,2600054/v/allxp/p/all/c86/95251/c2/6794/c58/95253"

tabela <- as.character("9884") #   Tabela 9884 - População residente em favelas e comunidades urbanas, por cor ou raça, sexo e grupos de idade, segundo as Favelas e Comunidades Urbanas
for (i in seq_len(nrow(municipios))) {
  
  cod_mun <- municipios$codigo_ibge[i]
  nome_mun <- municipios$nome[i]
  url <- paste0("https://apisidra.ibge.gov.br/values/t/",tabela,"/n6/",cod_mun, "/v/allxp/p/all/c86/95251/c2/6794/c58/95253")
  resposta <- GET(url)
  conteudo <- content(resposta, as = "text", encoding = "UTF-8")
  dados_json <- fromJSON(conteudo)
  write.csv2(dados_json,paste("dados_brutos/favela/favela_",tabela,"_",trimws(cod_mun),".csv"))
}



# Residentes --------------------------------------------------------------

"https://apisidra.ibge.gov.br/values/t/9514/n1/all/n6/1100015/v/allxp/p/all/c2/allxt/c287/6557,6558,6559,6560,6561,6653,49108,49109,60040,60041,93084,93085,93086,93087,93088,93089,93090,93091,93092,93093,93094,93095,93096,93097,93098/c286/113635"
tabela <- as.character("9514") #   População residente, por sexo, idade e forma de declaração da idade
for (i in seq_len(nrow(municipios))) {
  
  cod_mun <- municipios$codigo_ibge[i]
  nome_mun <- municipios$nome[i]
  url <- paste0("https://apisidra.ibge.gov.br/values/t/",tabela,"/n6/",cod_mun, "/v/allxp/p/all/c2/allxt/c287/6557,6558,6559,6560,6561,6653,49108,49109,60040,60041,93084,93085,93086,93087,93088,93089,93090,93091,93092,93093,93094,93095,93096,93097,93098/c286/113635")
  resposta <- GET(url)
  conteudo <- content(resposta, as = "text", encoding = "UTF-8")
  dados_json <- fromJSON(conteudo)
  write.csv2(dados_json,paste("dados_brutos/pop_res/pop_res_",tabela,"_",trimws(cod_mun),".csv"))
}


"https://apisidra.ibge.gov.br/values/t/9606/n1/all/n6/1100023/v/allxp/p/last%201/c86/all/c2/6794/c287/6557,6558,6559,6560,6561,6653,49108,49109,60040,93084,93085,93086,93087,93088,93089,93090,93091,93092,93093,93094,93095,93096,93097,93098"


tabela <- as.character("9606") #  População residente, por cor ou raça, segundo o sexo e a idade
for (i in seq_len(nrow(municipios))) {
  
  cod_mun <- municipios$codigo_ibge[i]
  nome_mun <- municipios$nome[i]
  url <- paste0("https://apisidra.ibge.gov.br/values/t/",tabela,"/n6/",cod_mun, "/v/allxp/p/last%201/c86/all/c2/6794/c287/6557,6558,6559,6560,6561,6653,49108,49109,60040,93084,93085,93086,93087,93088,93089,93090,93091,93092,93093,93094,93095,93096,93097,93098")
  resposta <- GET(url)
  conteudo <- content(resposta, as = "text", encoding = "UTF-8")
  dados_json <- fromJSON(conteudo)
  write.csv2(dados_json,paste("dados_brutos/pop_res/cor_idade_pop_res_",tabela,"_",trimws(cod_mun),".csv"))
}


# Alfabetização -----------------------------------------------------------

"https://apisidra.ibge.gov.br/values/t/9542/n1/all/n6/1100031/v/allxp/p/all/c59/allxt/c2/allxt/c86/all/c287/100362"
tabela <- as.character("9542") # Tabela 9542 - Pessoas de 15 anos ou mais de idade, total e as alfabetizadas, por sexo, cor ou raça e grupos de idade
for (i in seq_len(nrow(municipios))) {
  
  cod_mun <- municipios$codigo_ibge[i]
  nome_mun <- municipios$nome[i]
  url <- paste0("https://apisidra.ibge.gov.br/values/t/",tabela,"/n6/",cod_mun, "/v/allxp/p/all/c59/allxt/c2/allxt/c86/all/c287/100362")
  resposta <- GET(url)
  conteudo <- content(resposta, as = "text", encoding = "UTF-8")
  dados_json <- fromJSON(conteudo)
  write.csv2(dados_json,paste("dados_brutos/alfabetizacao/alfabetizacao_",tabela,"_",trimws(cod_mun),".csv"))
}
