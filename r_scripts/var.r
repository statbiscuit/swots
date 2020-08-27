library(animation)
x <- c(1,2,3,5,6,9)
ani.options(interval = 1,ani.height = 1000,ani.width = 1000)
saveGIF({
  for(i in 1:length(x)){
    plot(x,rep(0,length(x)), pch = 20,cex = 3, axes = FALSE, xlab = "", ylab = "")
    abline(h = 0)
    text(x = x, y = rep(0.1,length(x)), c(expression(x[1]),expression(x[2]),expression(x[3]),
                                                expression(x[4]),expression(x[5]),expression(x[6])),
         cex = 2)
    text(x = x, y = rep(-0.1,length(x)),x,cex = 2)
    arrows(mean(x),-0.75,mean(x),0,length = 0.2,lwd = 2)
    text(mean(x),-0.85,expression(paste(mu[x], "(central value)")),cex = 1.5)
    text(mean(x),-0.95,paste("=",bquote(.(round(mean(x),2)))),cex = 1.5)
    arrows(7,0.75,x[4:6],0.2,length = 0.2,lwd = 2,lty = c(2,1,1))
    text(7,0.9,"Possible values of X",cex = 1.5)
    ##legend("topleft",bty = "n", legend = expression(paste("Var(X) = E[(X -",mu[X],")",""^2,"]")),cex = 1.3)
    arrows(mean(x),-0.25,x[i],-0.25,length = 0.1,code = 3,lwd = 2)       
    text(mean(c(x[i],mean(x))),-0.3,bquote(x[.(i)] - mu[X]),cex = 2)
    text(mean(c(x[i],mean(x))),-0.4, paste("=",bquote(.(round(x[i] - mean(x),2)))),cex = 1.5)
    text(1.5,0.6,bquote((x[.(i)] - mu[X])^2),cex = 2)
    text(2.5,0.6, paste("=",bquote(.(round((x[i] - mean(x))^2,2)))),cex = 2)
  }}, movie.name = "var.gif"
)
