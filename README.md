## Overview

This repo contains `R` scripts to illustrate some fundamental statistical concepts (e.g., maximum likelihood, pca, hypothesis testing & more). These are meant to supplement classroom materials and go hand in hand with specific examples from the STATS210 course (Statistical Theory) at the University of Auckland. However, feel free to fork and modify for your own use or just download the gifs :-)


## Examples

### Principal component analysis

![](gifs/pca.gif)

![](gifs/perp.gif)

*[`R`script can be found here](https://github.com/cmjt/statbiscuits/blob/master/pca.r)*

### Hypothesis testing (coin flip)

![](gifs/binomial_cat.gif)

*[`R`script can be found here](https://github.com/cmjt/statbiscuits/blob/master/weird_coin.r)*

### Linear models & line of best fit

This works in conjunction with a Google Apps Script I made that allows students to draw their best line of fit online (mouseclicks only) and submit it to a shared Google Sheet. The `R` script then pulls all the start and end points of their drawn lines and creates a gif shouing the distribution of all their estimates.


[![](figs/app_pic.png)]("https://script.google.com/macros/s/AKfycbw2qx1b8iTZZXY5-aaaaGp76XiutxS1iuCFmL24IyBz6GACuSML/exec")

*[Code for this Google Scripts App can be found here](https://script.google.com/d/1hFga6ECOLzPkw45KY5LHGYj-VGaMtWh5d1n9cV5y3RhOk1G2dGNlpJct/edit?usp=sharing) and the [exported line ends are available here](https://docs.google.com/spreadsheets/d/1vn7oGtw06KJazYx-F2nReFvoeqONrskNehGkJpeugXw/edit?usp=sharing)*

![](gifs/lm_demo.gif)

*[`R` side code can be found here](https://github.com/cmjt/statbiscuits/blob/master/app_lm_plot.r)*

### Maximum likelihood (binomial example)

![](gifs/mle.gif)

### Illustrating things I found a few students struggled with...

#### Distribution shape as sample size increases and variance

![](gifs/hist.gif)

*[`R`script can be found here](https://github.com/cmjt/statbiscuits/blob/master/hist.r)*

![](gifs/var.gif)

*[`R`script can be found here](https://github.com/cmjt/statbiscuits/blob/master/var.r)*

#### The p..(), d..(), q..(), r..() functions in `R`

![](gifs/pdqr.png)

*[`R`script can be found here](https://github.com/cmjt/statbiscuits/blob/master/pdqr.r)*

#### The difference between conditioning and intersection

![](gifs/conditional_vs_intersection.png)

*[`R`script can be found here](https://github.com/cmjt/statbiscuits/blob/master/conditional_vs_intersection.r)*