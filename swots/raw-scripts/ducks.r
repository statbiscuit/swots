## list images
## pics <- list.files("images",full = TRUE)
## read in rgb values of 
## rgbs <- lapply(pics, jpeg::readJPEG)

load("duck_rgbs.RData")
library(ggplot2)
library(patchwork)
m <- reshape2::melt(t(apply(duck_rgbs[[1]][,,1],2,rev)))
r <- ggplot(m, aes(x = Var1, y = Var2, fill = value)) +
    geom_tile() + scale_fill_distiller(palette = "Reds", direction = 1) +
    theme_void() + theme(legend.position = "none")
m <- reshape2::melt(t(apply(duck_rgbs[[1]][,,2],2,rev)))
g <- ggplot(m, aes(x = Var1, y = Var2, fill = value)) +
    geom_tile() + scale_fill_distiller(palette = "Greens", direction = 1) +
    theme_void() + theme(legend.position = "none")
m <- reshape2::melt(t(apply(duck_rgbs[[1]][,,3],2,rev)))
b <- ggplot(m, aes(x = Var1, y = Var2, fill = value)) +
    geom_tile() + scale_fill_distiller(palette = "Blues", direction = 1) +
    theme_void() + theme(legend.position = "none")

r + g + b

cluster_ducks <- data.frame(attire  = stringr::str_match(names(duck_rgbs),"(.*?)-")[,2],
                            av_red = sapply(duck_rgbs, function(x) mean(c(x[,,1]))),
                            av_green = sapply(duck_rgbs, function(x) mean(c(x[,,2]))),
                            av_blue = sapply(duck_rgbs, function(x) mean(c(x[,,3]))))




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
prop <- do.call('rbind',lapply(duck_rgbs,prop.max))
cluster_ducks$prop_red <- prop[,1]
cluster_ducks$prop_green <- prop[,2]
cluster_ducks$prop_blue <- prop[,3]



library(ggplot2)
ggplot(cluster_ducks, aes(x = av_red, y = av_green, color = attire)) +
    geom_point() + scale_colour_brewer(type = "qual")

ggplot(cluster_ducks, aes(x = av_red, y = av_blue, color = attire)) +
    geom_point()  + scale_colour_brewer(type = "qual")

ggplot(cluster_ducks, aes(x = prop_blue, y = prop_red, color = attire)) +
    geom_point() + scale_colour_brewer(type = "qual")

ggplot(cluster_ducks, aes(x = prop_blue, y = prop_green, color = attire)) +
    geom_point() + scale_colour_brewer(type = "qual")

ggplot(cluster_ducks, aes(x = prop_red, y = prop_green, color = attire)) +
    geom_point() + scale_colour_brewer(type = "qual")


devtools::install_github("AckerDWM/gg3D")

library("gg3D")

ggplot(cluster_ducks, aes(x = prop_red, y = prop_green, z = prop_blue, color = attire)) + 
    axes_3D() +
    stat_3D()

x11()
ggplot(cluster_ducks, aes(x = av_red, y = av_green, z = av_blue, color = attire)) + 
    axes_3D() +
    stat_3D()

library(plotly)

plot_ly(x = cluster_ducks$prop_red, y = cluster_ducks$prop_green, z = cluster_ducks$prop_blue,
        type = "scatter3d", mode = "markers", color = cluster_ducks$attire)

plot_ly(x = cluster_ducks$av_red, y = cluster_ducks$av_green, z = cluster_ducks$av_blue,
        type = "scatter3d", mode = "markers", color = cluster_ducks$attire)
## k means clustering
library(factoextra)
df <- cluster_ducks[,2:7];rownames(df) <- stringr::str_match(pics,"images/(.*?).jp")[,2]
distance <- get_dist(df)
fviz_dist(distance, gradient = list(low = "#00AFBB", mid = "white", high = "#FC4E07"))


k2 <- kmeans(df, centers = 6, nstart = 25)

fviz_cluster(k2, data = df)
