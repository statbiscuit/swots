
## data https://github.com/n0acar/eigenfaces
library(pixmap)

list files in a gihub directory

url <- "https://github.com/n0acar/eigenfaces/tree/master/lfw_cropped_gray_eigenfaces"

pg <- xml2::read_html(url)
library(magrittr)
library(rvest)
tst <- pg %>%  html_nodes("div") %>% html_nodes("span") %>% html_nodes("a") %>% html_text()
celebs <- tst[grep(".pgm",tst)]
base <- "https://raw.githubusercontent.com/n0acar/eigenfaces/master/lfw_cropped_gray_eigenfaces/"

for(i in 1:length(celebs)){
    download.file(paste(base, celebs[i], sep = ""), destfile  = celebs[i])
}

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
## collapse the grey matrix
faces <- lapply(pix, function(x) c(x@grey))
## each column is a face
faces <- do.call('cbind',faces)
colnames(faces) <- names

## center around mean
mean <- apply(faces, 1, mean)
mean_face <- pixmapGrey(mean, 64, 64, bbox = c(0, 0, 64, 64))
plot(mean_face)
centered <- apply(faces, 2, function(x) x - mean)
## centered imags
par(mfrow = c(4,4), mar = c(0,0,0,0), oma = c(0,0,0,0))
for(i in 1:length(pix)){
    plot(pixmapGrey(centered[,i], 64, 64, bbox = c(0, 0, 64, 64)))
    legend("bottom", bty = "n", paste(names[i], "centered", sep = " "))
}

                  
pca <- prcomp(centered)
library(ggbiplot)
ggbiplot(pca, alpha = 0.1) +
    theme(legend.direction = 'horizontal', legend.position = 'top')

## eigen faces
pcs <- pca$x
eigenfaces <- apply(pcs,2, function(x)  pixmapGrey(x, 64, 64, bbox = c(0, 0, 64, 64)))
par(mfrow = c(4,4), mar = c(0,0,0,0), oma = c(0,0,0,0))
for(i in 1:length(eigenfaces)){
    plot(eigenfaces[[i]])
    legend("bottom", bty = "n", paste("PC", i, sep = " "))
}

## reconstruction
## each face is a weighted (loadings) combintation of the eigen faces (PCs) above
## but how many PCs (eigenfaces) do we keep
plot(pca)
pca$rotation
## 2 PCs
n_pc <- 2

recon <- pixm <- list()
for (i in 1:length(names)){
    recon[[i]] <- rowSums(pca$x[,1:n_pc]%*%pca$rotation[i,1:n_pc])
    pixm[[i]] <- pixmapGrey(recon[[i]], 64, 64, bbox = c(0, 0, 64, 64))
}

## 2PC to reconstruct centered imags
par(mfrow = c(4,4), mar = c(0,0,0,0), oma = c(0,0,0,0))
for(i in 1:length(pixm)){
    plot(pixm[[i]])
    legend("bottom", bty = "n", paste(names[i], "2 PC", sep = " "))
}

### Hmm OK, what about 5
## 5 PCs
n_pc <- 5

recon <- pixm <- list()
for (i in 1:length(names)){
    recon[[i]] <- rowSums(pca$x[,1:n_pc]%*%pca$rotation[i,1:n_pc])
    pixm[[i]] <- pixmapGrey(recon[[i]], 64, 64, bbox = c(0, 0, 64, 64))
}

## 2PC to reconstruct centered imags
par(mfrow = c(4,4), mar = c(0,0,0,0), oma = c(0,0,0,0))
for(i in 1:length(pixm)){
    plot(pixm[[i]])
    legend("bottom", bty = "n", paste(names[i], "5 PC", sep = " "))
}

### Hmm OK, what about 10
## 10 PCs
n_pc <- 10

recon <- pixm <- list()
for (i in 1:length(names)){
    recon[[i]] <- rowSums(pca$x[,1:n_pc]%*%pca$rotation[i,1:n_pc])
    pixm[[i]] <- pixmapGrey(recon[[i]], 64, 64, bbox = c(0, 0, 64, 64))
}

## 10PC to reconstruct centered images
par(mfrow = c(4,4), mar = c(0,0,0,0), oma = c(0,0,0,0))
for(i in 1:length(pixm)){
    plot(pixm[[i]])
    legend("bottom", bty = "n", paste(names[i], "10 PC", sep = " "))
}
## remember this is the centered image, let's add the "mean face" to reconstruct the original
par(mfrow = c(4,4), mar = c(0,0,0,0), oma = c(0,0,0,0))
for(i in 1:length(recon)){
    plot(pixmapGrey(recon[[i]] + mean, 64, 64, bbox = c(0, 0, 64, 64)))
    legend("bottom", bty = "n", paste(names[i], "10 PC + mean", sep = " "))
}


## So arguabke we reduced 16 dim to 10... Not a huge achievement, but what about if we have 1000 images
zip <- "http://conradsanderson.id.au/lfwcrop/lfwcrop_grey.zip"
temp <- tempfile(fileext = ".zip")
download.file(zip,destfile = temp)
tst <- unzip(temp)
unlink(temp)
all_faces <- list.files("lfwcrop_grey/faces",pattern = ".pgm", full = TRUE)
set.seed(6666)
choose <- sample(1:length(all_faces), 1000, replace = FALSE)

face_set <- lapply(choose, function(x) read.pnm(all_faces[x]))

## names
col <- sapply(all_faces[choose], function(x) strsplit(strsplit(x,"faces/")[[1]][2],"_")[[1]])
names <-  sapply(col, function(y) paste(y[-length(y)],  collapse = " ")); names(names) <- NULL
names(face_set) <- names
face_data <- lapply(face_set, function(x) c(x@grey))
## each column is a face
face_data <- do.call('cbind',face_data)
colnames(face_data) <- names(face_set)
## center around mean
mean <- apply(face_data, 1, mean)
mean_face <- pixmapGrey(mean, 64, 64, bbox = c(0, 0, 64, 64))
plot(mean_face)

centered <- apply(face_data, 2, function(x) x - mean)
pca <- prcomp(centered)
pcs <- pca$x
eigenfaces <- apply(pcs,2, function(x)  pixmapGrey(x, 64, 64, bbox = c(0, 0, 64, 64)))
plot(eigenfaces[[1]])
legend("bottom", bty = "n", "PC 1")

n_pc <- 250
recon <- rowSums(pca$x[,1:n_pc]%*%pca$rotation[1,1:n_pc])
## add the "mean face" to reconstruct the original
par(mfrow = c(1,2), mar = c(0,0,0,0), oma = c(0,0,0,0))
## original
plot(face_set[[1]])
