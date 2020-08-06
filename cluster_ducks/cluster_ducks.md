The Data
--------

### Duck outfits

*Use the drop-down menu to explore the collection of duck outfits.*

<!--html_preserve-->
<html>
<select id="AterKEmhNk" class="selectpicker" data-dropdown-align-right="false" data-dropup-auto="true" data-header="false" data-live-search="true" data-live-search-style="contains" data-show-tick="true" data-width="false" data-size="10"><option value="images/blue_flowers-1.jpeg">blue\_flowers-1</option>
<option value="images/blue_flowers-2.jpg" selected>blue\_flowers-2</option>
<option value="images/blue_flowers-3.jpeg">blue\_flowers-3</option>
<option value="images/blue_flowers-4.jpeg">blue\_flowers-4</option>
<option value="images/blue_flowers-5.jpeg">blue\_flowers-5</option>
<option value="images/bridal-1.jpg">bridal-1</option>
<option value="images/bridal-2.jpeg">bridal-2</option>
<option value="images/bridal-3.jpg">bridal-3</option>
<option value="images/bridal-4.jpg">bridal-4</option>
<option value="images/bridal-5.jpeg">bridal-5</option>
<option value="images/bridal-6.jpg">bridal-6</option>
<option value="images/bridal-7.jpg">bridal-7</option>
<option value="images/patterns-1.jpg">patterns-1</option>
<option value="images/patterns-2.jpg">patterns-2</option>
<option value="images/patterns-3.jpg">patterns-3</option>
<option value="images/patterns-4.jpeg">patterns-4</option>
<option value="images/pink_check-1.jpg">pink\_check-1</option>
<option value="images/pink_check-2.jpg">pink\_check-2</option>
<option value="images/pink_check-3.jpeg">pink\_check-3</option>
<option value="images/pink_check-4.jpeg">pink\_check-4</option>
<option value="images/red-1.jpeg">red-1</option>
<option value="images/red-2.jpeg">red-2</option>
<option value="images/red-3.jpeg">red-3</option>
<option value="images/red-4.jpeg">red-4</option>
<option value="images/red-5.jpg">red-5</option>
<option value="images/red-6.jpeg">red-6</option>
<option value="images/wax_jacket-1.jpg">wax\_jacket-1</option>
<option value="images/wax_jacket-2.jpeg">wax\_jacket-2</option>
<option value="images/wax_jacket-3.jpg">wax\_jacket-3</option></select>
<img src="images/blue_flowers-2.jpg" name="DVjLqoM7aD" height="500" width="30%"/>
<script>$(document).ready(function(){
                 $("#AterKEmhNk").change(function(){
                 $("img[name=DVjLqoM7aD]").attr("src",$(this).val());

                 });

  });</script>
</html>

