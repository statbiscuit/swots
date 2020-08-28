## GIFs inspired by https://crumplab.github.io/statistics/gifs.html
## libraries
library(ggplot2)
library(dplyr)
library(magick)
library(gganimate)
## some packages only available via github
## devtools::install_github("thomasp85/transformr")
library(transformr)

## simulate data
set.seed(3214)
A <- rnorm(100,45,10)
B <- rnorm(100,50,10)
C <- rnorm(100,40,10)
DV <- c(A,B,C)
Transport <- rep(rep(c("Car","Bus","Train"),each=10),10)
sims <- rep(1:10,each=30)
df<-data.frame(sims,Transport,DV)
means_df <- df %>%
    group_by(sims,Transport) %>%
    summarize(means=mean(DV),
              sem = sd(DV)/sqrt(length(DV)))
stats_df <- df %>%
    group_by(sims) %>%
    summarize(Fs = summary(aov(DV~Transport))[[1]][[4]][1])
a <- ggplot(means_df, aes(x=Transport,y=means, fill=Transport)) +
    geom_bar(stat="identity") +  scale_fill_brewer(palette = "Dark2") +
    geom_point(data=df,aes(x=Transport, y=DV), alpha=.25) +
    geom_errorbar(aes(ymin=means-sem, ymax=means+sem),width=.2)  +
    theme(axis.title.x=element_blank(),
          panel.background = element_blank(),
          panel.grid.minor = element_blank(),
          panel.grid.major = element_blank(),
          panel.border = element_rect(colour='black', fill=NA)) + ylab("Time to work (mins)") +
    transition_states(
        states=sims,
        transition_length = 2,
        state_length = 1) +
    geom_text(aes(0.5, 78,label = paste("Sample mean Bus:", format(round(means[rep(seq(1,30,3),each = 3)], 3),
                                                                   nsmall = 2))),
              size = 4, hjust = 0, color = "black") +
    geom_text(aes(0.5, 74,label = paste("Sample mean Car:", format(round(means[rep(seq(2,30,3),each = 3)], 3),
                                                                   nsmall = 2))),
              size = 4, hjust = 0, color = "black") +
    geom_text(aes(0.5, 70,label = paste("Sample mean Train:", format(round(means[sims*3], 3),
                                                                     nsmall = 2))),
              size = 4, hjust = 0, color = "black") + enter_fade() + 
    exit_shrink() +
    ease_aes('sine-in-out')
## for p-value shading
crit_df <- as.data.frame(apply(stats_df,2,rep,each = 100))
crit_df$Fs <- c(sapply(stats_df$Fs, function(x) seq(x,6, length.out = 100))) ## xvect of sequences
crit_df$y <- df(crit_df$Fs,df1 = 2,df2 = 27) ## corresponding F vals
b <- ggplot(stats_df,aes(x = Fs,y = y)) +
    geom_vline(aes(xintercept = Fs)) +
    geom_line(data=data.frame(x = seq(0,6,.1),
                              y  = df(seq(0,6,.1),df1=2,df2=27)),
              aes(x=x,y=y)) +
    theme(panel.background = element_blank(),
          panel.grid.minor = element_blank(),
          panel.grid.major = element_blank(),
          panel.border = element_rect(colour='black', fill=NA),
          legend.position = "none") +
    ylab("density") +
    xlab("F-statistic") +
    geom_area(data = crit_df,mapping = aes(x = Fs,y = y),fill = "grey",alpha = 0.3) +
    transition_states(sims,transition_length = 0,
                      state_length = 1) + enter_fade() +
    geom_text(aes(4, 1,label = paste("F-statistic:", format(round(Fs, 2), nsmall = 2))),
              size = 4, hjust = 0, color = "black")  +
    geom_text(aes(4, 0.95,label = paste("p-value:", format(round(pf(Fs,2,27,lower.tail = FALSE), 2), nsmall = 2))),
              size = 4, hjust = 0, color = "grey")  +
    exit_shrink() +
    ease_aes('sine-in-out')
## individual gifs
a_gif <- animate(a,width=420,height=420)
anim_save("a.gif")
b_gif <-animate(b,width=420,height=420)
anim_save("b.gif")

a_mgif<-image_read("a.gif")
b_mgif<-image_read("b.gif")

## combine
new_gif <- image_append(c(a_mgif[1], b_mgif[1]))
for(i in 2:100){
    combined <- image_append(c(a_mgif[i], b_mgif[i]))
    new_gif <- c(new_gif,combined)
}
anim_save("anova.gif",new_gif)
