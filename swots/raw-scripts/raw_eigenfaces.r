## data https://github.com/n0acar/eigenfaces
library(pixmap)
library(magrittr)
library(rvest)
library(xml2)

## download images from url

url <- "https://github.com/n0acar/eigenfaces/tree/master/lfw_cropped_gray_eigenfaces"

pg <- xml2::read_html(url)

tst <- pg %>%  html_nodes("div") %>% html_nodes("span") %>% html_nodes("a") %>% html_text()
celebs <- tst[grep(".pgm",tst)]
base <- "https://raw.githubusercontent.com/n0acar/eigenfaces/master/lfw_cropped_gray_eigenfaces/"

for(i in 1:length(celebs)){
    download.file(paste(base, celebs[i], sep = ""), destfile  = celebs[i])
}

## read in images
imgs <- list.files("./", pattern = ".pgm", full = TRUE)
pix <- lapply(imgs,read.pnm)
par(mfrow = c(4,4), mar = c(0,0,0,0), oma = c(0,0,0,0))
for(i in 1:length(pix)){
    plot(pix[[i]])
    nm <- strsplit(strsplit(imgs[i],"//")[[1]][2],"_")[[1]]
    legend("bottom", bty = "n", paste(nm[-length(nm)],  collapse = " "))
}

## names
tst <- sapply(imgs, function(x) strsplit(strsplit(x,"//")[[1]][2],"_")[[1]])
names <-  sapply(tst, function(y) paste(y[-length(y)],  collapse = " ")); names(names) <- NULL
## rename and name elements accordingly
faces <- pix; names(faces) <- names
