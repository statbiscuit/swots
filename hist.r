library(animation)
n <- seq(100,50000,length.out = 30)
ntrials <- 190; p <- 0.6
x <- 80:140
par(mar = c(4.1,5.1,2,4.1))
ani.options(interval = 0.5)
saveGIF({
  for(i in 1:length(n)){
    sample <- rbinom(n[i],ntrials,p) 
    denst <- dbinom(x,ntrials,p)
    f <- hist(sample,xlab = "x",ylab = "frequeny of x", main = "",freq = FALSE,
     yaxt = "n",col = "lightgrey",border = "lightgrey",
     xaxt = "n",ylim = range(denst),xlim = range(x),breaks = seq(0,max(sample)))

    lines(x,denst,lwd = 2)
axis(1,line = 1) 
a <- axis(4)
mtext(4,line = 3,text = "P(X = x) for X ~ Bin(190,0.6)")
axis(2, at = seq(0,max(f$density),length.out = 7), labels = round(seq(0,max(f$counts),length.out = 7),0) )
title(main = paste("n = ",format(n[i],scientific = 999,digits = 0),sep = ""))
  }
},movie.name = "hist.gif")
     
