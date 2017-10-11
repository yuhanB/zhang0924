# RPR-Data-Split.R
#
# Purpose:  A Bioinformatics Course:
#              R code accompanying the split unit.
#
# Version:  0.1
#
# Date:     2017  Oct  10th
# Author:   Yuhan Zhang(yuhan.zhang@mail.utoronto.ca)
#
# Versions:
#           0.1    (Describe ...)

#
# TODO:
#
#
# == DO NOT SIMPLY  source()  THIS FILE! =======================================
#
# If there are portions you don't understand, use R's help system, Google for an
# answer, or ask your instructor. Don't continue if you don't understand what's
# going on. That's not how it works ...
#
# ==============================================================================

# = 1 Section - Abstract

#R split and modification is usually used in processing raw data frame downloaded from original database.
#the original data frame we've got usually not proper or too complicated for our purpose and further study
#Therefore we reduce or rearrange data set based on requirement.
# in order to make results more reliable and unbiased, we subset the data frame and do annalysis
#seperately or apply different algorithm in different groups(split-apply-merge analysis).


# = 2 Section - Objective
#Understanding why and when we should split and modify dataset;
#Achieveing the ability of using split function to derive proper dataset we want.


# = 3 Section - Outcome
#ablility to use split in proper situation
#ablility to use split correctly
#data set derived from split is proper for further usage
#completion of tasks correctly to test the abilities above.


# = 4 Section Pre-requisite
#RPR-Data-Import (Importing data in R)
#R and Rstudio basic concepts and functions, including :vector, factor and data.frame(), row and col etc.
# Understanding basic Table,matrix, and data frame structures.



# = 5.1 Section : subset
# The most simplist way to split data is just get subset by known indices.
data = data.frame(x=c(1,2,3),variable = c("a","b","c"))
subset = data[1:2, 1:2]


# = Section 5.2: split() in R
#What if the subset we want is not continuously distributed in the data or the
#data is too large to look for specific term? we use split function.
help(split)
#states usage of split.split(x,f,...)
#x is the data frame that we want to split, and f is factor or list of factors that we split based on.
#split(data,data$variable)

# = Section 5.2.1 Task1:
df <- data.frame(
  x=rnorm(25),
  y=rnorm(25),
  g=rep(factor(LETTERS[1:5]), 5)
)

#question: how to split df by g?
#code below:



# = Section 6: split-apply-merge analysis
# Many data analysis problem in bioinformatics involve split-apply-merge strategy,which is
# breaking up a big problem into multiple pieces and perform operation/functions/algorithms
#in each piece and then combine them together. for this unit, we only concern split part.
#here is an example:
install.packages("readr")
library(readr)
# Load the bioconductor package installer
source("https://bioconductor.org/biocLite.R")

biocLite("Biobase")
library(Biobase)

biocLite("GEOquery")
library(GEOquery)

#Download Yeast GOSlim
url <- "https://downloads.yeastgenome.org/curation/literature/go_slim_mapping.tab"
download.file(url, destfile = "./data/go_slim_mapping.tab", method = "libcurl")
scGsl <- read_tsv("./data/go_slim_mapping.tab")
colNames <- c("ID",
              "name",
              "SGDId",
              "Ontology",
              "termName",
              "termID",
              "status")

#split scGsl into multiple groups by its termName
newset = split(scGsl, scGsl$termName)
#choose one group that annotation is amino acid transport as the interest for further analysis
aaTrans <- newset$`amino acid transport`
#apply some function in aaTrans

# = Section 6.1 Task 2: split scGsl into multiple groups by "Ontology" and choose annotation P.


# = Section 7: Train-Test strategy
# When our objective turns to prediction instead of description and sammaries of primary data, such as Maching
# Learning that will be discussed in other unit, we typically use test data to simulate the predictive model
# to see whether the model works fine or not.
#One of methods to get train and test data is using split.
gset <- getGEO("GSE3635", GSEMatrix =TRUE, getGPL=FALSE)

if (length(gset) > 1) {
  idx <- grep("GPL1914", attr(gset, "names"))
} else {
  idx <- 1
}

gset <- gset[[idx]]
GSE3635 <- gset
save(GSE3635, file="./data/GSE3635.RData")
load(file="./data/GSE3635.RData")
gset <- GSE3635
gset  #print gset

# Train subset from sample "GSM81064" to "GSM81073"
(train = gset[,1:10])
#TEst subset from rest sample
(test = gset[,11:13])

# = Section 7.1 Task 3:
GSE4987 <- getGEO("GSE4987", GSEMatrix =TRUE, AnnotGPL=TRUE)
length(GSE4987) # 1
GSE4987 <- GSE4987[[1]]
save(GSE4987, file="./data/GSE4987.RData")
load(file="./data/GSE4987.RData")
gset2 <- GSE4987

#produce Train subset using data from first 40 samples and Test subset from the rest sample.




# = 8  Task solutions


# = 8.1  Task 1: new <- split(df,g)

# = 8.2  Task 2:
onto <- split(scGsl, scGsl$Ontology)
Ponto <- onto$P

# = 8.3 Task 3:
train2 = gset2[,1:40]
test2  = gset2[,41:50]



# = 9 Section Resources
#https://www.rdocumentation.org/packages/base/versions/3.4.1/topics/split
#https://medium.com/fuzz/machine-learning-classification-models-3040f71e2529
# [END]
