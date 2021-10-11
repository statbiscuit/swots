## global.R
source("global.R")
load("mod_pts.RData")
ui <- dashboardPage(
    ## No header
    dashboardHeader(disable = TRUE),
    ## Sidebar
    dashboardSidebar(
        sidebarMenu(id = "sidebar",
                    menuItem("What is aRt", tabName = "intro", icon = icon("th")),
                    menuItem("Painting noise", tabName = "plotting", icon = icon("th")),
                    menuItem("Modelling aRt", tabName = "modelling", icon = icon("th"))
                    )
    ),
    ## Tab pages
    dashboardBody(
        tabItems(
            ## Introducing aRt Tab
            tabItem(tabName = "intro",
                    h1("Introducing aRt"),
                    br(),
                    br(),
                    fluidRow(
                        column(6, h3("Generative Art in R, or aRt, is basically what it sounds like: making art using R.
                               If you want to learn more checkout these blogs and websites:",
                               tags$a(href = "https://towardsdatascience.com/getting-started-with-generative-art-in-r-3bc50067d34b", "Getting Started with Generative Art in R"),",",
                               tags$a(href = "https://generative.substack.com/p/generative-art-and-r", "Generative Art and R"), ",",
                               tags$a(href = "https://flowingdata.com/2021/08/18/generative-art-with-r/", "Generative art with R"), ",",
                               tags$a(href = "https://www.data-imaginist.com/art", "Generative Art by Thomas Lin Pedersen"), ",",
                               tags$a(href = "https://art.djnavarro.net/", "art by DANIELLE NAVARRO"), ",",
                               tags$a(href = "https://paulvanderlaken.com/2020/05/02/generative-art-computer-design-painting/", "Generative art: Let your computer design you a painting"), ",",
                               tags$a(href = "https://fronkonstin.com/2019/01/10/rcpp-camaron-de-la-isla-and-the-beauty-of-maths/","Rcpp, Camarón de la Isla and the Beauty of Maths"), ".", "\n", 
                               "aRt is definately beautiful, BUT, does it help as an introduction to linear modelling...")),
                        column(6, tags$img(src = "https://pbs.twimg.com/media/E_vTUhlWUAUxCZw?format=jpg&name=small",
                             width = "100%"),
                    tags$h3("Artwork by",
                            tags$a(href = "https://djnavarro.net/", "Danielle Navarro")))
                    ),
                    ),
            ## Intro to "painting" Tab
            tabItem(tabName = "plotting",
                    fluidRow(
                        class = "panel panel-heading",
                        h3("aRtified noise"),
                        hr(),
                        column(5,  plotOutput("image_plot")),
                        column(1, br(), br(), br(), br(),br(), br(), br(), br(), br(), icon("arrow-right","fa-3x")),
                        column(5, plotOutput("image_plot_aRt")),
                        column(3, sliderInput("time", "Time:", 8, min = 1, max = 10), sliderInput("step", "Step:", 1, min = 0, max = 5, step = 0.1)),
                        column(3, br(), br(), br(), radioButtons("field", "Pattern",
                                               choices = c("1", "2", "3", "4"), inline = TRUE)),
                        column(3, br(), br(), br(), radioButtons("map_alpha", "Transparency type",
                                               choices = c("1", "2", "3", "4"), inline = TRUE)),
                        column(3, br(), br(), br(), radioButtons("colour", "Colour Scheme",
                                               choices = c("1", "2", "3", "4"), inline = TRUE)),
                        
                        br()
                       
                    ),
                    hr(),
                    tags$foot("Navarro (2021, Sept. 7). Notes from a data witch: Art, jasmines, and the water colours. Retrieved from", tags$a(href = "https://blog.djnavarro.net/water-colours", "https://blog.djnavarro.net/water-colours"))
                    ),
            ## Modelling Tab
            tabItem(tabName = "modelling",
                    fluidRow(
                        class = "panel panel-heading",
                        h3("Image to recreate"),
                        plotOutput("image_plot_mod"),
                        hr(),
                        h3("Model construction"),
                        column(4, numericInput("intercept", "Intercept",
                                               value = 1, min = -10, max = 10), 
                               plotOutput("image_plot_beta0")),
                        column(4, numericInput("beta1", "Coefficient estimate",
                                               value = 0.5, min = -10, max = 10),
                               plotOutput("image_plot_size")),
                        column(4, numericInput("beta2", "Coefficient estimate",
                                               value = 0.5, min = 0, max = 10),
                               plotOutput("image_plot_col")),
                        hr(),
                        h3("Fitted model"),
                        column(6, plotOutput("fitted_image")),
                        column(6, plotOutput("gof"))
                    )
                    )
        )
    )
)

