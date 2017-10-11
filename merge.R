# merge.R
#
# Purpose:  A Bioinformatics Course:
#              R code accompanying the merge unit.
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
#merging and joining multiple dataset for preparation of analysis
#last step in split-apply-merge analysis


# = 2 Section - Objective
#learning funtions in R to merge two data sets for proper usage.
#Understanding why we merge datasets.


# = 3 Section - Outcomes
#Ability to use merge in proper situation.
#Ability to merge two data frames properly based on requirement
#Complete tasks correctly.



# = 4 Section Pre-requisite
#RPR-Data-Import (Importing data in R)
#R and Rstudio basic concepts and functions, e.g:vector, factor and data.frame() etc.
# Understanding basic Table,matrix, and data frame structures.

# = 5.1 Section : add columns or rows prespectively
#adding a single column from 1 to 7
#cbind for add column, rbind for add rows
m <- cbind(1, 1:7)
m

#insert a column
m <- cbind(m, 8:14)[, c(1, 3, 2)]
m
# combination of rbind and cbind
cbind(0, rbind(1, 1:3))

# add some names
cbind(I = 0, X = rbind(a = 1, b = 1:3))

# Be careful that if you want to use rbind(data frame A, data Frame B), you need
# to make sure that they have the same variables.


# = 5.2 Section: Merge() function in R
#What if two frames does not have the same varibales? we use merge() to add them together.
help(merge)

#merge(x,y,..)
#x, y are frames to be merged
#by, by.x, by.y specification of column used for merging
#all. all.x all.y  If True then extra row/column will be extra rows will be added to the output,
#one for each row in x that has no matching row in y.
#These rows will have NAs in those columns that are usually filled with values from y.
#The default is FALSE, so that only rows with data from both x and y are included in the output.

#merge(frameA,frameB, by="ID") merged by common column ID
#merge(frameA,frameB,by=c("ID","Country")) merged by ID and Country

# = 5.2.1 Task 1: merge aaTrans and nucle from Yeast GOSlim by their common columns

# prepare aaTrans and nucle from GOSlim of yeast
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
#derive aaTrans and nucle using split
aaTrans <- newset$`amino acid transport`
nucle <- newset$nucleolus

# merge aaTrans and nucle:


# = 6 Section : combine() for eset
#combine(eset1, eset2)


# = 6.1 Task 2:
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


GSE4987 <- getGEO("GSE4987", GSEMatrix =TRUE, AnnotGPL=TRUE)
length(GSE4987) # 1
GSE4987 <- GSE4987[[1]]
save(GSE4987, file="./data/GSE4987.RData")
load(file="./data/GSE4987.RData")
gset2 <- GSE4987
#since gset and gset has common featureNames, if we want to merge this two ExpressionSets
# for 6 common featureNames(YAL001C to YAL007C) with 6 samples in gset and 6 samples in gset2
#what whould you code for?


# = 7 Section :Application in large-scale analysis
#An increasing amount of microarray gene expression data sets is available through public repositories such as NCBI GEO.
#The public repositories might contain the necessary clues for the discovery of new findings,
#leading to the development of new treatments or therapies
#Their huge potential in making new findings is yet to be unlocked by making them available for large-scale analysis.
#Integration of this vast amount of data originating from different but independent studies
#could be beneficial for the discovery of new biological insights
#by increasing the statistical power of gene expression analysis.



# = 8  Task solutions

# = 8.1  Task 1: merge(aaTrans,nucle,all=TRUE, by = c("ID","name","SGDId","Ontology","termName","termID"))

# = 8.2  Task 2:
tmp = gset[12:17,1:6]
tmp2 = gset2[12:17, 1:6]
combine(tmp, tmp2)


# [END]
