png("pdqr.png",width = 1250,height = 500)
par(xpd = TRUE,mfrow = c(1,2), mar = c(4,2,0,3))
## Normal dist.
set.seed(1234)
x <- sort(rnorm(1000))
plot(x,dnorm(x),type = "l",axes = FALSE,xlab = "",ylab = "",lwd = 3)
n <- 200
p <- x[n]
## rnorm
col <- grey.colors(1,alpha = 0.1)
h <- hist(x,add = TRUE,freq = FALSE,border = col,cex = 2,col = col)
text(h$breaks[14],h$density[10],cex = 2,"rnorm")
arrows(h$breaks[13],h$density[10],h$breaks[11],h$density[10],col = 'lightgrey',lwd = 3)
## pnorm
polygon(c(x[x <= p],rev(x[x <= p])),c(rep(0,length(x[x<=p])),dnorm(rev(x[x<=p]))),col = "grey")
text(x[n/2],dnorm(x[n/2])/2,"pnorm",cex = 2)
## qnorm
arrows(p,0,p,dnorm(p),lwd = 3,lty = 2,code = 0)
text(p,0 - 0.025,"qnorm",cex = 2)
## dnorm
arrows(min(x),dnorm(p),p,dnorm(p),code = 0, lwd = 3,lty = 3)
text(min(x) - 0.5,dnorm(p),"dnorm",cex = 2,srt = 90)
## redo dnorm
lines(x,dnorm(x),lwd = 3)

## Poisson
set.seed(4321)
lam <- 2.5
x <- sort(rpois(1000,lam))
b <- barplot(dpois(unique(x),lam),axes = FALSE,col = col,border = col,
             ylim = c(-0.03,max(dpois(unique(x),lam))) + 0.02)
points(b[,1],dpois(unique(x),lam),cex = 3,pch = 20)
## rpois
text(b[8,1],dpois(unique(x)[5],lam),"rpois",cex = 2)
arrows(b[8,1],dpois(unique(x)[5],lam) - 0.01,
       b[6,1] + 0.5,dpois(unique(x)[7],lam) + 0.01,col = "lightgrey",lwd = 3)
## dpois
text(b[8,1],dpois(unique(x)[4],lam),"dpois",cex = 2)
arrows(b[7,1],dpois(unique(x)[4],lam),b[4,1],dpois(unique(x)[4],lam),code = 0,lwd = 3, lty = 3)
## qpois
text(b[4,1],-0.01,"qpois",cex = 2)
arrows(b[4,1],dpois(unique(x)[4],lam),b[4,1],0,code = 0,lwd = 3, lty = 2)
## ppois
barplot(dpois(unique(x)[1:2],lam),col = "grey",add = TRUE,border = "grey",axes = FALSE)
text(mean(b[1:2,1]),dpois(unique(x)[1],lam)/2,"ppois",cex = 2)
## redo dpois
points(b[,1],dpois(unique(x),lam),cex = 3,pch = 20)
dev.off()
