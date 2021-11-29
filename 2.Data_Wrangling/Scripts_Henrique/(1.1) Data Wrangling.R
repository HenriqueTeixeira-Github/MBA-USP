# Instalação do "tidyverse"
install.packages("tidyverse")

# Carregamento do pacote "tidyverse"
library("tidyverse")

# Carregamento do pacote "readxl"
library(readxl)

# Importação dos datasets:
dataset_inicial <- read_excel("(1.2) Dataset Aula Data Wrangling.xls")
dataset_merge <- read_excel("(1.3) Dataset Aula Data Wrangling (Join).xls")

# Formas de visualizar os dados:
View(dataset_inicial)       # Mostra a base de dados completa em uma nova aba.
head(dataset_inicial, n=5)  # Mostra as N primeiras observações da base de dados.
str(dataset_inicial)        # Mostra a estrutura da base de dados.
glimpse(dataset_inicial)    # Mostra a estrutura da base de dados (semelhante ao str).
print(dataset_inicial)      # Apresenta a base de dados no console.
dim(dataset_inicial)        # As dimensões do dataset: linhas e colunas, respectivamente.
names(dataset_inicial)      # Para listar os nomes das variáveis.

# Formas de visualizar apenas uma das variáveis:
 
dataset_inicial$Estudante # Mostrar a variável especificada.
dataset_inicial$`Tempo para chegar à escola (minutos)` # Mostrar a variável especificada.

# --------------------------- RENAME --------------------------- #

# RENAME: Função utilizada para mudar os nomes das variáveis

nova_base <- rename(dataset_inicial, 
                    observacoes = "Estudante",
                    tempo = "Tempo para chegar à escola (minutos)",
                    distancia = "Distância percorrida até a escola (quilômetros)",
                    semaforos = "Quantidade de semáforos",
                    periodo = "Período do dia",
                    perfil = "Perfil ao volante")

head(nova_base, n=5) # Visualizar o resultado.

# PIPE: Operador que possibilita a execução de diversas funções em sequência. 
# Atalho: Ctrl+Shift + M

nova_base_pipe <- nova_base %>% rename(obs = observacoes,
                                       temp = tempo,
                                       dist = distancia,
                                       sem = semaforos,
                                       per = periodo,
                                       perf = perfil)

# Forma para remover um objeto criado no R:
rm(nova_base_pipe)

# O comando RENAME também poder se basear na posição
nova_base %>% rename(obs = 1,
                     temp = 2,
                     dist = 3,
                     sem = 4,
                     per = 5,
                     perf = 6) # Nesse comando não alteramos a variável

# Alteração de apenas algumas variáveis
nova_base %>% rename(sem = 4,
                     perf = 6)

# --------------------------- MUTATE --------------------------- #

# MUTATE: Responsável por INCLUIR ou TRANSFORMAR o conteúdo das variáveis.

# INCLUSÃO de variáveis:

variavel_nova_1 <- c(1,2,3,4,5,6,7,8,9,10) # Variável 1
variavel_nova_2 <- c(11:20) # Variável 2

base_inclui <- mutate(nova_base,
                      variavel_nova_1, 
                      variavel_nova_2) # Adição das variáveis no dataset

#Remoção da variável "nova_base_pipe"
rm(base_inclui)

#IMPORTANTE: Para esse tipo de adição os valores devem estar na sequência correta.

#É possivel adicionar variáveis e renomear em sequência com o "pipe"
nova_base_pipe <- nova_base %>% rename(
                     obs = observacoes,
                     temp = tempo,
                     dist = distancia,
                     sem = semaforos,
                     per = periodo,
                     perf = perfil) %>% 
              mutate(
                     variavel_nova_1,
                     variavel_nova_2,
                     temp_novo = temp*2)

#Remoção da variável "nova_base_pipe"
rm(nova_base_pipe)

# TRANFORMAÇÃO de variáveis com MUTATE e REPLACE:

base_texto_1 <- mutate(nova_base, 
                       semaforos = replace(semaforos, semaforos==0, "Zero"),
                       semaforos = replace(semaforos, semaforos==1, "Um"),
                       semaforos = replace(semaforos, semaforos==2, "Dois"),
                       semaforos = replace(semaforos, semaforos==3, "Três")
                       )