## Server functions and output
server <- function(input, output, session) {
    orig <- ggplot_themed(points_time0) + 
        geom_point(size = .5)
    output$image_plot <- renderPlot(orig)
    ## aRt stuff
    field <- reactive({
        if(input$field == "1"){
            function(points, frequency = .1, octaves = 1) {
                ambient::curl_noise(
                             generator = ambient::fracture,
                             fractal = ambient::billow,
                             noise = ambient::gen_simplex,
                             x = points$x,
                             y = points$y,
                             frequency = frequency,
                             octaves = octaves,
                             seed = 1
                         )
            }
        }else{
            if(input$field == "2"){
                function(points, frequency = .1, octaves = 1) {
                    ambient::curl_noise(
                                 generator = ambient::fracture,
                                 fractal = ambient::fbm,
                                 noise = ambient::gen_perlin,
                                 x = points$x,
                                 y = points$y,
                                 frequency = frequency,
                                 octaves = octaves,
                                 seed = 1
                             )
                }
            }else{
                if(input$field == "3"){
                    function(points, frequency = .1, octaves = 10) {
                        ambient::curl_noise(
                                     generator = ambient::fracture,
                                     fractal = ambient::billow,
                                     noise = ambient::gen_waves,
                                     x = points$x,
                                     y = points$y,
                                     frequency = frequency,
                                     octaves = octaves,
                                     seed = 1
                                 )
                    }
                }else{
                    if(input$field == "4"){
                        function(points, frequency = .1, octaves = 10) {
                            ambient::curl_noise(
                                         generator = ambient::fracture,
                                         fractal = ambient::ridged,
                                         noise = ambient::gen_perlin,
                                         x = points$x,
                                         y = points$y,
                                         frequency = frequency,
                                         octaves = octaves,
                                         seed = 1
                                     )
                        }
                    }
                }
            }
        }
    })
    shift <- reactive({
        function(points, amount, ...) {
            vectors <- field()(points, ...)
            points <- points %>%
                mutate(
                    x = x + vectors$x * amount,
                    y = y + vectors$y * amount,
                    time = time + 1,
                    id = id
                )
            return(points)
        }
    })
    iterate <- reactive({
        function(pts, time, step, ...) {
            bind_rows(accumulate(
                .x = rep(step, time), 
                .f = shift(), 
                .init = pts,
                ...
            ))
        }
    })

    map_alpha <- reactive({
        if(input$map_alpha == "1"){
            function(x) {
                ambient::normalise(-x, to = c(0, 2))
            }
        }else{
            if(input$map_alpha == "2"){
                function(x) {
                    ambient::normalise(x^2, to = c(0, 1))
                }
            }else{
                if(input$map_alpha == "3"){
                    function(x) {
                        ambient::normalise(sqrt(x), to = c(0, .5))
                    }
                }else{
                    if(input$map_alpha == "4"){
                        function(x) {
                            ambient::normalise(1/x, to = c(0, .5))
                        }
                    }
                }
            }
        }
    })
    colour_scheme <- reactive({
        if(input$colour == "1"){
            function(n){
                grDevices::rainbow(n)
            }
        }else{
            if(input$colour == "2"){
                function(n){
                    scico::scico(n)
                }
            }else{
                if(input$colour == "3"){
                    function(n) {
                        viridis::viridis(n)
                    }
                }else{
                    if(input$colour == "4"){
                        function(n) {
                            palet <- palette_manual("#cbced0", "#84838b", "#505050", "#a0a0a0")
                            palet(n)
                        }
                    }
                }
            }
        }
    })
    fill <- reactive({
        if(input$colour == "1" ){
            "black"
        }else{
            if(input$colour == "2"){
                "#fffff2" ## off white
            }else{
                if(input$colour == "3"){
                    "white"
                }else{
                    if(input$colour == "4"){
                        "#4f3a52"  ## dark lilac
                    }
                }
            }
        }
    })
    
    pts <- reactive({
        points_time0 %>% 
            iterate()(time = input$time, step = input$step)
    })
    img <- reactive({
        pts() %>% 
            ggplot_themed() +  
            geom_point(
                mapping = aes(
                    size = map_size(time), 
                    alpha = map_alpha()(time),
                    colour = colour_scheme()(length(time)),
                    ),
                show.legend = FALSE
            ) +
            theme(panel.background = element_rect(fill = fill())) +
            scale_x_continuous(limits = c(1, 49), expand = c(0, 0)) +
            scale_y_continuous(limits = c(1, 29), expand = c(0, 0))
    })
    output$image_plot_aRt <- renderPlot(img())
    ## Modelling plot
    img_mod <- 
        mod_pts %>% 
        ggplot_themed() +  
        geom_point(
            mapping = aes(
                size = size, 
                alpha = alph,
                colour = col,
                ),
            show.legend = FALSE
        ) +
        theme(panel.background = element_rect(fill = "#fffff2"))
    output$image_plot_mod <- renderPlot(img_mod)
    ## lm parts
    beta0 <- reactive({
        inv_logit <- function(x) 1 / (1 + exp(-x))
        background <- inv_logit(input$intercept) * col2rgb("#fffff2")/255
        fill <- rgb(background[1], background[2], background[3])
        mod_pts %>% 
            ggplot_themed() +  
            theme(panel.background = element_rect(fill = fill))})
    output$image_plot_beta0 <- renderPlot({
        validate(
            need(input$intercept, 'Please input a numeric value')
        )
        beta0()
        })
    size <- reactive({mod_pts %>% 
                          ggplot_themed() +  
                          geom_point(
                              mapping = aes(
                                  size = input$beta1*0.25*size + rnorm(nrow(mod_pts))
                              ),
                              show.legend = FALSE
                          )})
    output$image_plot_size <- renderPlot({
        validate(
            need(input$beta1, 'Please input a numeric value')
        )
        size()
        })
    col <- reactive({
        inv_logit <- function(x) 1 / (1 + exp(-x))
        cols <- inv_logit(input$beta2) * col2rgb(mod_pts$col)/255
        mod_pts %>% 
            mutate(colr = rgb(cols[1, ], cols[2, ], cols[3, ])) %>%
            ggplot_themed() +  
            geom_point(
                mapping = aes(
                    col = colr,
                    alpha = alph,
                    ),
                show.legend = FALSE
            )
    })
    output$image_plot_col <- renderPlot({
        validate(
            need(input$beta2, 'Please input a numeric value')
        )
        col()
        })
    fitted <- reactive({
        inv_logit <- function(x) 1 / (1 + exp(-x))
        background <- inv_logit(input$intercept) * col2rgb("#fffff2")/255
        fill <- rgb(background[1], background[2], background[3])
        cols <- inv_logit(input$beta2) * col2rgb(mod_pts$col)/255
        mod_pts %>% 
            mutate(colr = rgb(cols[1, ], cols[2, ], cols[3, ])) %>%
            ggplot_themed() +  
            geom_point(
                mapping = aes(
                    size = input$beta1*0.25*size ,
                    col = colr,
                    alpha = alph
                ),
                show.legend = FALSE
            ) +  
            theme(panel.background = element_rect(fill = fill))
    })
    output$fitted_image <- renderPlot({
        validate(
            need(input$intercept, 'Please input a numeric value for the intercept'),
            need(input$beta1, 'Please input a numeric value for the coefficient'),
            need(input$beta2, 'Please input a numeric value for the coefficient')
        )
        fitted()
        })
    ftd <- reactive({
        rl <- ggplot_build(img_mod)$data[[1]]
        real <- 10 + 4*rl$size + 12 *col2rgb(rl$colour)[, 1]/255 + 12 *col2rgb(rl$colour)[, 2]/255 +
             12 *col2rgb(rl$colour)[, 3]/255
        modelled <- input$intercept + input$beta1*rl$size + input$beta2 *col2rgb(rl$colour)[, 1]/255 + 
            input$beta2 *col2rgb(rl$colour)[, 2]/255 + input$beta2 *col2rgb(rl$colour)[, 3]/255
        data.frame(fitted = modelled + rnorm(length(real), sd = 0.2),
                   true = real + rnorm(length(real), sd = 1))
    })
    gof <- reactive({
        my.formula <- y ~ 1 + x
        ggplot(ftd(), aes(x = fitted,
                          y = true)) +
            geom_point() +
            geom_smooth(method = "lm", se = FALSE, col = "grey") +
            theme_classic() + xlab("Fitted") + ylab("Observed") +
            ggtitle("Fitted vs Observed values") +
            stat_poly_eq(formula = my.formula, 
                aes(label = ..rr.label..), 
                parse = TRUE) +
            theme(aspect.ratio = 1)
    })
    output$gof <- renderPlot({
        validate(
            need(input$intercept, 'Please input a numeric value for the intercept'),
            need(input$beta1, 'Please input a numeric value for the coefficient'),
            need(input$beta2, 'Please input a numeric value for the coefficient')
        )
        gof()
        })
}

shinyApp(ui, server)
