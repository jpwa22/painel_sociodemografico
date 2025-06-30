library(readxl)
library(dplyr)
library(tidyr)
library(purrr)
library(stringr)

# Lista de arquivos
arquivos <- c(
  "dados_tratados/panorama/Alfabetização.xlsx",
  "dados_tratados/panorama/Características do entorno.xlsx",
  "dados_tratados/panorama/Características dos domicílios.xlsx",
  "dados_tratados/panorama/Composição domiciliar.xlsx",
  "dados_tratados/panorama/Crescimento Populacional.xlsx",
  "dados_tratados/panorama/Deficiência e autismo.xlsx",
  "dados_tratados/panorama/Nível de instrução.xlsx",
  "dados_tratados/panorama/Pirâmide etária.xlsx",
  "dados_tratados/panorama/População indígena.xlsx",
  "dados_tratados/panorama/População por cor ou raça.xlsx",
  "dados_tratados/panorama/População por religião.xlsx",
  "dados_tratados/panorama/População por sexo.xlsx",
  "dados_tratados/panorama/População por situação do domicílio.xlsx",
  "dados_tratados/panorama/População quilombola.xlsx",
  "dados_tratados/panorama/População residente em favelas.xlsx",
  "dados_tratados/panorama/Território.xlsx"
)


# Alfabetização -----------------------------------------------------------

df <- read_excel(arquivos[1])
# Força o tipo da chave como string com 7 dígitos
df <- df %>%
  mutate(Código.do.Município = sprintf("%07d", as.integer(Código.do.Município))) %>%
  select(-Município, -Sigla.UF)

df <- df %>% select(-Percentual)


df <- df %>% transmute( Código.do.Município,
                        Tema = "Alfabetização",
                        Atributo = Situação,
                        Valor = `População(pessoas)`,
                        Unidade = "População(pessoas)"
                       )
Alfabetização <- df
write.csv2(Alfabetização,"dados_tratados/csv/tabelas/alfabetizacao.csv")


# Características do entorno ----------------------------------------------

df <- read_excel(arquivos[2])
glimpse(df)
# Força o tipo da chave como string com 7 dígitos
df <- df %>%
  mutate(Código.do.Município = sprintf("%07d", as.integer(Código.do.Município))) %>%
  select(-Município, -Sigla.UF)

df <- df %>% transmute( Código.do.Município,
                        Tema = "Características do entorno",
                        Atributo = Característica,
                        Valor = `Possui(%)`,
                        Unidade = "Percentual"
)
Entorno <- df
write.csv2(Entorno,"dados_tratados/csv/tabelas/Entorno.csv")

# Características dos domicílios -----------------------------------------------------------------------


df <- read_excel(arquivos[3])
glimpse(df)
# Força o tipo da chave como string com 7 dígitos
df <- df %>%
  mutate(Código.do.Município = sprintf("%07d", as.integer(Código.do.Município))) %>%
  select(-Município, -Sigla.UF)

df <- df %>% transmute( Código.do.Município,
                        Tema = "Características dos domicílios",
                        Atributo = Característica,
                        Valor = `Possui(%)`,
                        Unidade = "Percentual"
)
Domicílio <- df
write.csv2(Domicílio,"dados_tratados/csv/tabelas/Domicilio.csv")


# Composição domiciliar ---------------------------------------------------


df <- read_excel(arquivos[4])
glimpse(df)
# Força o tipo da chave como string com 7 dígitos
df <- df %>%
  mutate(Código.do.Município = sprintf("%07d", as.integer(Código.do.Município))) %>%
  select(-Município, -Sigla.UF)

df <- df %>% transmute( Código.do.Município,
                        Tema = "Composição domiciliar",
                        Atributo = Composição.domiciliar,
                        Valor = Porcentagem.de.domicílios,
                        Unidade = "Percentual")
Domiciliar <- df
write.csv2(Domiciliar,"dados_tratados/csv/tabelas/Domiciliar.csv")


# Crescimento Populacional ------------------------------------------------

df <- read_excel(arquivos[5])
glimpse(df)
# Força o tipo da chave como string com 7 dígitos
df <- df %>%
  mutate(Código.do.Município = sprintf("%07d", as.integer(Código.do.Município))) %>%
  select(-Município, -Sigla.UF)

df <- df %>% transmute( Código.do.Município,
                        Tema = "Crescimento Populacional",
                        Atributo = Ano.da.pesquisa ,
                        Valor = `População(pessoas)` ,
                        Unidade = "População(pessoas)")
