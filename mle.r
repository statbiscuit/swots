require(png)
require(animation)
## likelihood and dL/dp
lik <- function(x,n,p){
    choose(n,x)*p^x*(1-p)^(n-x)
}
dl <- function(x,n,p){
    choose(n,x)*p^(x-1)*(1 - p)^(n - x - 1)*(x - n*p)
}

pngs <- list.files("mle_pics",pattern = ".png",full = TRUE)
imgs <- lapply(pngs,png::readPNG)

## Binomial params
n <- 190
x <- 125
p <- seq(0.55,0.75,length.out = 300)
mle <- x/n
## id mle
idx <- which(abs(p - mle) == min(abs(p - mle)))
p.new <- c(p[1:idx],rep(mle,15),p[idx:length(p)]) ## spend 16 at hill peak
idx.plt <- rep(1:4,times = length(p)/4)
idx.plt <- c(idx.plt[1:(idx-1)],rep(5:12,times = 2),idx.plt[idx:length(p)])

ani.options(interval = 0.1)
saveGIF(
    for(i in 1: length(p.new)){
        layout(matrix(c(1,1,1,2,2,2,2,2,2),ncol = 3,byrow = TRUE))
        par(mar = c(0,0,0,0))
        plot(1,type = "n", axes = FALSE,xlim = c(p.new[1],p.new[length(p.new)]),xlab ="",ylim = c(0,1),ylab = "")
        rasterImage(imgs[[idx.plt[i]]],p.new[i] - 0.1,0,p.new[i] + 0.1,1)
        par(mar = c(4.5,4.5,0,0))
        plot(p.new,lik(x,n,p.new),type = "l",ylab = "L(p;x)", lwd = 3,cex.lab = 2,
             xlab = "p",xaxt = "n",yaxt = "n")
        axis(1, tick = TRUE,cex.axis = 2)
        axis(2, tick = TRUE, at = c(0.00,0.02,0.04,0.06),cex.axis = 2,las = 2)
        vall <- round(dl(x,n,p.new[i]),3)
        points(p.new[i],lik(x,n,p.new[i]),col = "red",pch = 20, cex = 3)
        legend("topleft",bty = "n",legend = bquote(frac(dL,dp) == .(vall)),cex = 3)
    },movie.name = "lik.gif"
)
