## Overview

This repo contains ``R` scripts to illustrate some fundamental statistical concepts (e.g., maximum likelihood, pca, hypothesis testing & more). These are meant to supplement classroom materials only and on occasion go hand in hand with specific examples from the STATS210 course (Statistical Theory) at the University of Auckland.

Feel free to fork and modify the repo :-)


## Examples

### Principal component analysis

![](figs/pca.gif)

![](figs/perp.gif)

### Hypothesis testing (coin flip)

![](figs/binomial_cat.gif)

### Linear models & line of best fit

This works in conjunction with a Google Apps Script I made that allows students to draw their best line of fit online (mouseclicks only) and submit it to a shared Google SHeet. The `R` script then pulls all the start and end points of their drawn lines and creates a gif shouing the distribution of all their estimates

![](figs/lm_demo.gif)


### Illustrating things I found a few students struggled with...

#### Distribution shape as sample size increases and variance

![](figs/hist.gif]

![](figs/var.gif)

#### The p..(), d..(), q..(), r..() functions in `R`

![](figs/pdqr.r)

#### The difference between conditioning and intersection

![](figs/conditional_vs_intersection.r)