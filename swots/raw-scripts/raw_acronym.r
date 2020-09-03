## paper "Meta-Research: The growth of acronyms in the scientific literature"
## https://elifesciences.org/articles/60080
## Data: https://github.com/agbarnett/acronyms
## Aim: to recreate https://github.com/agbarnett/acronyms/tree/master/animation
## interview: https://www.rnz.co.nz/national/programmes/sunday/audio/2018760724/from-dna-to-rna-science-s-unhealthy-obsession-with-acronyms

## ---- raw-to-processed

## download all acronym files from github/agbarnett
num_files <- 1:30
base <- "https://github.com/agbarnett/acronyms/blob/master/data/acronyms"
end <- ".rds?raw=true"

urls <- paste(base,num_files,end,sep = "")
for(i in num_files){
    download.file(urls[i], destfile = paste("acronyms",i,".rds",sep = ""))
}

## matching pmids (file download takes a while)
url <- "https://ftp.ncbi.nlm.nih.gov/pub/pmc/PMC-ids.csv.gz"
download.file(url,destfile = "PMC-ids.csv.gz")
R.utils::gunzip("PMC-ids.csv.gz")

## read in files
## pmid
pmc <- read.csv("PMC-ids.csv")
## acronym files
files <- list.files(".", pattern = ".rds")
acronyms <- lapply(files, readRDS)

## match pmids
library(dplyr)
acrons <- lapply(acronyms,inner_join,pmc,by = c("pmid" = "PMID"))

## filter for title alone
titles <- lapply(acrons, filter, source == "Title")
## combine
titles <- do.call("rbind",titles)
## only 1990 >= & < 2020 & split by year
titles <- filter(titles, Year < 2020 & Year >= 1990)
titles <- split(titles, titles$Year)
## keep only the 10 top acronyms for each year
top_twenty <- list()
for(i in 1:length(titles)){
    nms <- names(sort(table(titles[[i]]$acronyms), TRUE))[1:20]
    top_twenty[[i]] <- filter(titles[[i]], acronyms %in% nms)
}
names(top_twenty) <- names(titles)
save(top_twenty, file = "top_twenty.RData")
