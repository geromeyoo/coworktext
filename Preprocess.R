# cleaning up environment
rm(list=ls())

########################################
# download JSS data
########################################
if(!nzchar(system.file(package = "corpus.JSS.papers"))) {
  templib <- tempfile(); dir.create(templib)
  install.packages("corpus.JSS.papers", lib = templib,
                   repos = "https://datacube.wu.ac.at/",
                   type = "source")
  data("JSS_papers", package = "corpus.JSS.papers",
       lib.loc = templib)
} else {
  data("JSS_papers", package = "corpus.JSS.papers")
}

########################################
##remove greeks &subscripts, etc.
########################################
library(tm)
library(XML)

########################################
## only going to use ASCII characters
########################################

JSS_papers <- JSS_papers[sapply(JSS_papers[, "description"],
                                Encoding) == "unknown",]

########################################
## load JSS paper abstract
########################################

### problmen is that the source is from JSS 
### so that it only contains statistical contextx
### i.e. not many "plant" occur

JSS_papers.data.frame = data.frame(JSS_papers)
data = data.table::data.table(title = JSS_papers.data.frame$title,
                              description = JSS_papers.data.frame$description)

rm(JSS_papers)
rm(JSS_papers.data.frame)
########################################
## open files
########################################

# making directory as an object
src_dir <- c("~\\abstracts\\jss")
src_dir

# listing up name of files in the directory => object
src_file <- list.files(src_dir) # list
src_file

title <- rep(NA,8)
description <- rep(NA,8)
inject.data <- data.frame(title,description)

for (i in 1:8){
  inject.data[i,1] = src_file[i]
}

inject.data

setwd("E:\\Desktop\\Abstracts\\Injection Abstracts")  

library(readr)
txt01 <- read_file("01.txt")
# Sequential Probability Ratio Test for Nuclear Plant Component Surveillance
txt02 <- read_file("02.txt")
# The Cognitive and Economic Value of a Nuclear Power Plant in Korea
txt03 <- read_file("03.txt")
# Human Reliability Analysis for Digitized Nuclear Power Plants: Case Study on the LingAo II Nuclear Power Plant
txt04 <- read_file("04.txt")
# Innovative Nuclear Power Building Arrangement in Consideration of Decommissioning
txt05 <- read_file("05.txt")
# Plant behaviour from human imprints and the cultivation of wild cereals in Holocene Sahara 
txt06 <- read_file("06.txt")
# Farming with crops and rocks to address global climate, food and soil security
txt07 <- read_file("07s.txt")
# A genome for gnetophytes and early evolution of seed plants
txt08 <- read_file("08.txt")
# Enhanced plant growth by siderophores produced by plant growth-promoting rhizobacteria

inject.data[1,2] <- txt07
inject.data[2,2] <- txt08
inject.data[3,2] <- txt06
inject.data[4,2] <- txt03
inject.data[5,2] <- txt04
inject.data[6,2] <- txt05
inject.data[7,2] <- txt01
inject.data[8,2] <- txt02

## modification made
# making directory as an object

setwd(".\\abstracts\\power")
dir = getwd()
src_dir <- c(dir)
src_dir

# listing up name of files in the directory => object
src_file <- list.files(src_dir) # list
src_file

title <- rep(NA,8)
description <- rep(NA,8)
inject.data <- data.frame(title,description)
rm(title)
rm(description)

for (i in 1:8){
  inject.data[i,1] = src_file[i]
}
# behind .txt removal needed

for (i in 1:8){
  inject.data[i,2] = read_file(inject.data[i,1])
}
inject.data
##




########################################
## Corpus make
########################################
corpus <- rbind(data,inject.data)


########################################
## Type chane of column to save
########################################
typeof(corpus$title)
typeof(corpus$description)

library(dplyr)
title <- corpus$title %>% unlist()
description <- corpus$description %>% unlist()

corpusr <- cbind(title,description)

########################################
## Shared Tokenization
########################################
for (i in dim(corpusr)[1]){
  corpusr[i,2] <- as.character(corpusr[i,2])
  corpusr[i,2] <- removeNumbers(corpusr[i,2])
  corpusr[i,2] <- removePunctuation(corpusr[i,2])
  corpusr[i,2] <- tolower(corpusr[i,2])
}
########################################
## Save Corpus
########################################
setwd("E:\\Desktop\\Abstracts")  
write.csv(corpusr,file="corpus.csv",row.names=FALSE)


########################################
# still working
# may use for dtm
########################################
data2 = removeWords(data2, words = c(stopwords("SMART"),stopwords("en"), 
                                     "due", "vol"))

sppech = stemDocument(speech)

speech = stripWhitespace(speech)

speech = sapply(speech, function(x) strsplit(x, split = " "))

speech = sapply(speech, function(x) x[nchar(x)>2])

########################################
########################################

########################################
## rewrite the file for python
########################################
setwd("E:\\Desktop\\Abstracts")
corpus <- read.csv('corpus.csv')
corpus <- data.frame(corpus)
for(i in dim(corpus)[1]){
  corpus[i,2] <- as.character(corpus[i,2])
}
data <- as.character(corpus[,2])

setwd('E:\\Desktop\\Abstracts')
filed <- file("outputpy.txt")
writeLines(data,filed)
close(filed)
