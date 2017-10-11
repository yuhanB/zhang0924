# reshape.R
#
# Purpose:  A Bioinformatics Course:
#              R code accompanying the reshape unit.
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

# = Section 1: Abstract
#Reshaping data in R for pivot-table-like analysis of data.
#usually when we access data, the raw form is not able for us to use directly so that
#we need to change its form for further usage. One of the methods is reshaping data.
#R provides various functions (such as melt and cast) to reshape the data as table or matrix
#before analysis, making it into useful form.
#In bioinformatics, we often use in preparation of data from GEO expression profile, GO,GOA and GOSlim,etc.



# = Section 2 - Objectives
#introduce the concept of data reshaping and applications.
#Understanding why we need to reshape data.
#learn different functions or methods in R to reshape data.
#getting to know Reshape R package.

# = Section 3 - Outcomes
#ability to transform raw dataset into specific form that we like to use.
#ability to use reshape R package
#complete tasks correctly to see whether achieve above outcomes.

# = Section 4 - Prerequisites
#RPR-Data-Import (Importing data in R)
#R and Rstudio basic concepts and functions, e.g:vector, factor,data.frame etc.
# Understanding basic Table,matrix, and data frame structures.

# = Section 5: Transpose
#switch the row variables and column variables.
#R code : t() usually a matrix or data frame.
#t(data)



# = Section 6 : Reshape package

# = Section 6.1 :usually we use melt() and cast() and reshape().
#You first melt the data so that each row is unique id-variable combination then you cast the data into any shape you like.
#melt takes wide-format data and melts it into long-format data.
#cast takes long-format data and casts it into wide-format data.
#reshape can choose either way by direction argument.
install.packages("reshape")
library(reshape)
id = c(1,1,2,2)
time = c(1,2,1,2)
x1=c(5,3,6,2)
x2 = c(6,5,1,4)
mydata = data.frame(id,time,x1,x2)
#takes wide format into long-format
mdata <- melt(mydata, id=c("id","time"))
mdata
# cast(data, formula, function)
subjmeans <- cast(mdata, id~variable, mean)
timemeans <- cast(mdata, time~variable, mean)

#reshape()
reshape(mdata, idvar = "id", timevar = "variable", direction = "wide")


# = Section 6.2: reshape2
#there is reshape2 package in R with acast() and dcast() produce array/matrix or frame respectively.


#Section 6.3 : Task:
source("https://bioconductor.org/biocLite.R")

biocLite("Biobase")
library(Biobase)

biocLite("GEOquery")
library(GEOquery)

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

tmp = gset[12:17,1:6]
# Transpose the following data and reshape it from wide format into long format:
exprs(tmp)

# = Section 7.1 : Task solutions
tran_tmp = t(exprs(tmp))
Melt = melt(tran_tmp)


# [END]
