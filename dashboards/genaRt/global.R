library(shiny)
library(shinydashboard)
library(htmlwidgets)
library(magrittr)
library(readr)
library(tidyr)
library(tibble)
library(stringr)
library(ggplot2)
library(purrr)
library(dplyr)
library(ggpmisc)
## make required functions 
colnames_to_tags <- function(df){
    lapply(
        colnames(df),
        function(co) {
            tag(
                "p",
                list(
                    class = class(df[, co]),
                    tags$span(class = "glyphicon glyphicon-move"),
                    tags$strong(co)
                )
            )
        }
    )
}
ggplot_themed <- function(data) {
  data %>% 
    ggplot(aes(x, y)) +
    coord_equal() + 
    scale_size_identity() + 
    scale_colour_identity() + 
    scale_fill_identity() + 
    theme_void() 
}
map_size <-
    function(x) {
        ambient::normalise(x, to = c(0, 2))
    }


## palette_manual taken from
## https://github.com/djnavarro/jasmines/blob/f5455c3e0f35043f4147b5b2af32505517c671c5/R/palettes.R 
palette_manual <- function(...) {
  colours <- c(...)
  palette <- function(n = 50, alpha = 1) {
    m <- ceiling(n/length(colours))
    cols <- as.vector(t(replicate(m, colours)))
    cols <- grDevices::adjustcolor(cols, alpha.f = 1)
    return(cols[1:n])
  }
  return(palette)
}

## original grid
points_time0 <- expand_grid(x = seq(1, 50, by = 1), y = seq(1, 30, by = 1)) %>% 
    mutate(time = 0, id = row_number())
