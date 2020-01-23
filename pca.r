library(png)
library(animation)

bread <- readPNG("figs/original.png")

## bread plot, axes rotating
l.sim <- 30
## pc1 axis
h1 <- seq(360,315,length.out = l.sim)
t1 <- seq(180,135,length.out = l.sim)
## pc2 axis
h2 <- seq(90,45,length.out = l.sim)
t2 <- seq(270,225,length.out = l.sim)
## pc3 axis
## h3 <- seq(45,0,length.out = l.sim)
## t3 <- seq(225,180,length.out = l.sim) ## 3D doesn't show well in plot

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
        ## arrows(sin(t3[i]*pi/180),cos(t3[i]*pi/180),sin(h3[i]*pi/180),cos(h3[i]*pi/180),lwd = 5,length = 0.1)
        ## text(sin(h3[i]*pi/180) + 0.1,cos(h3[i]*pi/180) + 0.1,"PC 3",cex = 1.25)
    },movie.name = "~/Desktop/pca.gif"
)

## perpendicular plot
## functions needed
## slope and intercept of line that passes through two points
l.eq <- function(c1,c2){
    m = (c2[2] - c1[2])/(c2[1] - c1[1])
    int = c1[2] - m*c1[1]
    return(c(m,int))
}
## slope and intercept of line perpendicular to line and given point
p.eq <- function(p1,m,int){
    m2 = -1*1/m
    int2 = p1[2] - m2*p1[1]
    return(c(m2,int2))
}
## point of intersection between two lines
p.int <- function(m1,int1,m2,int2){
    x = (int2 - int1)/(m1 - m2)
    y = m1*x + int1
    return(c(x,y))
}

## get interception point on line
get.inter <- function(x,m,b){
    perp <- p.eq(x,m,b)
    inter <- p.int(m,b,perp[1],perp[2])
    return(inter)
}
#######

set.seed(4321)
x <- rnorm(100)
y <- -x + rnorm(100, sd = 0.5)
## radius
r <- 3.75
pts <- cbind(x,y) ## data points

## bread data plot
png("~/Desktop/bread_data.png")
par(xpd = TRUE)
plot(x,y,,type = "n",axes = FALSE, ylab = "", xlab = "", xlim  = c(-3,3),ylim = c(-3,3))
rasterImage(bread,-4.25,-4.25,4,4)
points(x,y,pch = 20)
dev.off()

## rotating line
h <- c(seq(135,165,length.out = 30),seq(165,135,length.out = 30),seq(135,105,length.out = 30),seq(105,135,length.out = 30))
t <- c(seq(315,345,length.out = 30),seq(345,315,length.out = 30),seq(315,285,length.out = 30),seq(285,315,length.out = 30))
ani.options(interval = 0.2)
saveGIF(
    for(i in 1:length(h)){
        par(xpd = TRUE)
        plot(x,y,,type = "n",axes = FALSE, ylab = "", xlab = "", xlim  = c(-3,3),ylim = c(-3,3))                                  
        points(x,y,pch = 20)
        arrows(-3,-3,3,-3,length = 0.1, lwd = 5)
        arrows(-3,-3,-3,3,length = 0.1, lwd = 5)
        mtext(side = 1,"Lecture length")
        mtext(side = 2,"Student's attention span")
        ## red line for "best fit" axis
        arrows(r*sin(t[1]*pi/180),r*cos(t[1]*pi/180),r*sin(h[1]*pi/180),r*cos(h[1]*pi/180),lwd = 2,code = 0)
        arrows(r/2*sin(45*pi/180),r/2*cos(45*pi/180),r/2*sin(225*pi/180),r/2*cos(225*pi/180),lwd = 2,code = 0, lty = 2)
        ## end points of line
        pts1 <- c(r*sin(t[i]*pi/180),r*cos(t[i]*pi/180))
        pts2 <- c(r*sin(h[i]*pi/180),r*cos(h[i]*pi/180))
        arrows(pts1[1],pts1[2],pts2[1],pts2[2],lwd = 2,code = 0,col = "lightgrey")
        arrows(r/2*sin((t[i]+90)*pi/180),r/2*cos((t[i]+90)*pi/180),r/2*sin((h[i]+90)*pi/180),r/2*cos((h[i]+90)*pi/180),lwd = 2,
               code = 0, lty = 2,col = "lightgrey")
        ## get equation of new line
        new.line <- l.eq(pts1,pts2)
        inter <- apply(pts,1,get.inter,m = new.line[1], b = new.line[2]) ## all interception points
        arrows(pts[,1],pts[,2],inter[1,],inter[2,],code = 0,col = "blue")
    },movie.name = "~/Desktop/perp.gif"
)




