## devtools::install_github("tidyverse/googlesheets4")
library(googlesheets4)
library(ggplot2)
library(emoGG)
require(gridExtra)
library(animation)

## 'true' data
set.seed(987)
data <- data.frame(weight = rnorm(10,2,0.5))
data$egg <- 20*data$weight + rnorm(10, 0, 10)

## original plot
## p <- ggplot(data, aes(x = egg, y = weight)) +
##    # annotation_custom(g, -Inf, Inf, -Inf, Inf)  +
##     geom_point() +
##     xlab("weight of egg (g)") + ylab("weight of chicken (kg)") +
##     ylim(c(0,3)) + xlim(c(0,70)) + geom_emoji(emoji = "1f95a") +
##     theme(axis.line=element_blank(),
##           axis.line.x = element_line(color="black", size = 2),
##           axis.line.y = element_line(color="black", size = 2),
##           legend.position="none",
##           panel.background=element_blank(),
##           panel.border=element_blank(),
##           panel.grid.major=element_blank(),
##           panel.grid.minor=element_blank(),
##           plot.background=element_blank(),
##           axis.title.y = element_text(size = rel(1)),
##           axis.title.x = element_text(size = rel(1)),
##           text = element_text(size=20))
## png("egg_lm.png",height = 500, width = 500)
## p
## dev.off()


## read in coords from google sheet
url <- "https://docs.google.com/spreadsheets/d/1vn7oGtw06KJazYx-F2nReFvoeqONrskNehGkJpeugXw/edit?usp=sharing"
sheets_auth(email = "cmjonestodd@gmail.com") ## my google sheets auth ****SET YOUR OWN*****
dat.all <- as.data.frame(read_sheet(url,col_names = FALSE))
names(dat.all) <- c("x1","y1","x2","y2")
dat.all$slope <- ((500/60)*(dat.all[,2]-dat.all[,4]))/((500/3)*(dat.all[,3] - dat.all[,1]))
## calculating slope from imported pixel start and end positions from mousedown and mouse up
dat.all <- unique(dat.all) ## remove duplicates
dat.all <- na.omit(dat.all) ## remove NA slopes



## grid over plotting area same length as # pixels in canvas y doesn't match up no idea
grd <- data.frame(x = seq(from = 0, to = 70, length.out = 500), 
                  y = seq(from = 3, to = 0, length.out = 500))

locs.all <- data.frame(x1 = grd$x[dat.all[,1]],x2 = grd$x[dat.all[,3]],
                       y2 = grd$y[dat.all[,2]],y1 = grd$y[dat.all[,4]])
locs.all$transition <- 1:nrow(locs.all)

## gif

ani.options(ani.width = 1000,ani.height = 500)                                                 
saveGIF({
    for(i in 1:nrow(dat.all)){
        locs <- locs.all[1:i,]
        l <- ggplot(data, aes(x = egg, y = weight)) +
            geom_point() +
            xlab("weight of egg (g)") + ylab("weight of chicken (kg)") +
            ylim(c(0,3)) + xlim(c(0,70)) + geom_emoji(emoji = "1f95a") +
            theme(axis.line=element_blank(),
                  axis.line.x = element_line(color="black", size = 2),
                  axis.line.y = element_line(color="black", size = 2),
                  legend.position="none",
                  panel.background=element_blank(),
                  panel.border=element_blank(),
                  panel.grid.major=element_blank(),
                  panel.grid.minor=element_blank(),
                  plot.background=element_blank(),
                  axis.title.y = element_text(size = rel(1)),
                  axis.title.x = element_text(size = rel(1)),
                  text = element_text(size=20)) +
            stat_summary(fun.data= mean_cl_normal) + 
            geom_smooth(method='lm', se = FALSE,color = "black") +
            annotate('segment',x = locs$x2, y = locs$y1, xend = locs$x1, yend = locs$y2,color = "grey",size = 1.5,alpha = 0.5)
        ## remember to transpose x2 (as x) and x1 (as xend) due to layout of canvas
        dat <- dat.all[1:i,]
        h <- ggplot(dat,aes(x = slope)) + geom_histogram() +
            xlab("estimated slope from app") + ylab("count") +
            theme(axis.line=element_blank(),
                  axis.line.x = element_line(color="black", size = 2),
                  axis.line.y = element_line(color="black", size = 2),
                  legend.position="none",
                  panel.background=element_blank(),
                  panel.border=element_blank(),
                  panel.grid.major=element_blank(),
                  panel.grid.minor=element_blank(),
                  plot.background=element_blank(),
                  axis.title.y = element_text(size = rel(1)),
                  axis.title.x = element_text(size = rel(1)),
                  text = element_text(size=20))  +
            xlim(range(dat.all$slope,na.rm = TRUE) + c(-1,1)) + ## keep xlim to same limits of est slopes
            ylim(c(0,max(table(cut(dat.all$slope,10))))) +
            annotate('segment',x = 1/20, y = 0, xend = 1/20,
                     yend = 10,color = "grey",size = 1.5,alpha = 0.7) +
            annotate('text',x = 0.5, y = 10, label = "True slope = 0.05",size = 5) +
            annotate('text',x = 0.75, y = 7.5,label = paste("Est. slopes mean = ",round(mean(dat$slope,na.rm = TRUE),2)),size = 5)
        ## plot side by side
        grid.arrange(l,h, ncol=2)
    }
},movie.name = "lm_demo.gif")


