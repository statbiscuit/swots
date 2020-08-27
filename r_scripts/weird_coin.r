library(png)
require(animation)
pngs <- list.files("figs/","coin",full = TRUE)
imgs <- lapply(pngs,png::readPNG)

ani.options(interval = 0.5,ani.width = 1800, ani.height = 900)

saveGIF({
    layout(matrix(c(0,0,2,2,2,3,3,3,1,1,2,2,2,3,3,3,1,1,2,2,2,3,3,3,0,0,2,2,2,3,3,3),nrow = 4,byrow = TRUE))
    par(xpd = TRUE)
    for(i in 1:2){
        plot(1,type = "n", axes = FALSE,xlim = c(-0.6,0.6),xlab ="",ylim = c(-0.6,0.6),ylab = "")
        rasterImage(imgs[[i]],-0.5,-0.5,0.5,0.5)
        text(0,0.6,"Throw a coin 10 times",cex = 4)
        text(0,-0.6,"Is it fair?",cex = 4)
        num <- seq(0,40,4)
        plot(1,type = "n", axes = FALSE,xlim = c(-1,42),xlab ="",ylim = c(-0.1,2.2), ylab = "")
        ## sleeping
        for(i in num[2:11]){ rasterImage(imgs[[1]],i - 2,0.1,i + 2,0.3)}
        for(i in num[3:11]){ rasterImage(imgs[[1]],i - 2,0.3,i + 2,0.5)}
        for(i in num[4:11]){ rasterImage(imgs[[1]],i - 2,0.5,i + 2,0.7)}
        for(i in num[5:11]){ rasterImage(imgs[[1]],i - 2,0.7,i + 2,0.9)}
        for(i in num[6:11]){ rasterImage(imgs[[1]],i - 2,0.9,i + 2,1.1)}
        for(i in num[7:11]){ rasterImage(imgs[[1]],i - 2,1.1,i + 2,1.3)}
        for(i in num[8:11]){ rasterImage(imgs[[1]],i - 2,1.3,i + 2,1.5)}
        for(i in num[9:11]){ rasterImage(imgs[[1]],i - 2,1.5,i + 2,1.7)}
        for(i in num[10:11]){ rasterImage(imgs[[1]],i - 2,1.7,i + 2,1.9)}
        for(i in num[11]){ rasterImage(imgs[[1]],i - 2,1.9,i + 2,2.1)}
        mtext(paste(0:10,"\n sleeping \n cats"),line = 0,side = 1, at = num, cex = 0.9)
        ## behind
        for(i in num[1:10]){ rasterImage(imgs[[2]],i - 2,1.9,i + 2,2.1)}
        for(i in num[1:9]){ rasterImage(imgs[[2]],i - 2,1.7,i + 2,1.9)}
        for(i in num[1:8]){ rasterImage(imgs[[2]],i - 2,1.5,i + 2,1.7)}
        for(i in num[1:7]){ rasterImage(imgs[[2]],i - 2,1.3,i + 2,1.5)}
        for(i in num[1:6]){ rasterImage(imgs[[2]],i - 2,1.1,i + 2,1.3)}
        for(i in num[1:5]){ rasterImage(imgs[[2]],i - 2,0.9,i + 2,1.1)}
        for(i in num[1:4]){ rasterImage(imgs[[2]],i - 2,0.7,i + 2,0.9)}
        for(i in num[1:3]){ rasterImage(imgs[[2]],i - 2,0.5,i + 2,0.7)}
        for(i in num[1:2]){ rasterImage(imgs[[2]],i - 2,0.3,i + 2,0.5)}
        for(i in num[1]){ rasterImage(imgs[[2]],i - 2,0.1,i + 2,0.3)}
        mtext(paste(10:0,"\n teasing \n cats"),line = 0,side = 3, at = num, cex = 0.9)
        ## boxes
        rect(xleft = c(-2,38),ybottom = 0.1,xright = c(2,42),ytop = 2.1,border = "red",lwd = 3)
        rect(xleft = c(2.1,34),ybottom = 0.1,xright = c(6,37.9),ytop = 2.1,border = "red",lwd = 2)
        rect(xleft = c(6.1,34),ybottom = 0.1,xright = c(10,30),ytop = 2.1,border = "red",lwd = 1)
        mtext("more \n weird",line = -4,side = 3,at = num[c(1,11)],cex = 1,col = "red")
        mtext("kind of \n weird",line = -4,side = 3,at = num[c(2,10)],cex = 0.8,col = "red")
        mtext("less \n weird",line = -4,side = 3,at = num[c(3,9)],cex = 0.6,col = "red")
        ## line
        arrows(-2,-0.01,42,-0.01,length = 0.1,code = 3,lwd = 2)
        text(20,0.05,"expected",cex = 1.7)
        text(c(8,32),0.05,"weirder",cex = 1.7)
        ## probabilities
        ps <- dbinom(0:10,10,0.5)
        par(xpd = TRUE,mar = c(13.1, 4.1, 4.1, 2.1))
        bar <- barplot(ps,axes = FALSE,border = NA,ylab = "Probability of getting x cats",cex.lab = 1.5)
        barplot(c(ps[1],0,0,0,0,0,0,0,0,0,ps[11]),axes = FALSE,border = c("red",NA,NA,NA,NA,NA,NA,NA,NA,NA,"red"),
                col = NA,lwd = 3,add = TRUE)
        barplot(c(0,ps[2],0,0,0,0,0,0,0,ps[10],0),axes = FALSE,border = c(NA,"red",NA,NA,NA,NA,NA,NA,NA,"red",NA),
                col = NA,lwd = 2,add = TRUE)
        barplot(c(0,0,ps[3],0,0,0,0,0,ps[9],0,0),axes = FALSE,border = c(NA,NA,"red",NA,NA,NA,NA,NA,"red",NA,NA),
                col = NA,lwd = 1,add = TRUE)
        ## line
        arrows(0,-0.01,13,-0.01,length = 0.1,code = 3,lwd = 2)
        text(7.1,-0.007,"expected",cex = 1.7)
        text(c(3.1,10.7),-0.007,"weirder",cex = 1.7)
        ## text
        text(bar[c(1,11)],0.01,"more \n weird",cex = 1.9,col = "red")
        text(bar[c(2,10)],0.02,"kind of \n weird",cex = 1.7,col = "red")
        text(bar[c(3,9)],0.05,"less \n weird",cex = 1.5,col = "red")
        ## axis
        axis(2,las = 2,at = seq(0,0.25,0.05),cex.axis = 1.3,line = -1)
        mtext(paste(0:10,"\n teasing \n or \n sleeping \n cats"),line = 9,side = 1, at = bar, cex = 0.9)
        par(mar = c(5.1, 4.1, 4.1, 2.1))
    }
},movie.name = "binomial_cat.gif")

