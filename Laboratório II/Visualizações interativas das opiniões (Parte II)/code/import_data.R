library(tidyverse)

raw_ccc = read_csv("https://raw.githubusercontent.com/nazareno/enade-vis/master/data/enade_2017_cccs_medias.csv")

raw_ufcg = read_csv("https://raw.githubusercontent.com/nazareno/enade-vis/master/data/enade_2017_ufcg_medias.csv")

enunciados_resumidos = read_csv(here::here("data/raw/enunciados.csv"))

raw_ccc %>% 
    mutate(IES = if_else(NOME_CURSO == "Ciência Da Computação (Bacharelado) (107920)", 
                         "FAC. PITÁGORAS DE SÃO LUIZ", 
                         IES)) %>% 
    left_join(enunciados_resumidos) %>% 
    filter(!is.na(IES)) %>% 
    write_csv(here::here("data/enade-ccc-2017.csv"))

raw_ufcg %>% 
    left_join(enunciados_resumidos) %>% 
    filter(!is.na(IES)) %>% 
    write_csv(here::here("data/enade-ufcg-2017.csv"))
