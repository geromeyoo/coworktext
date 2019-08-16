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
library(readr)
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
## Altered Abstracts from original
########################################
## Genome sequencing in microfabricated high-density picolitre reactors
## - Author last name plant, no plant in abstracts
##
## Addaptive radiation optimization for climate adaptive building facade design strategy
## - no plant in abstracts
##
## Removed and altered with other texts
## Application of Fuzzy Comprehensive Evaluation on COGAG Power Plant of Performance
## Extension Study on Electricity Market of Power Plant Investment Environment
########################################
## open files
########################################
# Power
########################################
# making directory as an object
# setwd("C:\\Users\\gerom\\Desktop\\collabo\\coworktext")
setwd(".\\injection abstracts\\power")
src_dir = getwd()
# src_dir
# listing up name of files in the directory => object
src_file <- list.files(src_dir) # list
filecount = sum(nzchar(src_file, keepNA = FALSE))
title <- rep(NA,filecount)
description <- rep(NA,filecount)
inject.data <- data.frame(title,description)

# put data into data.frame : inject.data
for (i in 1:filecount){
  inject.data[i,1] = src_file[i]
}
for (i in 1:filecount){
  inject.data[i,2] = read_file(inject.data[i,1])
}
inject.data
########################################
# Tree
########################################
# making directory as an object
setwd("..\\")
setwd(".\\tree")
src_dir = getwd()
# src_dir
# listing up name of files in the directory => object
src_file <- list.files(src_dir) # list
filecount = sum(nzchar(src_file, keepNA = FALSE))
title <- rep(NA,filecount)
description <- rep(NA,filecount)
inject.data1 <- data.frame(title,description)

# put data into data.frame : inject.data1
for (i in 1:filecount){
  inject.data1[i,1] = src_file[i]
}
# behind .txt removal needed
for (i in 1:filecount){
  inject.data1[i,2] = read_file(inject.data1[i,1])
}
inject.data1

# bind
inject.data <- rbind(inject.data,inject.data1)
inject.data

# environment clearing
rm(title)
rm(description)
rm(filecount)
rm(src_dir)
rm(src_file)
rm(inject.data1)

########################################
## Updated till here
########################################

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
