## list images
pics <- list.files("images",full = TRUE)
## read in rgb values of 
rgbs <- lapply(pics, jpeg::readJPEG)

cluster_ducks <- data.frame(attire  = stringr::str_match(pics,"images/(.*?)-")[,2],
                            av_red = sapply(rgbs, function(x) mean(c(x[,,1]))),
                            av_green = sapply(rgbs, function(x) mean(c(x[,,2]))),
                            av_blue = sapply(rgbs, function(x) mean(c(x[,,3]))))
library(ggplot2)
ggplot(cluster_ducks, aes(x = av_red, y = av_green, color = attire)) +
    geom_point()

ggplot(cluster_ducks, aes(x = av_red, y = av_blue, color = attire)) +
    geom_point()


tst <- apply(rgbs[[1]],3, max)