<script type="application/json" data-for="htmlwidget-0fac734d6527ac5724ab">{"x":[],"evals":[],"jsHooks":[]}</script>
<!--/html_preserve-->
All images used here are available
[here](https://github.com/cmjt/statbiscuits/tree/master/cluster_ducks/images).
To read images into R you can use the `readJPEG()` function from the `R`
package `jpeg`. Using `readJPEG` each image is read in as a
*m* \* *n* \* 3 array, where each of the three *m* \* *n* matricies are
the red, green, and blue primary values (R, G, & B values) of each pixel
respectivly.

### RGB arrays

For ease, however, we’re going to download the RGB data directly from
GitHub.

    data_url <- "https://github.com/cmjt/statbiscuits/raw/master/cluster_ducks/duck_rgbs.RData"
    load(url(data_url))

![RGB arrays for the first image (element) of the `ducks_rgbs` object.
The image is of a duck in the ‘blue flowers’
outfit.](cluster_ducks_files/figure-markdown_strict/rgb1-1.png)

![RGB arrays for the second image (element) of the `ducks_rgbs` object.
The image is of a duck in the ‘blue flowers’
outfit.](cluster_ducks_files/figure-markdown_strict/rgb2-1.png)

The `duck_rgbs` object is a named list of RGB arrays for each image.
There are 29 different images of 6 different outfits.

    length(duck_rgbs)
    ## [1] 29
    names(duck_rgbs)
    ##  [1] "blue_flowers-1" "blue_flowers-2" "blue_flowers-3" "blue_flowers-4"
    ##  [5] "blue_flowers-5" "bridal-1"       "bridal-2"       "bridal-3"      
    ##  [9] "bridal-4"       "bridal-5"       "bridal-6"       "bridal-7"      
    ## [13] "patterns-1"     "patterns-2"     "patterns-3"     "patterns-4"    
    ## [17] "pink_check-1"   "pink_check-2"   "pink_check-3"   "pink_check-4"  
    ## [21] "red-1"          "red-2"          "red-3"          "red-4"         
    ## [25] "red-5"          "red-6"          "wax_jacket-1"   "wax_jacket-2"  
    ## [29] "wax_jacket-3"

### Data exploration

Let’s summarise each image by the average R, G, and B value
respectively.

    cluster_ducks <- data.frame(attire  = stringr::str_match(names(duck_rgbs),"(.*?)-")[,2],
                                av_red = sapply(duck_rgbs, function(x) mean(c(x[,,1]))),
                                av_green = sapply(duck_rgbs, function(x) mean(c(x[,,2]))),
                                av_blue = sapply(duck_rgbs, function(x) mean(c(x[,,3]))))

    head(cluster_ducks)
    ##                      attire    av_red  av_green   av_blue
    ## blue_flowers-1 blue_flowers 0.4529505 0.4790429 0.4610547
    ## blue_flowers-2 blue_flowers 0.4751319 0.5131624 0.4977116
    ## blue_flowers-3 blue_flowers 0.4560981 0.4881459 0.4919892
    ## blue_flowers-4 blue_flowers 0.4745254 0.5117347 0.4948642
    ## blue_flowers-5 blue_flowers 0.5955183 0.6413420 0.5757063
    ## bridal-1             bridal 0.5718594 0.5645125 0.4567448
    table(cluster_ducks$attire)
    ## 
    ## blue_flowers       bridal     patterns   pink_check          red   wax_jacket 
    ##            5            7            4            4            6            3

    library(plotly) ## for 3D interactive plots

    plot_ly(x = cluster_ducks$av_red, y = cluster_ducks$av_green, 
            z = cluster_ducks$av_blue,
            type = "scatter3d", mode = "markers", 
            color = cluster_ducks$attire)

<!--html_preserve-->

<script type="application/json" data-for="htmlwidget-42256a01c658dbcb6be5">{"x":{"visdat":{"6164a122c11":["function () ","plotlyVisDat"]},"cur_data":"6164a122c11","attrs":{"6164a122c11":{"x":[0.452950487674294,0.475131901679788,0.456098089299577,0.474525372909701,0.595518315853473,0.571859423822404,0.548290875512363,0.461976449541504,0.481079914013067,0.437996326598764,0.457944839166612,0.403088482682793,0.504802255410931,0.470760474532799,0.457738963823059,0.46800988173047,0.668916256922405,0.733485044052562,0.639871478002966,0.678572505925447,0.494195146906114,0.563255480371304,0.425367030735071,0.483720056616557,0.442555077527465,0.567232170097932,0.383322386826951,0.384206248805703,0.395447712346859],"y":[0.479042937581311,0.513162433461766,0.488145894373075,0.511734735580198,0.641342040692246,0.564512496500397,0.51883610900318,0.450825953953503,0.492575770856509,0.481165273589817,0.483836655559188,0.442602070734836,0.442609294182949,0.398087469879563,0.361938154714879,0.409232804232804,0.531884867961436,0.554768209077248,0.520815730213654,0.523191481720893,0.343360591900312,0.361570842640205,0.189140455013933,0.393314429204228,0.409872488179669,0.306391134143774,0.451479760255379,0.42232257679584,0.452845887059544],"z":[0.461054726599781,0.497711576898592,0.491989206921594,0.494864180039779,0.575706251492845,0.456744770731304,0.439735474991772,0.386626000631402,0.397371335865323,0.437424297486569,0.402850274640448,0.380299248671431,0.393100042446208,0.274626046307254,0.249183725871101,0.280174758792406,0.473485077324675,0.602344866015356,0.443726259131103,0.484964447317388,0.341210830126443,0.267390978846994,0.188142686503544,0.200742780861917,0.208620019816437,0.30988298891768,0.24186536304146,0.248711690770309,0.262346022728003],"mode":"markers","color":["blue_flowers","blue_flowers","blue_flowers","blue_flowers","blue_flowers","bridal","bridal","bridal","bridal","bridal","bridal","bridal","patterns","patterns","patterns","patterns","pink_check","pink_check","pink_check","pink_check","red","red","red","red","red","red","wax_jacket","wax_jacket","wax_jacket"],"alpha_stroke":1,"sizes":[10,100],"spans":[1,20],"type":"scatter3d"}},"layout":{"margin":{"b":40,"l":60,"t":25,"r":10},"scene":{"xaxis":{"title":[]},"yaxis":{"title":[]},"zaxis":{"title":[]}},"hovermode":"closest","showlegend":true},"source":"A","config":{"showSendToCloud":false},"data":[{"x":[0.452950487674294,0.475131901679788,0.456098089299577,0.474525372909701,0.595518315853473],"y":[0.479042937581311,0.513162433461766,0.488145894373075,0.511734735580198,0.641342040692246],"z":[0.461054726599781,0.497711576898592,0.491989206921594,0.494864180039779,0.575706251492845],"mode":"markers","type":"scatter3d","name":"blue_flowers","marker":{"color":"rgba(102,194,165,1)","line":{"color":"rgba(102,194,165,1)"}},"textfont":{"color":"rgba(102,194,165,1)"},"error_y":{"color":"rgba(102,194,165,1)"},"error_x":{"color":"rgba(102,194,165,1)"},"line":{"color":"rgba(102,194,165,1)"},"frame":null},{"x":[0.571859423822404,0.548290875512363,0.461976449541504,0.481079914013067,0.437996326598764,0.457944839166612,0.403088482682793],"y":[0.564512496500397,0.51883610900318,0.450825953953503,0.492575770856509,0.481165273589817,0.483836655559188,0.442602070734836],"z":[0.456744770731304,0.439735474991772,0.386626000631402,0.397371335865323,0.437424297486569,0.402850274640448,0.380299248671431],"mode":"markers","type":"scatter3d","name":"bridal","marker":{"color":"rgba(252,141,98,1)","line":{"color":"rgba(252,141,98,1)"}},"textfont":{"color":"rgba(252,141,98,1)"},"error_y":{"color":"rgba(252,141,98,1)"},"error_x":{"color":"rgba(252,141,98,1)"},"line":{"color":"rgba(252,141,98,1)"},"frame":null},{"x":[0.504802255410931,0.470760474532799,0.457738963823059,0.46800988173047],"y":[0.442609294182949,0.398087469879563,0.361938154714879,0.409232804232804],"z":[0.393100042446208,0.274626046307254,0.249183725871101,0.280174758792406],"mode":"markers","type":"scatter3d","name":"patterns","marker":{"color":"rgba(141,160,203,1)","line":{"color":"rgba(141,160,203,1)"}},"textfont":{"color":"rgba(141,160,203,1)"},"error_y":{"color":"rgba(141,160,203,1)"},"error_x":{"color":"rgba(141,160,203,1)"},"line":{"color":"rgba(141,160,203,1)"},"frame":null},{"x":[0.668916256922405,0.733485044052562,0.639871478002966,0.678572505925447],"y":[0.531884867961436,0.554768209077248,0.520815730213654,0.523191481720893],"z":[0.473485077324675,0.602344866015356,0.443726259131103,0.484964447317388],"mode":"markers","type":"scatter3d","name":"pink_check","marker":{"color":"rgba(231,138,195,1)","line":{"color":"rgba(231,138,195,1)"}},"textfont":{"color":"rgba(231,138,195,1)"},"error_y":{"color":"rgba(231,138,195,1)"},"error_x":{"color":"rgba(231,138,195,1)"},"line":{"color":"rgba(231,138,195,1)"},"frame":null},{"x":[0.494195146906114,0.563255480371304,0.425367030735071,0.483720056616557,0.442555077527465,0.567232170097932],"y":[0.343360591900312,0.361570842640205,0.189140455013933,0.393314429204228,0.409872488179669,0.306391134143774],"z":[0.341210830126443,0.267390978846994,0.188142686503544,0.200742780861917,0.208620019816437,0.30988298891768],"mode":"markers","type":"scatter3d","name":"red","marker":{"color":"rgba(166,216,84,1)","line":{"color":"rgba(166,216,84,1)"}},"textfont":{"color":"rgba(166,216,84,1)"},"error_y":{"color":"rgba(166,216,84,1)"},"error_x":{"color":"rgba(166,216,84,1)"},"line":{"color":"rgba(166,216,84,1)"},"frame":null},{"x":[0.383322386826951,0.384206248805703,0.395447712346859],"y":[0.451479760255379,0.42232257679584,0.452845887059544],"z":[0.24186536304146,0.248711690770309,0.262346022728003],"mode":"markers","type":"scatter3d","name":"wax_jacket","marker":{"color":"rgba(255,217,47,1)","line":{"color":"rgba(255,217,47,1)"}},"textfont":{"color":"rgba(255,217,47,1)"},"error_y":{"color":"rgba(255,217,47,1)"},"error_x":{"color":"rgba(255,217,47,1)"},"line":{"color":"rgba(255,217,47,1)"},"frame":null}],"highlight":{"on":"plotly_click","persistent":false,"dynamic":false,"selectize":false,"opacityDim":0.2,"selected":{"opacity":1},"debounce":0},"shinyEvents":["plotly_hover","plotly_click","plotly_selected","plotly_relayout","plotly_brushed","plotly_brushing","plotly_clickannotation","plotly_doubleclick","plotly_deselect","plotly_afterplot","plotly_sunburstclick"],"base_url":"https://plot.ly"},"evals":[],"jsHooks":[]}</script>
<!--/html_preserve-->
<p class="caption">
3D scatterplot of the average RGB value per image.
</p>

Rather than the average R, G, & B let’s calculate the proportion of each
primary.

    prop.max <- function(x){
        ## matrix of index of max RGB values of x
        mat_max <- apply(x,c(1,2),which.max)
        ## table of collapsed values
        tab <- table(c(mat_max))
        ## proportion of red
        prop_red <- tab[1]/sum(tab)
        prop_green <- tab[2]/sum(tab)
        prop_blue <- tab[3]/sum(tab)
        return(c(prop_red,prop_green,prop_blue))
    }
    ## proportion of r, g, b in each image
    prop <- do.call('rbind',lapply(duck_rgbs,prop.max))
    cluster_ducks$prop_red <- prop[,1]
    cluster_ducks$prop_green <- prop[,2]
    cluster_ducks$prop_blue <- prop[,3]

    plot_ly(x = cluster_ducks$prop_red, y = cluster_ducks$prop_green, 
            z = cluster_ducks$prop_blue,
            type = "scatter3d", mode = "markers", 
            color = cluster_ducks$attire)

<!--html_preserve-->

<script type="application/json" data-for="htmlwidget-8c9c7c27e32fda922846">{"x":{"visdat":{"61664446cde":["function () ","plotlyVisDat"]},"cur_data":"61664446cde","attrs":{"61664446cde":{"x":[0.193279250758475,0.0779532021698648,0.280779054916986,0.0763911863958182,0.10218715393134,0.455457902269028,0.767596060479956,0.405474520431479,0.349585070462724,0.0613791951911838,0.192505004129282,0.0752079439252336,0.424258007640317,0.514611824411013,0.624012969407292,0.49922619047619,0.625455265241489,0.901318425343583,0.596134453781513,0.741529304029304,0.769567757009346,0.692806583214199,0.762238400389358,0.405046999983709,0.30072695035461,0.884067499452115,0.120334022848009,0.245939388955138,0.184990053122882],"y":[0.336334256694368,0.289365233584325,0.324584929757344,0.301660821809039,0.376024363233666,0.338548892797448,0.186232487168817,0.35842765290398,0.456040058335843,0.591417598931374,0.622835626600971,0.658992990654206,0.366680135174846,0.424384402649611,0.317862283901444,0.471507936507936,0.358183463409117,0.012569298858607,0.385546218487395,0.243406593406593,0.143691588785047,0.233027650894383,0.0520258760545101,0.576055259599563,0.647617464539007,0.114507999123384,0.86336443984768,0.742218018833011,0.804822595807009],"z":[0.470386492547157,0.63268156424581,0.39463601532567,0.621947991795143,0.521788482834994,0.205993204933524,0.0461714523512276,0.236097826664541,0.194374871201433,0.347203205877442,0.184659369269747,0.265799065420561,0.209061857184837,0.0610037729393764,0.0581247466912638,0.029265873015873,0.0163612713493949,0.0861122757978104,0.0183193277310924,0.0150641025641026,0.0867406542056075,0.0741657658914188,0.185735723556132,0.0188977404167278,0.051655585106383,0.00142450142450142,0.016301537304311,0.0118425922118508,0.0101873510701091],"mode":"markers","color":["blue_flowers","blue_flowers","blue_flowers","blue_flowers","blue_flowers","bridal","bridal","bridal","bridal","bridal","bridal","bridal","patterns","patterns","patterns","patterns","pink_check","pink_check","pink_check","pink_check","red","red","red","red","red","red","wax_jacket","wax_jacket","wax_jacket"],"alpha_stroke":1,"sizes":[10,100],"spans":[1,20],"type":"scatter3d"}},"layout":{"margin":{"b":40,"l":60,"t":25,"r":10},"scene":{"xaxis":{"title":[]},"yaxis":{"title":[]},"zaxis":{"title":[]}},"hovermode":"closest","showlegend":true},"source":"A","config":{"showSendToCloud":false},"data":[{"x":[0.193279250758475,0.0779532021698648,0.280779054916986,0.0763911863958182,0.10218715393134],"y":[0.336334256694368,0.289365233584325,0.324584929757344,0.301660821809039,0.376024363233666],"z":[0.470386492547157,0.63268156424581,0.39463601532567,0.621947991795143,0.521788482834994],"mode":"markers","type":"scatter3d","name":"blue_flowers","marker":{"color":"rgba(102,194,165,1)","line":{"color":"rgba(102,194,165,1)"}},"textfont":{"color":"rgba(102,194,165,1)"},"error_y":{"color":"rgba(102,194,165,1)"},"error_x":{"color":"rgba(102,194,165,1)"},"line":{"color":"rgba(102,194,165,1)"},"frame":null},{"x":[0.455457902269028,0.767596060479956,0.405474520431479,0.349585070462724,0.0613791951911838,0.192505004129282,0.0752079439252336],"y":[0.338548892797448,0.186232487168817,0.35842765290398,0.456040058335843,0.591417598931374,0.622835626600971,0.658992990654206],"z":[0.205993204933524,0.0461714523512276,0.236097826664541,0.194374871201433,0.347203205877442,0.184659369269747,0.265799065420561],"mode":"markers","type":"scatter3d","name":"bridal","marker":{"color":"rgba(252,141,98,1)","line":{"color":"rgba(252,141,98,1)"}},"textfont":{"color":"rgba(252,141,98,1)"},"error_y":{"color":"rgba(252,141,98,1)"},"error_x":{"color":"rgba(252,141,98,1)"},"line":{"color":"rgba(252,141,98,1)"},"frame":null},{"x":[0.424258007640317,0.514611824411013,0.624012969407292,0.49922619047619],"y":[0.366680135174846,0.424384402649611,0.317862283901444,0.471507936507936],"z":[0.209061857184837,0.0610037729393764,0.0581247466912638,0.029265873015873],"mode":"markers","type":"scatter3d","name":"patterns","marker":{"color":"rgba(141,160,203,1)","line":{"color":"rgba(141,160,203,1)"}},"textfont":{"color":"rgba(141,160,203,1)"},"error_y":{"color":"rgba(141,160,203,1)"},"error_x":{"color":"rgba(141,160,203,1)"},"line":{"color":"rgba(141,160,203,1)"},"frame":null},{"x":[0.625455265241489,0.901318425343583,0.596134453781513,0.741529304029304],"y":[0.358183463409117,0.012569298858607,0.385546218487395,0.243406593406593],"z":[0.0163612713493949,0.0861122757978104,0.0183193277310924,0.0150641025641026],"mode":"markers","type":"scatter3d","name":"pink_check","marker":{"color":"rgba(231,138,195,1)","line":{"color":"rgba(231,138,195,1)"}},"textfont":{"color":"rgba(231,138,195,1)"},"error_y":{"color":"rgba(231,138,195,1)"},"error_x":{"color":"rgba(231,138,195,1)"},"line":{"color":"rgba(231,138,195,1)"},"frame":null},{"x":[0.769567757009346,0.692806583214199,0.762238400389358,0.405046999983709,0.30072695035461,0.884067499452115],"y":[0.143691588785047,0.233027650894383,0.0520258760545101,0.576055259599563,0.647617464539007,0.114507999123384],"z":[0.0867406542056075,0.0741657658914188,0.185735723556132,0.0188977404167278,0.051655585106383,0.00142450142450142],"mode":"markers","type":"scatter3d","name":"red","marker":{"color":"rgba(166,216,84,1)","line":{"color":"rgba(166,216,84,1)"}},"textfont":{"color":"rgba(166,216,84,1)"},"error_y":{"color":"rgba(166,216,84,1)"},"error_x":{"color":"rgba(166,216,84,1)"},"line":{"color":"rgba(166,216,84,1)"},"frame":null},{"x":[0.120334022848009,0.245939388955138,0.184990053122882],"y":[0.86336443984768,0.742218018833011,0.804822595807009],"z":[0.016301537304311,0.0118425922118508,0.0101873510701091],"mode":"markers","type":"scatter3d","name":"wax_jacket","marker":{"color":"rgba(255,217,47,1)","line":{"color":"rgba(255,217,47,1)"}},"textfont":{"color":"rgba(255,217,47,1)"},"error_y":{"color":"rgba(255,217,47,1)"},"error_x":{"color":"rgba(255,217,47,1)"},"line":{"color":"rgba(255,217,47,1)"},"frame":null}],"highlight":{"on":"plotly_click","persistent":false,"dynamic":false,"selectize":false,"opacityDim":0.2,"selected":{"opacity":1},"debounce":0},"shinyEvents":["plotly_hover","plotly_click","plotly_selected","plotly_relayout","plotly_brushed","plotly_brushing","plotly_clickannotation","plotly_doubleclick","plotly_deselect","plotly_afterplot","plotly_sunburstclick"],"base_url":"https://plot.ly"},"evals":[],"jsHooks":[]}</script>
<!--/html_preserve-->
<p class="caption">
3D scatterplot of the proportion of RGB value per image.
</p>

K means clustering
------------------

Can we cluster the images based on the calculated measures above?

    ## library for k-means clustering
    library(factoextra)
    ## re format data. We deal only with the numerics info
    df <- cluster_ducks[,2:7]
    ## specify rownames as image names
    rownames(df) <- names(duck_rgbs)

    distance <- get_dist(df)
    fviz_dist(distance, gradient = list(low = "#00AFBB", mid = "white", high = "#FC4E07"))

![](cluster_ducks_files/figure-markdown_strict/dist-1.png)

### Compute k-means

So we have an idea there are 6… but is there enough information in the
noisy images?

Setting `nstart = 25` means that `R` will try 25 different random
starting assignments and then select the best results corresponding to
the one with the lowest within cluster variation.

    ## from two clusters to 6 (can we separate out the images?)
    set.seed(4321)
    k2 <- kmeans(df, centers = 2, nstart = 25)
    k3 <- kmeans(df, centers = 3, nstart = 25)
    k4 <- kmeans(df, centers = 4, nstart = 25)
    k5 <- kmeans(df, centers = 5, nstart = 25)
    k6 <- kmeans(df, centers = 6, nstart = 25)

#### Results of a call to `kmeans()`

The `kmeans()` function returns a list of components:

-   `cluster`, integers indicating the cluster to which each observation
    is allocated
-   `centers`, a matrix of cluster centers/means
-   `totss`, the total sum of squares
-   `withinss`, within-cluster sum of squares, one component per cluster
-   `tot.withinss`, total within-cluster sum of squares
-   `betweenss`, between-cluster sum of squares
-   `size`, number of observations in each cluster

<!-- -->

    k2$tot.withinss
    ## [1] 2.786543
    k3$tot.withinss
    ## [1] 1.75652
    k4$tot.withinss
    ## [1] 1.193151
    k5$tot.withinss
    ## [1] 0.9316645
    k6$tot.withinss
    ## [1] 0.7281481

    barplot(c(k2$tot.withinss,k3$tot.withinss,k4$tot.withinss,
              k5$tot.withinss,k6$tot.withinss),
            names = paste(2:6," clusters"))

![](cluster_ducks_files/figure-markdown_strict/bar-1.png)

#### Vizualising `kmeans()`

    p2 <- fviz_cluster(k2, data = df)
    p3 <- fviz_cluster(k3, data = df)
    p4 <- fviz_cluster(k4, data = df)
    p5 <- fviz_cluster(k5, data = df)
    p6 <- fviz_cluster(k6, data = df)
    ## for arranging plots
    library(patchwork) 
    p2/ p3/ p4/ p5/ p6

![](cluster_ducks_files/figure-markdown_strict/cluster%20viz-1.png)

### How many clusters are best?

The `fviz_nbclust()` function in the `R` package `factoextra` can be
used to compute the three different methods \[elbow, silhouette and gap
statistic\] for any partitioning clustering methods \[K-means, K-medoids
(PAM), CLARA, HCUT\].

    # Elbow method
    fviz_nbclust(df, kmeans, method = "wss") +
      labs(subtitle = "Elbow method")

![](cluster_ducks_files/figure-markdown_strict/nbclust-1.png)


    # Silhouette method
    fviz_nbclust(df, kmeans, method = "silhouette")+
      labs(subtitle = "Silhouette method")

![](cluster_ducks_files/figure-markdown_strict/nbclust-2.png)


    # Gap statistic
    # recommended value: nboot= 500 for your analysis.
    set.seed(123)
    fviz_nbclust(df, kmeans, nstart = 25,  method = "gap_stat", nboot = 50)+
      labs(subtitle = "Gap statistic method")

![](cluster_ducks_files/figure-markdown_strict/nbclust-3.png)