#Remoção da variável "base_texto_1"
rm(base_texto_1)

# ADIÇÃO de variáveis com MUTATE e RECODE:

base_texto_2 <- mutate(nova_base, 
                       perfil_novo = recode(perfil,
                                             "calmo"="perfil 1",
                                             "moderado"="perfil 2",
                                             "agressivo"="perfil 3"
                                             ),
                       periodo_novo = recode(periodo,
                                             "Manhã" = "Periodo 1",
                                             "Tarde" = "Periodo 2"
                                             )
                       )

#Remoção da variável "base_texto_2"
rm(base_texto_2)

# SUBSTITUIÇÃO de variáveis com MUTATE e RECODE:

base_texto_valores <- mutate(nova_base,
                             periodo = recode(periodo,
                                              "Manhã"=0,
                                              "Tarde"=1)
                                              )

# Remoção da variável "base_texto_valores"
rm(base_texto_valores)

# Seria possível utilizar a função acima para criar "dummies":
base_dummy <- mutate(nova_base, 
                     perfil_agressivo = recode(perfil,
                                                "agressivo"=1,
                                                "moderado"=0,
                                                "calmo"=0),
                     perfil_moderado = recode(perfil,
                                                "agressivo"=0,
                                                "moderado"=1,
                                                "calmo"=0),
                     perfil_calmo = recode(perfil,
                                                "agressivo"=0,
                                                "moderado"=0,
                                                "calmo"=1)
                     )

# Remoção da variável "base_dummy"
rm(base_dummy)


# --------------------------- TRANSMUTE --------------------------- #

# TRANSMUTE: Responsável por INCLUIR variáveis com EXCLUSÃO das demais variáveis existentes no dataset.

base_exclui <- transmute(nova_base,
                         observacoes, tempo,
                         variavel_nova_1, variavel_nova_2)

# Remoção da variável "base_exclui"
rm(base_exclui)

# Aplicando o transmute junto com o pipe em um exemplo mais complexo

# variavel_nova_1 <- c(1,2,3,4,5,6,7,8,9,10) # Variável 1

base_exclui_rename <- nova_base %>% 
                transmute(observacoes, tempo, variavel_nova_1) %>% 
                mutate(tempo_novo = recode(tempo,
                             "10"="dez",
                             "15"="quinze",
                             "20"="vinte",
                             "25"="vinte e cinco",
                             "30"="trinta",
                             "35"="trinta e cinco",
                             "40"="quarenta",
                             "50"="cinquenta",
                             "55"="cinquenta e cinco")) %>% 
                mutate(posicao = 
                          cut(tempo, 
                              breaks = c(0, median(tempo), Inf), 
                              labels = c("Menores","Maiores")
                             )
                       )

# Para checar os valores das colunas, basta calcular a mediana.
median(nova_base$tempo)

# Remoção da variável "base_exclui_rename"
rm(base_exclui_rename)

# --------------------------- SELECT --------------------------- #

# SELECT: Responsável por selecionar variáveis e manter as variáveis no dataset.

base_select_1 <- select(nova_base, observacoes, tempo)      # Especificando as variáveis.
base_select_2 <- select(nova_base,  everything(), -perfil)  # Todas menos uma variável.
base_select_3 <- select(nova_base, observacoes:distancia)   # Intervalo de variáveis.
base_select_4 <- select(nova_base, starts_with("p"))        # Com algum prefixo comum.

# O SELECT também é capaz de reposicionar as variáveis do dataset.

nova_base %>% select(observacoes, perfil, everything())     # everything() colocará todas as variáveis restantes

#Utilizando o SELECT para colocar em uma ordem específica.

nova_base %>% select(tempo, semaforos, perfil, observacoes)

# Remoção das variáveis especificadas.
rm(base_select_1)
rm(base_select_2)
rm(base_select_3)
rm(base_select_4)

# --------------------------- PULL --------------------------- #

# PULL: Responsável por gerar um vetor com a informação solicitada

vetor_pull <- nova_base %>% pull(var = 3)

rm(vetor_pull)


# --------------------------- RELOCATE --------------------------- #

# RELOCATE: Responsável por REALOCAR as variáveis e manter as mesmas no dataset.

nova_base %>% relocate(perfil, .after = observacoes)
nova_base %>% relocate(perfil, .before = tempo)
