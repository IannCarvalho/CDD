theme_report <- function(base_size = 11,
                         strip_text_size = 12,
                         strip_text_margin = 5,
                         subtitle_size = 13,
                         subtitle_margin = 10,
                         plot_title_size = 16,
                         plot_title_margin = 10,
                         ...) {
    require(ggplot2)
    ret <- theme_minimal(base_family = "Roboto-Regular",
                         base_size = base_size, ...)
    ret$strip.text <- element_text(
        hjust = 0,
        size = strip_text_size,
        margin = margin(b = strip_text_margin),
        family = "Roboto-Bold"
    )
    ret$plot.subtitle <- element_text(
        hjust = 0,
        size = subtitle_size,
        margin = margin(b = subtitle_margin),
        family = "PT Sans"
    )
    ret$plot.title <-
        element_text(
            hjust = 0,
            size = plot_title_size,
            margin = margin(b = plot_title_margin),
            family = "Oswald"
        )
    ret
}

import_data <- function(celebridade = "tom_cruise"){
    #' Usa o nome como aparece na url do rottentomatoes.com 
    #' Ex: Tom Cruise tem a url https://www.rottentomatoes.com/celebrity/tom_cruise/ 
    #' O argumento deve ser tom_cruise
    require(tidyverse, warn.conflicts = F)
    require(rvest)
    
    url_alvo = str_glue("https://www.rottentomatoes.com/celebrity/{celebridade}")
    
    from_page <- read_html(url_alvo) %>% 
        html_node("#filmography") %>% # A sintaxe da expressão é de um seletor à lá JQuery: https://rdrr.io/cran/rvest/man/html_nodes.html 
        html_node("table") %>%
        html_table(fill=TRUE) %>% # Faz parse
        as_tibble()
    
    filmes = from_page %>% 
        filter(RATING != "No Score Yet", 
               BOXOFFICE != "—", 
               !(CREDIT %in% c("Producer", "Executive Producer"))) %>%
        mutate(RATING = as.numeric(gsub("%", "", RATING)),
               CREDIT = gsub("\n *", " ", CREDIT),
               BOXOFFICE = as.numeric(gsub("[$|M]", "", BOXOFFICE))) %>% 
        filter(BOXOFFICE >= 1)
    
    filmes %>% 
        write_csv(here::here("data/movies.csv"))
}

read_imported_data <- function(){
    read_csv(here::here("data/movies.csv"), 
             col_types = "iccdi") %>% 
        rename(filme = TITLE,
               avaliacao = RATING, 
               bilheteria = BOXOFFICE,
               ano = YEAR, 
               papel = CREDIT)
}
