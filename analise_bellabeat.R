# 1. CONFIGURAR O DIRETÓRIO
setwd("/Users/calade/Downloads/archive/projeto_bellabeat")

# 2. CARREGAR AS BIBLIOTECAS (O motor da análise)
library(tidyverse)
library(lubridate)

# 3. IMPORTAR OS DADOS
activity <- read_csv("dailyActivity_merged.csv")
sleep <- read_csv("sleepDay_merged.csv")

# 4. LIMPEZA E FORMATAÇÃO (O "Secret Sauce")
# Remover duplicatas e nulos
activity <- activity %>% distinct() %>% drop_na()
sleep <- sleep %>% distinct() %>% drop_na()

# Arrumar as datas para o padrão de data do R
activity <- activity %>%
  mutate(ActivityDate = as.Date(ActivityDate, format="%m/%d/%Y"))

sleep <- sleep %>%
  mutate(SleepDay = as.Date(SleepDay, format="%m/%d/%Y %I:%M:%S %p"))

# 5. UNIR AS TABELAS (Merge por ID e Data)
combined_data <- merge(activity, sleep, by.x = c("Id", "ActivityDate"), by.y = c("Id", "SleepDay"))

# 6. GERAR O PRIMEIRO INSIGHT (Gráfico: Passos vs Minutos de Sono)
# Esse gráfico mostra se quem caminha mais dorme melhor
ggplot(data = combined_data, aes(x = TotalSteps, y = TotalMinutesAsleep)) +
  geom_point(color="purple") + 
  geom_smooth(method="lm", color="orange") +
  labs(title = "Relação: Passos Diários vs Minutos de Sono",
       x = "Passos Totais",
       y = "Minutos Dormidos") +
  theme_minimal()

# 7. RESUMO ESTATÍSTICO (Para você colocar no seu texto do GitHub)
summary(combined_data %>% select(TotalSteps, TotalMinutesAsleep, Calories))
