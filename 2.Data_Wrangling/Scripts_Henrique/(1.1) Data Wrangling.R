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
                                            "agressivo"="perfil 3"),
                       periodo_novo = recode(periodo,
                                             "Manhã" = "Periodo 1",
                                             "Tarde" = "Periodo 2",
                                             "Noite" = "Periodo 3"
                                             )
                       )

#Remoção da variável "base_texto_2"
rm(base_texto_2)





