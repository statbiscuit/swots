## single file shiny dashboard app.R for palmer penguin ##
library(shiny)
library(shinydashboard)
library(palmerpenguins) ## data
library(htmlwidgets)
library(sortable)
library(magrittr) ## drag and drop things
library(ggplot2)
library(tidyverse) ## plotting and "tidy" manipulation
library(equatiomatic) ## "text" equation
library(DT) ## fancy data tables

colnames_to_tags <- function(df){
    lapply(
        colnames(df),
        function(co) {
            tag(
                "p",
                list(
                    class = class(df[, co]),
                    tags$span(class = "glyphicon glyphicon-move"),
                    tags$strong(co)
                )
            )
        }
    )
}

ui <- dashboardPage(
    ## No header
    dashboardHeader(disable = TRUE),
    ## Sidebar
    dashboardSidebar(
        sidebarMenu(id = "sidebar",
                    menuItem("Meet the Palmer penguins", tabName = "intro", icon = icon("th")),
                    menuItem("Plotting", tabName = "plotting", icon = icon("th")),
                    menuItem("Modelling", tabName = "modelling", icon = icon("th"))
                    )
    ),
    ## Tab pages
    dashboardBody(
        tabItems(
            ## Introducing the data Tab
            tabItem(tabName = "intro",
                    h1("Introducing the", tags$a(href = "https://github.com/allisonhorst/palmerpenguins","Palmer penguins"),
                       "dataset"),
                    tags$img(src = "https://raw.githubusercontent.com/allisonhorst/palmerpenguins/master/man/figures/lter_penguins.png", width = "70%"),
                    tags$h3("Artwork by",tags$a(href = "https://github.com/allisonhorst/", "@allison_horst")),
                    DTOutput('palmer_table'),
                    hr(),
                    tags$foot("Horst AM, Hill AP, Gorman KB (2020). palmerpenguins: Palmer Archipelago (Antarctica) penguin data. R package version 0.1.0. https://allisonhorst.github.io/palmerpenguins/. doi: 10.5281/zenodo.3960218.")
                    ),
            ## Plotting Tab
            tabItem(tabName = "plotting",
                    fluidRow(
                        class = "panel panel-heading",
                        div(
                            class = "panel-heading",
                            h3("Drag variables to plot data")
                        ),
                        fluidRow(
                            class = "panel-body",
                            ## all colnames variables to choose from
                            column(
                                width = 3,
                                tags$div(
                                         class = "panel panel-default",
                                         tags$div(class = "panel-heading", "Variables"),
                                         tags$div(
                                                  class = "panel-body",
                                                  id = "sort1",
                                                  colnames_to_tags(as.data.frame(penguins))
                                              )
                                     )
                            ),
                            column(
                                width = 3,
                                ## choose y-axis (response)
                                tags$div(
                                         class = "panel panel-default",
                                         tags$div(
                                                  class = "panel-heading",
                                                  tags$span(class = "glyphicon glyphicon-stats"),
                                                  "Y-axis (drag here)"
                                              ),
                                         tags$div(
                                                  class = "panel-body",
                                                  id = "sort3"
                                              )
                                     ),
                                ## choose x-axis (covariate)
                                tags$div(
                                         class = "panel panel-default",
                                         tags$div(
                                                  class = "panel-heading",
                                                  tags$span(class = "glyphicon glyphicon-stats"),
                                                  "X-axis (drag here)"
                                              ),
                                         tags$div(
                                                  class = "panel-body",
                                                  id = "sort2"
                                              )
                                     ),
                                ## choose group colour (covariate)
                                tags$div(
                                         class = "panel panel-default",
                                         tags$div(
                                                  class = "panel-heading",
                                                  tags$span(class = "glyphicon glyphicon-stats"),
                                                  "Group by (drag here)"
                                              ),
                                         tags$div(
                                                  class = "panel-body",
                                                  id = "sort4"
                                              )
                                     ),
                                ## choose group split/facet (covariate)
                                tags$div(
                                         class = "panel panel-default",
                                         tags$div(
                                                  class = "panel-heading",
                                                  tags$span(class = "glyphicon glyphicon-stats"),
                                                  "Split by (drag here)"
                                              ),
                                         tags$div(
                                                  class = "panel-body",
                                                  id = "sort5"
                                              )
                                     )
                            ),
                            ## simple static print out of ggplot code used fot plot
                            column(width = 6,
                                   div(
                                       class = "panel-heading",
                                       h3("R code for plot")
                                   ),
                                   verbatimTextOutput("plotcode")
                                   )
                        ),
                        ## geom_point() of chosen vatiables, coloured if group chosen, splict if facet variable chosen
                        column(
                            width = 12,
                            plotOutput("plot")
                        )
                        
                    ),
                    ## The JS drop drag and drop boxes
                    ## all colnames box for plotting
                    sortable_js(
                        "sort1",
                        options = sortable_options(
                            group = list(
                                name = "sortGroup1",
                                put = TRUE
                            ),
                            sort = FALSE,
                            onSort = sortable_js_capture_input("sort_vars")
                        )
                    ),
                    ## all colnames box for modelling
                    sortable_js(
                        "sort1m",
                        options = sortable_options(
                            group = list(
                                name = "sortGroup1",
                                put = TRUE
                            ),
                            sort = FALSE,
                            onSort = sortable_js_capture_input("sort_varsm")
                        )
                    ),
                    ## covariate (x-axis) to plot
                    sortable_js(
                        "sort2",
                        options = sortable_options(
                            group = list(
                                group = "sortGroup1",
                                put = htmlwidgets::JS("function (to) { return to.el.children.length < 1; }"),
                                pull = TRUE
                            ),
                            onSort = sortable_js_capture_input("sort_x")
                        )
                    ),
                    ## covariate 1 for model
                    sortable_js(
                        "sortcovariate1",
                        options = sortable_options(
                            group = list(
                                group = "sortGroup1",
                                put = htmlwidgets::JS("function (to) { return to.el.children.length < 1; }"),
                                pull = TRUE
                            ),
                            sort = TRUE,
                            onSort = sortable_js_capture_input("sort_xcovariate1")
                        )
                    ),
                    ## covariate 2 for model
                    sortable_js(
                        "sortcovariate2",
                        options = sortable_options(
                            group = list(
                                group = "sortGroup1",
                                put = htmlwidgets::JS("function (to) { return to.el.children.length < 1; }"),
                                pull = TRUE
                            ),
                            sort = TRUE,
                            onSort = sortable_js_capture_input("sort_xcovariate2")
                        )
                    ),
                    ## covariate 3 for model
                    sortable_js(
                        "sortcovariate3",
                        options = sortable_options(
                            group = list(
                                group = "sortGroup1",
                                put = htmlwidgets::JS("function (to) { return to.el.children.length < 1; }"),
                                pull = TRUE
                            ),
                            sort = TRUE,
                            onSort = sortable_js_capture_input("sort_xcovariate3")
                        )
                    ),
                    ## response (y-axis) to plot
                    sortable_js(
                        "sort3",
                        options = sortable_options(
                            group = list(
                                group = "sortGroup1",
                                put = htmlwidgets::JS("function (to) { return to.el.children.length < 1; }"),
                                pull = TRUE
                            ),
                            onSort = sortable_js_capture_input("sort_y")
                        )
                    ),
                    ## response (y-axis) for model
                    sortable_js(
                        "sortresponse",
                        options = sortable_options(
                            group = list(
                                group = "sortGroup1",
                                put = htmlwidgets::JS("function (to) { return to.el.children.length < 1; }"),
                                pull = TRUE
                            ),
                            onSort = sortable_js_capture_input("sort_yresponse")
                        )
                    ),
                    ## Group covariate to plot (colour)
                    sortable_js(
                        "sort4",
                        options = sortable_options(
                            group = list(
                                group = "sortGroup1",
                                put = htmlwidgets::JS("function (to) { return to.el.children.length < 1; }"),
                                pull = TRUE
                            ),
                            onSort = sortable_js_capture_input("sort_group")
                        )
                    ),
                     ## Group covariate to plot (facet)
                    sortable_js(
                        "sort5",
                        options = sortable_options(
                            group = list(
                                group = "sortGroup1",
                                put = htmlwidgets::JS("function (to) { return to.el.children.length < 1; }"),
                                pull = TRUE
                            ),
                            onSort = sortable_js_capture_input("sort_facet")
                        )
                    )
                    ),
            ## Modelling Tab
            tabItem(tabName = "modelling",
                    fluidRow(
                        class = "panel panel-heading",
                        div(
                            class = "panel-heading",
                            h3("Fit an (additive) linear model")
                        ),
                        fluidRow(
                            class = "panel-body",
                            ## all colnames to choose from for model
                            column(
                                width = 3,
                                tags$div(
                                         class = "panel panel-default",
                                         tags$div(class = "panel-heading", "Variables"),
                                         tags$div(
                                                  class = "panel-body",
                                                  id = "sort1m",
                                                  colnames_to_tags(as.data.frame(penguins))
                                              )
                                     )
                            ),
                            column(
                                width = 3,
                                ## model as y (response)
                                tags$div(
                                         class = "panel panel-default",
                                         tags$div(
                                                  class = "panel-heading",
                                                  tags$span(class = "glyphicon glyphicon-stats"),
                                                  "Response variable (drag here)"
                                              ),
                                         tags$div(
                                                  class = "panel-body",
                                                  id = "sortresponse"
                                              )
                                     ),
                                ## model covariate x1
                                tags$div(
                                         class = "panel panel-default",
                                         tags$div(
                                                  class = "panel-heading",
                                                  tags$span(class = "glyphicon glyphicon-stats"),
                                                  "Explanatory variable 1 (drag here)"
                                              ),
                                         tags$div(
                                                  class = "panel-body",
                                                  id = "sortcovariate1"
                                              )
                                     ),
                                ## model covariate x2
                                tags$div(
                                         class = "panel panel-default",
                                         tags$div(
                                                  class = "panel-heading",
                                                  tags$span(class = "glyphicon glyphicon-stats"),
                                                  "Explanatory variable 2 (drag here)"
                                              ),
                                         tags$div(
                                                  class = "panel-body",
                                                  id = "sortcovariate2"
                                              )
                                     ),
                                ## model covariate x3
                                tags$div(
                                         class = "panel panel-default",
                                         tags$div(
                                                  class = "panel-heading",
                                                  tags$span(class = "glyphicon glyphicon-stats"),
                                                  "Explanatory variable 3 (drag here)"
                                              ),
                                         tags$div(
                                                  class = "panel-body",
                                                  id = "sortcovariate3"
                                              )
                                     )
                            ),
                            ## R code to fit model
                            column(
                                width = 6,
                                h4("Estimated coefficients"),
                                verbatimTextOutput("summary_mod")
                                )
                        ),
                        column(width = 12,
                               div(
                                   class = "panel-heading",
                                   h3("Fitted model")
                               ),
                               h3("Model Text"),
                               uiOutput("mod_text"),
                               h3("R code to fit model"),
                               verbatimTextOutput("mod_fit"),
                               h4("Model plot"),
                               plotOutput("modelplot")
                               )
                    )
                    )
        )
    )
)