Cresc_Pop <- df
write.csv2(Cresc_Pop,"dados_tratados/csv/tabelas/Cresc_Pop.csv")


# Deficiência e autismo ---------------------------------------------------

df <- read_excel(arquivos[6])
glimpse(df)
# Força o tipo da chave como string com 7 dígitos
df <- df %>%
  mutate(Código.do.Município = sprintf("%07d", as.integer(Código.do.Município))) %>%
  select(-Município, -Sigla.UF)

df <- df %>% transmute( Código.do.Município,
                        Tema = "Deficiência e autismo",
                        Atributo = Deficiência.e.autismo ,
                        Valor = Porcentagem.de.pessoas ,
                        Unidade = "Percentual")
Def_Autismo <- df
write.csv2(Def_Autismo,"dados_tratados/csv/tabelas/Def_Autismo.csv")



# Nível de instrução ------------------------------------------------------

df <- read_excel(arquivos[7])
glimpse(df)
# Força o tipo da chave como string com 7 dígitos
df <- df %>%
  mutate(Código.do.Município = sprintf("%07d", as.integer(Código.do.Município))) %>%
  select(-Município, -Sigla.UF)

df <- df %>% transmute( Código.do.Município,
                        Tema = "Nível de instrução",
                        Atributo = Nível.de.instrução,
                        Valor =`População.(pessoas)`  ,
                        Unidade = "População(pessoas)")
Instrução <- df
write.csv2(Instrução,"dados_tratados/csv/tabelas/Instrução.csv")


# Pirâmide etária ---------------------------------------------------------

df <- read_excel(arquivos[8])
glimpse(df)
# Força o tipo da chave como string com 7 dígitos
df <- df %>% 
  mutate(Código.do.Município = sprintf("%07d", as.integer(codMun))) %>%
  select(-Município, -Sigla.UF, -codMun)

Pir_Pop_Masc <- df %>% transmute( Código.do.Município,
                                  Tema = "Pirâmide etária",
                        Atributo = Grupo.de.idade,
                        Valor =`População.masculina(pessoas)`  ,
                        Unidade = "População(pessoas)") 

write.csv2(Pir_Pop_Masc,"dados_tratados/csv/tabelas/Pir_Pop_Masc.csv")

Pir_Pop_Fem <- df %>% transmute( Código.do.Município,
                                 Tema = "Pirâmide etária",
                                  Atributo = Grupo.de.idade,
                                  Valor =`População.feminina(pessoas)`  ,
                                  Unidade = "População(pessoas)") 

write.csv2(Pir_Pop_Fem,"dados_tratados/csv/tabelas/Pir_Pop_Fem.csv")


# População indígena ------------------------------------------------------

df <- read_excel(arquivos[9])
glimpse(df)
# Força o tipo da chave como string com 7 dígitos
df <- df %>%
  mutate(Código.do.Município = sprintf("%07d", as.integer(Código.do.Município))) %>%
  select(-Município, -Sigla.UF)

Indigena_Pop <- df %>% transmute( Código.do.Município,
                                  Tema = "População indígena",
                                  Atributo = População.indígena ,
                                  Valor = pessoas,
                                  Unidade = "População(pessoas)") 

write.csv2(Indigena_Pop,"dados_tratados/csv/tabelas/Indigena_Pop.csv")



# População por cor ou raça -----------------------------------------------

df <- read_excel(arquivos[10])
glimpse(df)

# Força o tipo da chave como string com 7 dígitos
df <- df %>%
  mutate(Código.do.Município = sprintf("%07d", as.integer(Código.do.Município))) %>%
  select(-Município, -Sigla.UF)

Cor_raça  <- df %>% transmute( Código.do.Município,
                               Tema = "População por cor ou raça",
                                  Atributo = Cor.ou.raça ,
                                  Valor = `População.(pessoas)`,
                                  Unidade = "População(pessoas)") 

write.csv2(Cor_raça,"dados_tratados/csv/tabelas/Cor_raça.csv")


# População por religião --------------------------------------------------
df <- read_excel(arquivos[11])
glimpse(df)

# Força o tipo da chave como string com 7 dígitos
df <- df %>%
  mutate(Código.do.Município = sprintf("%07d", as.integer(Código.do.Município))) %>%
  select(-Município, -Sigla.UF)

Religião  <- df %>% transmute( Código.do.Município,
                               Tema = "População por religião",
                               Atributo = Religião ,
                               Valor = `População.(pessoas)`,
                               Unidade = "População(pessoas)") 

