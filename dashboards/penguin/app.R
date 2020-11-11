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
                    menuItem("Meet the Palmer penguins", tabName = "intro", icon = icon("dashboard")),
                    menuItem("Plotting", tabName = "plotting", icon = icon("dashboard")),
                    menuItem("Modelling", tabName = "modelling", icon = icon("th"))
                    )
    ),
    ## Tab pages
    dashboardBody(
        tabItems(
            tabItem(tabName = "intro",
                    h1("Introducing the", tags$a(href = "https://github.com/allisonhorst/palmerpenguins","Palmer penguins")),
                    tags$img(src = "https://raw.githubusercontent.com/allisonhorst/palmerpenguins/master/man/figures/lter_penguins.png", width = "70%"),
                    tags$h3("Artwork by",tags$a(href = "https://github.com/allisonhorst/", "@allison_horst")),
                    DTOutput('palmer_table'),
                    hr(),
                    tags$foot("Horst AM, Hill AP, Gorman KB (2020). palmerpenguins: Palmer Archipelago (Antarctica) penguin data. R package version 0.1.0. https://allisonhorst.github.io/palmerpenguins/. doi: 10.5281/zenodo.3960218.")
                    ),
            tabItem(tabName = "plotting",
                    fluidRow(
                        class = "panel panel-heading",
                        div(
                            class = "panel-heading",
                            h3("Drag variables to plot data")
                        ),
                        fluidRow(
                            class = "panel-body",
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
                                ## analyse as y (response)
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
                                ## analyse as x (covariate)
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
                                ## analyse as group (covariate)
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
                                     )
                            ),
                            column(
                                width = 6,
                                plotOutput("plot")
                            )
                        ),
                        column(width = 12,
                               div(
                                   class = "panel-heading",
                                   h3("R code for plot")
                               ),
                               verbatimTextOutput("plotcode")
                               )
                    ),
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
                    )
                    ),
            tabItem(tabName = "modelling",
                    fluidRow(
                        class = "panel panel-heading",
                        div(
                            class = "panel-heading",
                            h3("Drag variables to model data")
                        ),
                        fluidRow(
                            class = "panel-body",
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
                                     )
                            ),
                            ## eq writeup
                            column(
                                width = 6,
                                h3("Model Text"),
                                uiOutput("mod_text"),
                                h3("R code to fit model"),
                                textOutput("mod_fit")
                            )
                        ),
                        column(width = 12,
                               div(
                                   class = "panel-heading",
                                   h3("Fitted model")
                               ),
                               plotOutput("modelplot")
                               )
                    )
                    )
        )
    )
)

server <- function(input, output,session) {
    output$variables <- renderPrint(input[["sort_vars"]])
    output$variables_mod <- renderPrint(input[["sort_varsm"]])
    output$analyse_x <- renderPrint(input[["sort_x"]])
    output$analyse_xcovariate1 <- renderPrint(input[["sort_xcovariate1"]])
    output$analyse_xcovariate2 <- renderPrint(input[["sort_xcovariate2"]])
    output$analyse_y <- renderPrint(input[["sort_y"]])
    output$analyse_yresponse <- renderPrint(input[["sort_yresponse"]])
    output$analyse_group <- renderPrint(input[["sort_group"]])
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
    resp <- reactive({
        input$sort_yresponse
    })
    cov1 <- reactive({
        input$sort_xcovariate1
    })
    cov2 <- reactive({
        input$sort_xcovariate2
    })
    output$palmer_table = renderDT(
      penguins, options = list(lengthChange = FALSE)
    )
    output$plot <-
        renderPlot({
            validate(
                need(x(), "Drag an explanatory variable"),
                need(y(), "Drag a response variable")
            )
            dat <- penguins[, c(x(), y())]
            names(dat) <- c("x", "y")
            plt <- ggplot(data = dat, aes(x = x, y = y)) +
                geom_point() + xlab(x()) + ylab(y())
            if(!rlang::is_empty(group())){ 
                dat <- penguins[, c(x(), y(),group())]
                names(dat) <- c("x", "y","group")
                plt <- ggplot(data = dat, aes(x = x, y = y,color = group)) +
                    geom_point() + xlab(x()) + ylab(y()) + labs(color = group())
            }
            plt
        })
    ## print out ggplot code
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
             if(!rlang::is_empty(group())){ 
                data <- penguins[, c(x(), y(),group())]
                names(data) <- c("x1", "y1","group")
                plt_code <- "ggplot(data = dat, aes(x = x1, y1 = y,color = group)) +
                    geom_point()"
                plt_code <- gsub("x1",x(),plt_code)
                plt_code <- gsub("y1",y(),plt_code)
                plt_code <- gsub("group",group(),plt_code)
            }
            cat("library(palmerpenguins) ## for the data",
                "library(ggplot2) ## for plotting",
                "## create plot",
                 paste(plt_code),sep = "\n")
        })
    model <- reactive({
        req(resp())
        req(cov1())
        data <- penguins[, c(resp(),cov1())]
        names(data) <- c("y","x")
        mod <- lm(y ~ x, data = data)
        print(mod)
        mod

    })
    output$mod_text <- renderUI({
        req(model())
        mod <- lm(body_mass_g ~ bill_length_mm + species, data = penguins)
        x <- extract_eq(mod)
        x <- gsub("\\\\","\\\\\\\\",x)
        withMathJax(x)
    })
    output$mod_fit <- renderText({
        validate(need(model(),"Choose response variable"))
        
    })
    output$modelplot <- renderPlot({
        validate(need(model(),"Choose response variable"))
        data <- penguins[, c(resp(),cov1())]
        names(data) <- c("y","x")
        plt <- ggplot(data = data, aes(x = x, y = y)) +
            geom_point() + xlab(x()) + ylab(y())
        if(!rlang::is_empty(cov2())){ 
            data <- penguins[, c(resp(),cov1(),cov2())]
            names(data) <- c("y", "x","cov2")
            plt <- ggplot(data = data, aes(x = x, y = y,color = cov2)) +
                geom_point() + xlab(cov1()) + ylab(resp()) + labs(color = cov2())
        }
        plt
    })
}

shinyApp(ui, server)
