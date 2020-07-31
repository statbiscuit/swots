## list images
pics <- list.files("images",full = TRUE)
## read in rgb values of 
rgbs <- lapply(pics, jpeg::readJPEG)

cluster_ducks <- data.frame(attire  = stringr::str_match(pics,"images/(.*?)-")[,2],
                            av_red = sapply(rgbs, function(x) mean(c(x[,,1]))),
                            av_green = sapply(rgbs, function(x) mean(c(x[,,2]))),
                            av_blue = sapply(rgbs, function(x) mean(c(x[,,3]))))


prop.max <- function(x){
    ## matrix of index of max RGB values of x
    mat_max <- apply(x,c(1,2),which.max)
    ## table of collapsed values
    tab <- table(c(mat_max))
    ## proportion of red
    prop_red <- tab[1]/sum(tab)
    prop_green <- tab[2]/sum(tab)
    prop_blue <- tab[3]/sum(tab)
    return(c(prop_red,prop_green,prop_blue))
}
## proportion of r, g, b in each image
prop <- do.call('rbind',lapply(rgbs,prop.max))
cluster_ducks$prop_red <- prop[,1]
cluster_ducks$prop_green <- prop[,2]
cluster_ducks$prop_blue <- prop[,3]



library(ggplot2)
ggplot(cluster_ducks, aes(x = av_red, y = av_green, color = attire)) +
    geom_point()

ggplot(cluster_ducks, aes(x = av_red, y = av_blue, color = attire)) +
    geom_point()

ggplot(cluster_ducks, aes(x = prop_blue, y = prop_green, color = attire)) +
    geom_point()
