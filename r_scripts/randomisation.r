## libraries
library(ggplot2)
library(dplyr)
library(magick)
library(gganimate)
## some packages only available via github
## devtools::install_github("thomasp85/transformr")
library(transformr)

study <- round(runif(10,80,100))
no_study <- round(runif(10,40,90))
study_df<-data.frame(student=seq(1:10),study,no_study)
mean_original<-data.frame(IV=c("studied","did not study"),
                          means=c(mean(study),mean(no_study)))
t_df <- data.frame(sims=rep(1,20),
                   IV=rep(c("studied","did not study"),each=10),
                   values=c(study,no_study),
                   rand_order=rep(c(0,1),each=10))
raw_df<-t_df
for(i in 2:10){
    new_index<-sample(1:20)
    t_df$values<-t_df$values[new_index]
    t_df$rand_order<-t_df$rand_order[new_index]
    t_df$sims<-rep(i,20)
    raw_df<-rbind(raw_df,t_df)
}
raw_df$rand_order<-as.factor(raw_df$rand_order)
rand_df<-aggregate(values~sims*IV,raw_df,mean)
names(rand_df)<-c("sims","IV","means")
rand_df$rand_order <- as.factor(1)
a <- ggplot(data = raw_df,aes(x=IV,y=values,color=rand_order), color = c("red","blue")) +
    geom_point(stat="identity",alpha=.5,size = 6) +
    geom_point(data=mean_original,aes(x = IV,y = means),
               stat="identity",shape=21,size = 6,color="black",fill="black") +
    geom_point(data=rand_df,aes(x=IV,y=means),stat="identity",
               shape=21,size=6,color="gold",fill="gold") +
    geom_text(data=rand_df,aes(x = IV,y=means,label = "Randomized mean"),stat="identity", color = "black",
              nudge_x = -0.3) +
    coord_cartesian(ylim=c(40, 100)) +
    ylab("Exam grade") +
    scale_color_manual(values = c("red","blue"),
                       labels = c("studied","did not study"),name = "Original data") +
    annotate("text",x = c(1.25,2.25), y = rev(mean_original$means), label = "Original mean") + 
    theme(legend.position="bottom",
          axis.title.x=element_blank(),
          panel.background = element_blank(),
          panel.grid.minor = element_blank(),
          panel.grid.major = element_blank(),
          panel.border = element_rect(colour='black', fill=NA)) +
    transition_states(
        sims,
        transition_length = 1,
        state_length = 2
    ) + enter_fade() +
    exit_shrink() +
    ease_aes('sine-in-out')

anim_save("randomisation.gif",animate(a,nframes=100,fps=5))
