library(png)
library(animation)

bread <- readPNG("figs/original.png")

l.sim <- 30
## pc1 axis
h1 <- seq(360,315,length.out = l.sim)
t1 <- seq(180,135,length.out = l.sim)
## pc2 axis
h2 <- seq(90,45,length.out = l.sim)
t2 <- seq(270,225,length.out = l.sim)
## pc3 axis
h3 <- seq(45,0,length.out = l.sim)
t3 <- seq(225,180,length.out = l.sim)

ani.options(interval = 0.1)
saveGIF(
    for(i in 1:l.sim){
        par(mar = c(0,0,4,4),xpd = TRUE)
        plot(1, type = "n",axes = FALSE, xlab = "", ylab = "",xlim = c(-1,1), ylim = c(-1,1),asp = 1)
        rasterImage(bread,-0.9,-0.9,0.9,0.9)
        ## pc1 axis
        arrows(sin(t1[i]*pi/180),cos(t1[i]*pi/180),sin(h1[i]*pi/180),cos(h1[i]*pi/180),lwd = 5,length = 0.1)
        text(sin(h1[i]*pi/180),cos(h1[i]*pi/180) + 0.1,"PC 1",cex = 1.25)
        ## pc2 axis
        arrows(sin(t2[i]*pi/180),cos(t2[i]*pi/180),sin(h2[i]*pi/180),cos(h2[i]*pi/180),lwd = 5,length = 0.1)
        text(sin(h2[i]*pi/180) + 0.1,cos(h2[i]*pi/180),"PC 2",cex = 1.25)
        ## pc3 axis
        arrows(sin(t3[i]*pi/180),cos(t3[i]*pi/180),sin(h3[i]*pi/180),cos(h3[i]*pi/180),lwd = 5,length = 0.1)
        text(sin(h3[i]*pi/180) + 0.1,cos(h3[i]*pi/180) + 0.1,"PC 3",cex = 1.25)
    },movie.name = "~/Desktop/pca.gif"
)
