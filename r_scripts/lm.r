library(dplyr)
library(ggplot2)
library(magick)
library(gganimate)

d <- mtcars
fit <- lm(mpg ~ hp, data = d)
d$predicted <- predict(fit)   ## predicted values
d$residuals <- residuals(fit) ## residuals
coefs<-coef(lm(mpg ~ hp, data = mtcars))
x<-d$hp
move_line<-c(seq(-6,6,.5),seq(6,-6,-.5))
total_error<-length(length(move_line))
cnt<-0
for(i in move_line){
    cnt<-cnt+1
    predicted_y <- coefs[2]*x + coefs[1]+i
    error_y <- (predicted_y-d$mpg)^2
    total_error[cnt]<-sqrt(sum(error_y)/32)
}
move_line_sims<-rep(move_line,each=32)
total_error_sims<-rep(total_error,each=32)
sims<-rep(1:50,each=32)
d <- d %>% slice(rep(row_number(), 50))
d <- cbind(d,sims,move_line_sims,total_error_sims)

anim <- ggplot(d, aes(x = hp, y = mpg, frame=sims)) +
    geom_smooth(method = "lm", se = FALSE, color = "darkgrey",lty = 2) +  
    geom_abline(intercept = 30.09886+move_line_sims, slope = -0.06822828)+
    lims(x = c(0,400), y = c(-10,40))+
    geom_segment(aes(xend = hp, yend = predicted+move_line_sims, color="red"), alpha = .5) + 
    geom_point() +
    theme_classic()+
    theme(legend.position="none")+
    xlab("Explanatory variable")+ylab("Response variable")+
    transition_manual(frames=sims)+
    enter_fade() + 
    exit_fade()+
    ease_aes('sine-in-out')

anim_save("lm.gif",animate(anim,fps=5))