## Server functions and outpur
server <- function(input, output,session) {
    ## reavitve vars
    output$variables <- renderPrint(input[["sort_vars"]])
    output$variables_mod <- renderPrint(input[["sort_varsm"]])
    output$analyse_x <- renderPrint(input[["sort_x"]])
    output$analyse_xcovariate1 <- renderPrint(input[["sort_xcovariate1"]])
    output$analyse_xcovariate2 <- renderPrint(input[["sort_xcovariate2"]])
    output$analyse_xcovariate3 <- renderPrint(input[["sort_xcovariate3"]])
    output$analyse_y <- renderPrint(input[["sort_y"]])
    output$analyse_yresponse <- renderPrint(input[["sort_yresponse"]])
    output$analyse_group <- renderPrint(input[["sort_group"]])
    output$analyse_facet <- renderPrint(input[["sort_facet"]])
    x <- reactive({
        x <- input$sort_x
        if (is.character(x)) x %>% trimws()
    })
    y <- reactive({
        input$sort_y %>% trimws()
    })
    group <- reactive({
        group <- input$sort_group
    })
    facet <- reactive({
        group <- input$sort_facet
    })
    resp <- reactive({
        input$sort_yresponse
    })
    cov1 <- reactive({
        input$sort_xcovariate1
    })
    cov2 <- reactive({
        input$sort_xcovariate2
    })
    cov3 <- reactive({
        input$sort_xcovariate3
    })
    ## Table output Intro Tab
    output$palmer_table = renderDT(
      penguins, options = list(lengthChange = FALSE)
    )
    ## Plot outpot Plotting Tab
    output$plot <-
        renderPlot({
            validate(
                need(y(), "Drag a response variable"),
                need(x(), "Drag an explanatory variable")
            )
            dat <- penguins[, c(x(), y())]
            if("year" %in% names(dat)) dat$year <- as.factor(dat$year)
            names(dat) <- c("x", "y")
            plt <- ggplot(data = dat, aes(x = x, y = y)) +
                geom_point() + xlab(x()) + ylab(y())
            if(!rlang::is_empty(group()) & rlang::is_empty(facet())){ 
                dat <- penguins[, c(x(), y(),group())]
                if("year" %in% names(dat)) dat$year <- as.factor(dat$year)
                names(dat) <- c("x", "y","group")
                plt <- ggplot(data = dat, aes(x = x, y = y,color = group)) +
                    geom_point() + xlab(x()) + ylab(y()) + labs(color = group())
            }else{
                if(!rlang::is_empty(group()) & !rlang::is_empty(facet())){
                    dat <- penguins[, c(x(), y(),group(),facet())]
                    if("year" %in% names(dat)) dat$year <- as.factor(dat$year)
                    names(dat) <- c("x", "y","group","facet")
                    plt <- ggplot(data = dat, aes(x = x, y = y,color = group)) +
                        geom_point() + facet_wrap(~ facet) +
                        xlab(x()) + ylab(y()) + labs(color = group())
                }else{
                    if(rlang::is_empty(group()) & !rlang::is_empty(facet())){
                        dat <- penguins[, c(x(), y(),facet())]
                        if("year" %in% names(dat)) dat$year <- as.factor(dat$year)
                        names(dat) <- c("x", "y","facet")
                        plt <- ggplot(data = dat, aes(x = x, y = y)) +
                            geom_point() + facet_wrap(~ facet) +
                            xlab(x()) + ylab(y())
                    }}
            }
            plt
        })
    ## print out ggplot code for plotting on Plotting Tab
    output$plotcode <-
        renderPrint({
            req(x())
            req(y())
            data <- penguins[, c(x(), y())]
            names(data) <- c("x1", "y1")
            plt_code <- "ggplot(data = penguins, aes(x = x1, y = y1)) +
                 geom_point()"
            plt_code <- gsub("x1",x(),plt_code)
            plt_code <- gsub("y1",y(),plt_code)
            if(!rlang::is_empty(group()) & rlang::is_empty(facet())){ 
                data <- penguins[, c(x(), y(),group())]
                names(data) <- c("x1", "y1","group")
                plt_code <- "ggplot(data = penguins, aes(x = x1, y1 = y,color = group)) +
                    geom_point()"
                plt_code <- gsub("x1",x(),plt_code)
                plt_code <- gsub("y1",y(),plt_code)
                plt_code <- gsub("group",group(),plt_code)
            }else{
                if(!rlang::is_empty(group()) & !rlang::is_empty(facet())){
                    data <- penguins[, c(x(), y(),group(),facet())]
                    names(data) <- c("x1", "y1","group","facet1")
                    plt_code <- "ggplot(data = penguins, aes(x = x, y = y,color = group)) +
                         geom_point() + facet_wrap(~ facet1)"
                    plt_code <- gsub("x1",x(),plt_code)
                    plt_code <- gsub("y1",y(),plt_code)
                    plt_code <- gsub("group",group(),plt_code)
                    plt_code <- gsub("facet1",facet(),plt_code)
                }else{
                    if(rlang::is_empty(group()) & !rlang::is_empty(facet())){
                        data <- penguins[, c(x(), y(),facet())]
                        names(data) <- c("x1", "y1","facet1")
                        plt_code <- "ggplot(data = penguins, aes(x = x, y = y)) +
                         geom_point() + facet_wrap(~ facet1)"
                        plt_code <- gsub("x1",x(),plt_code)
                        plt_code <- gsub("y1",y(),plt_code)
                        plt_code <- gsub("facet1",facet(),plt_code)
                    }}
            }
            cat("library(palmerpenguins) ## for the data",
                "library(ggplot2) ## for plotting",
                "## create plot",
                paste(plt_code),sep = "\n")
        })
    ## create model from chosen covariates
    model <- reactive({
        validate(
            need(resp(), "Choose a response variable"),
            need(cov1(), "Choose at least one explanatory variable")
        )
        data <- penguins[, c(resp(),cov1())]
        if("year" %in% names(data)) data$year <- as.factor(data$year)
        names(data) <- c("y","x1")
        mod <- lm(y ~ x1, data = data)
        if(!rlang::is_empty(cov2()) & rlang::is_empty(cov3())){
            data <- penguins[, c(resp(),cov1(),cov2())]
            if("year" %in% names(data)) data$year <- as.factor(data$year)
            names(data) <- c("y","x1","x2")
            mod <- lm(y ~ x1 + x2, data = data)
        }else{
            if(!rlang::is_empty(cov2()) & !rlang::is_empty(cov3())){
                data <- penguins[, c(resp(),cov1(),cov2(),cov3())]
                if("year" %in% names(data)) data$year <- as.factor(data$year)
                names(data) <- c("y","x1","x2","x3")
                mod <- lm(y ~ x1 + x2 + x3, data = data)
            }else{
                if(rlang::is_empty(cov2()) & !rlang::is_empty(cov3())){
                    data <- penguins[, c(resp(),cov1(),cov3())]
                    if("year" %in% names(data)) data$year <- as.factor(data$year)
                    names(data) <- c("y","x1","x3")
                    mod <- lm(y ~ x1 + x3, data = data)
                }   
            }
        }
        
        mod
    })
    ## using equationmatic to print latex type model formulation
    output$mod_text <- renderPrint({
        req(model())
        mod <- model()
        x <- extract_eq(mod)
        x <- gsub("y",resp(),x)
        x <- gsub("x1",cov1(),x)
        if(!rlang::is_empty(cov2())) x <- gsub("x2",cov2(),x)
        if(!rlang::is_empty(cov3())) x <- gsub("x3",cov3(),x)
        x <- gsub("_"," ",x)
        withMathJax(paste("$$",as.character(x),"$$",sep = ""))
    })
    ## printing out R code to fit model
    output$mod_fit <- renderPrint({
        req(model())
        mod <- "fit <- lm(y ~ x1, data = penguins)"
        mod <- gsub("y",resp(),mod)
        mod <- gsub("x1",cov1(),mod)
        if(!rlang::is_empty(cov2()) & rlang::is_empty(cov3())){
            mod <- "fit <- lm(y ~ x1 + x2, data = penguins)"
            mod <- gsub("y",resp(),mod)
            mod <- gsub("x1",cov1(),mod)
            mod <- gsub("x2",cov2(),mod)
        }else{
            if(!rlang::is_empty(cov2()) & !rlang::is_empty(cov3())){
                mod <- "fit <- lm(y ~ x1 + x2 + x3, data = penguins)"
                mod <- gsub("y",resp(),mod)
                mod <- gsub("x1",cov1(),mod)
                mod <- gsub("x2",cov2(),mod)
                mod <- gsub("x3",cov3(),mod)
            }else{
                if(rlang::is_empty(cov2()) & !rlang::is_empty(cov3())){
                    mod <- "fit <- lm(y ~ x1 + x3, data = penguins)"
                    mod <- gsub("y",resp(),mod)
                    mod <- gsub("x1",cov1(),mod)
                    mod <- gsub("x3",cov3(),mod)
                }   
            }
        }
        cat(paste(mod))
    })
    ## summary output
    output$summary_mod <- renderPrint({
        req(model())
        mod <- "y ~ x1"
        mod <- gsub("y",resp(),mod)
        mod <- gsub("x1",cov1(),mod)
        if(!rlang::is_empty(cov2()) & rlang::is_empty(cov3())){
            mod <- "y ~ x1 + x2"
            mod <- gsub("y",resp(),mod)
            mod <- gsub("x1",cov1(),mod)
            mod <- gsub("x2",cov2(),mod)
        }else{
            if(!rlang::is_empty(cov2()) & !rlang::is_empty(cov3())){
                mod <- "y ~ x1 + x2 + x3"
                mod <- gsub("y",resp(),mod)
                mod <- gsub("x1",cov1(),mod)
                mod <- gsub("x2",cov2(),mod)
                mod <- gsub("x3",cov3(),mod)
            }else{
                if(rlang::is_empty(cov2()) & !rlang::is_empty(cov3())){
                    mod <- "y ~ x1 + x3"
                    mod <- gsub("y",resp(),mod)
                    mod <- gsub("x1",cov1(),mod)
                    mod <- gsub("x3",cov3(),mod)
                }   
            }
        }
        if(!rlang::is_empty(grep("year",mod)))  penguins$year <- as.factor(penguins$year)
        fit <- lm(formula(mod), data = penguins)
        summary(fit)$coefficients
    })
    output$modelplot <- renderPlot({
        req(model())
        dat <- penguins[, c(resp(), cov1())]
        if("year" %in% names(dat)) dat$year <- as.factor(dat$year)
        names(dat) <- c("x", "y")
        plt <- ggplot(data = dat, aes(x = x, y = y)) +
            geom_point() + xlab(cov1()) + ylab(resp())
        if(!rlang::is_empty(cov2()) & rlang::is_empty(cov3())){ 
            dat <- penguins[, c(cov1(), resp(),cov2())]
            if("year" %in% names(dat)) dat$year <- as.factor(dat$year)
            names(dat) <- c("x", "y","group")
            plt <- ggplot(data = dat, aes(x = x, y = y,color = group)) +
                geom_point() + xlab(cov1()) + ylab(resp()) + labs(color = cov2())
        }else{
            if(!rlang::is_empty(cov2()) & !rlang::is_empty(cov3())){
                dat <- penguins[, c(cov1(), resp(),cov2(),cov3())]
                if("year" %in% names(dat)) dat$year <- as.factor(dat$year)
                names(dat) <- c("x", "y","group","facet")
                plt <- ggplot(data = dat, aes(x = x, y = y,color = group)) +
                    geom_point() + facet_wrap(~ facet) +
                    xlab(cov1()) + ylab(resp()) + labs(color = cov2())
            }else{
                if(rlang::is_empty(cov2()) & !rlang::is_empty(cov3())){
                    dat <- penguins[, c(cov1(), resp(),cov3())]
                    if("year" %in% names(dat)) dat$year <- as.factor(dat$year)
                    names(dat) <- c("x", "y","facet")
                    plt <- ggplot(data = dat, aes(x = x, y = y)) +
                        geom_point() + facet_wrap(~ facet) +
                        xlab(cov1()) + ylab(resp())
                }}
        }
        plt + geom_smooth(method = "lm", se = TRUE)
    })
}

shinyApp(ui, server)
