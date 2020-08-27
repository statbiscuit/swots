## application for STATS210 students
## aimed at teaching them how changing parameter values changes the shape of distributions

library(shiny)

# Define UI for application that draws a histogram
ui <- fluidPage(
   ## Sidebar with a slider input for number of bins 
   sidebarLayout(
      sidebarPanel(
        h3("Distribution"),
        selectInput("distribution","Choose a distribution",choices = c("Binomial","Geometric","Negative Binomial","Hypergeometric",
                                                                       "Poisson","Exponential","Uniform","Gamma","Beta","Normal")),
         conditionalPanel("input.distribution == 'Binomial'",
                          sliderInput("trials", "Number of trials:",min = 1, max = 500,value = 30),
                          sliderInput("probability_binom", "Probability of success:",min = 0, max = 1,value = 0.5)),
        conditionalPanel("input.distribution == 'Geometric'",
                         sliderInput("probability_geom", "Probability of success:",min = 0, max = 1,value = 0.5)),
        conditionalPanel("input.distribution == 'Negative Binomial'",
                         sliderInput("kth_success", "Kth Success:",min = 1, max = 50,value = 10),
                         sliderInput("probability_negbinom", "Probability of success:",min = 0, max = 1,value = 0.5)),
        conditionalPanel("input.distribution == 'Hypergeometric'",
                         sliderInput("N", "N:",min = 1, max = 100,value = 30),
                         sliderInput("M", "M:",min = 1, max = 100,value = 5),
                         sliderInput("n", "n:",min = 1, max = 100,value = 15)),
        conditionalPanel("input.distribution == 'Poisson'",
                         sliderInput("lambda_pois", "lambda:",min = 0.001, max = 150,value = 5,step = 0.001)),
        conditionalPanel("input.distribution == 'Exponential'",
                         sliderInput("lambda_expon", "lambda:",min = 0.001, max = 150,value = 5,step = 0.001)),
        conditionalPanel("input.distribution == 'Uniform'",
                         sliderInput("a", "a:",min = -10, max = 10,value = 0),
                         sliderInput("b", "b:",min = -10, max = 10,value = 1)),
        conditionalPanel("input.distribution == 'Gamma'",
                         sliderInput("k_gamma", "k:",min = 0, max = 100,value = 1),
                         sliderInput("lambda_gamma", "lambda:",min = 0, max = 100,value = 1)),
        conditionalPanel("input.distribution == 'Beta'",
                         sliderInput("alpha", "alpha:",min = 0, max = 500,value = 5),
                         sliderInput("beta", "beta:",min = 0, max = 500,value = 10)),
        conditionalPanel("input.distribution == 'Normal'",
                         sliderInput("mu", "mu:",min = -250, max = 250,value = 0),
                         sliderInput("sigma2", "sigma^2:",min = 0, max = 100,value = 1)),
        conditionalPanel("input.distribution == 'Normal' || input.distribution == 'Beta' || input.distribution == 'Gamma' || input.distribution == 'Exponential' || input.distribution == 'Uniform'",
                         sliderInput("bins","Number of bins to use in histogram", min = 1, max = 50, value = 10)),
        h3("CLT"),
        sliderInput("n_var_sum","How many iid random variables to sum",0,100,1,1),
        sliderInput("bins_clt","Number of bins to use in histogram", min = 1, max = 50, value = 20)
        ),
      
      mainPanel(
        h1("Distribution shape"),
        plotOutput("distribution_plot",height = 500),
        h1("Central Limit Theorem in action"),
        plotOutput("clt_plot",height = 500)
      )
   )
)

# Define server logic required to draw a histogram
server <- function(session,input, output) {
   ## distribution plot
   output$distribution_plot <- renderPlot({
     updateSliderInput(session,"b",min = input$a[1] + 1)
     updateSliderInput(session,"n",max = input$N[1])
     updateSliderInput(session,"M",max = input$N[1])
     n <- 10000
     if(input$distribution == "Binomial") x <- rbinom(n,size = input$trials,prob = input$probability_binom)
     if(input$distribution == "Geometric") x <- rgeom(n,prob = input$probability_geom)
     if(input$distribution == "Negative Binomial") x <- rnbinom(n,size = input$kth_success,prob = input$probability_negbinom)
     if(input$distribution == "Hypergeometric") x <- rhyper(n,m = input$M,n = input$N - input$M, k = input$n)
     if(input$distribution == "Poisson") x <- rpois(n,lambda = input$lambda_pois)
     if(input$distribution == "Exponential") x <- rexp(n, rate = input$lambda_expon)
     if(input$distribution == "Uniform") x <- runif(n,min = input$a, max = input$b)
     if(input$distribution == "Gamma") x <- rgamma(n,input$k_gamma, input$lambda_gamma)
     if(input$distribution == "Beta") x <- rbeta(n,input$alpha, input$beta)
     if(input$distribution == "Normal") x <- rnorm(n,mean = input$mu,sd = sqrt(input$sigma2))
     if(input$distribution %in% c("Binomial","Geometric","Negative Binomial","Hypergeometric","Poisson")){
      barplot(table(x), col = 'darkgray', border = 'white', xlab = "observations",main = "")
      }else{
        hist(x, col = 'darkgray', border = 'white', xlab = "observations",main = "",freq = FALSE,breaks = input$bins)
        }
   })
   ## CLT plot
   output$clt_plot <- renderPlot({
     validate(need(input$n_var_sum >= 1,""))
     updateSliderInput(session,"b",min = input$a[1] + 1)
     updateSliderInput(session,"n",max = input$N[1])
     updateSliderInput(session,"M",max = input$N[1])
     n <- 10000
     if(input$distribution == "Binomial") x <- rowSums(replicate(input$n_var_sum,rbinom(n,size = input$trials,prob = input$probability_binom)))
     if(input$distribution == "Geometric") x <- rowSums(replicate(input$n_var_sum,rgeom(n,prob = input$probability_geom)))
     if(input$distribution == "Negative Binomial") x <- rowSums(replicate(input$n_var_sum,rnbinom(n,size = input$kth_success,prob = input$probability_negbinom)))
     if(input$distribution == "Hypergeometric") x <- rowSums(replicate(input$n_var_sum,rhyper(n,m = input$M,n = input$N - input$M, k = input$n)))
     if(input$distribution == "Poisson") x <- rowSums(replicate(input$n_var_sum,rpois(n,lambda = input$lambda_pois)))
     if(input$distribution == "Exponential") x <- rowSums(replicate(input$n_var_sum,rexp(n, rate = input$lambda_expon)))
     if(input$distribution == "Uniform") x <- rowSums(replicate(input$n_var_sum,runif(n,min = input$a, max = input$b)))
     if(input$distribution == "Gamma") x <- rowSums(replicate(input$n_var_sum,rgamma(n,input$k_gamma, input$lambda_gamma)))
     if(input$distribution == "Beta") x <- rowSums(replicate(input$n_var_sum,rbeta(n,input$alpha, input$beta)))
     if(input$distribution == "Normal") x <- rowSums(replicate(input$n_var_sum,rnorm(n,mean = input$mu,sd = sqrt(input$sigma2))))
     
     hist(x, col = 'darkgray', border = 'white', xlab = "observations",main = "",freq = FALSE,breaks = input$bins_clt)
   })
   
}

# Run the application 
shinyApp(ui = ui, server = server)