write.csv2(Religião,"dados_tratados/csv/tabelas/Religião.csv")


# População por sexo ------------------------------------------------------


df <- read_excel(arquivos[12])
glimpse(df)

# Força o tipo da chave como string com 7 dígitos
df <- df %>%
  mutate(Código.do.Município = sprintf("%07d", as.integer(Código.do.Município))) %>%
  select(-Município, -Sigla.UF)

Sexo  <- df %>% transmute( Código.do.Município,
                           Tema = "População por sexo",
                               Atributo = Sexo ,
                               Valor = `População(pessoas)`,
                               Unidade = "População(pessoas)") 

write.csv2(Sexo,"dados_tratados/csv/tabelas/Sexo.csv")


# População por situação do domicílio -------------------------------------

df <- read_excel(arquivos[13])
glimpse(df)

# Força o tipo da chave como string com 7 dígitos
df <- df %>%
  mutate(Código.do.Município = sprintf("%07d", as.integer(Código.do.Município))) %>%
  select(-Município, -Sigla.UF)

Pop_Sit_Domicilio  <- df %>% transmute( Código.do.Município,
                                        Tema = "População por situação do domicílio",
                           Atributo = Situação ,
                           Valor = `População.(pessoas)` ,
                           Unidade = "População(pessoas)") 

write.csv2(Pop_Sit_Domicilio,"dados_tratados/csv/tabelas/Pop_Sit_Domicilio.csv")


# População quilombola ----------------------------------------------------

df <- read_excel(arquivos[14])
glimpse(df)

# Força o tipo da chave como string com 7 dígitos
df <- df %>%
  mutate(Código.do.Município = sprintf("%07d", as.integer(Código.do.Município))) %>%
  select(-Município, -Sigla.UF)

Pop_Quilombola  <- df %>% transmute( Código.do.Município,
                                     Tema = "População quilombola",
                                        Atributo = "População.quilombola.(pessoas)",
                                        Valor = `População.quilombola.(pessoas)` ,
                                        Unidade = "População(pessoas)") 

write.csv2(Pop_Quilombola,"dados_tratados/csv/tabelas/Pop_Quilombola.csv")


# População residente em favelas ------------------------------------------

df <- read_excel(arquivos[15])
glimpse(df)

# Força o tipo da chave como string com 7 dígitos
df <- df %>%
  mutate(Código.do.Município = sprintf("%07d", as.integer(Código.do.Município))) %>%
  select(-Município, -Sigla.UF)

Pop_Favelas  <- df %>% transmute( Código.do.Município,
                                  Tema = "População residente em favelas",
                                     Atributo = Situação,
                                     Valor = `População(pessoas)`  ,
                                     Unidade = "`População(pessoas)`") 

write.csv2(Pop_Favelas,"dados_tratados/csv/tabelas/Pop_Favelas.csv")


# Território --------------------------------------------------------------

df <- read_excel(arquivos[16])
glimpse(df)

# Força o tipo da chave como string com 7 dígitos
df <- df %>%
  mutate(Código.do.Município = sprintf("%07d", as.integer(Código.do.Município))) %>%
  select(-Município, -Sigla.UF)

Area_km  <- df %>% transmute( Código.do.Município,
                              Tema = "Territórios",
                                  Atributo = Ano.da.pesquisa,
                                  Valor = `Área(km²)`  ,
                                  Unidade = "Área(km²)") 

write.csv2(Area_km,"dados_tratados/csv/tabelas/Area_km.csv")

Densidade_demografica  <- df %>% transmute( Código.do.Município,
                                            Tema = "Territórios",
                              Atributo = Ano.da.pesquisa,
                              Valor = `Densidade.demográfica(hab/km²)`  ,
                              Unidade = "Área(km²)") 

write.csv2(Densidade_demografica,"dados_tratados/csv/tabelas/Densidade_demografica.csv")

rm(df,arquivos)


# Define o caminho da pasta
caminho_base <- "dados_tratados/csv/tabelas"

# Lista todos os arquivos dentro de "panorama" e subpastas
arquivos <- list.files(path = caminho_base, recursive = TRUE, full.names = TRUE)


df <- Sexo[0,]



for (arquivo in arquivos) {
  message(arquivo)
  df <- rbind(df,read.csv2(arquivo))
  
}


write.csv2(df,"dados_tratados/df.csv")
saveRDS(df,"dados_tratados/df.rds")
