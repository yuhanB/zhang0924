# myScript.R
#
# Write your notes and code experiments into this document. Save it
# from time to time - however I recommend that you do not _commit_
# your saved version.
#
# As long as you do not _commit_ this script to version control,
# you can _pull_ updated versions of the entire project from GitHub
# by using the RStudio version control interface. However, once
# you _commit_ any file in your local version, RStudio will require
# you to resolve conflicts before you can _pull_ updates.
#
# ====================================================================

#Abstract
#R split and modify is usually used in processing raw data frame downloaded from original database.
#the original data frame we've got usually not proper or too complicated for our purpose and further study
#Therefore we reduce or rearrange data set based on what we like.
# in order to make results more reliable and unbiansed, we subset the data frame and do annalysis
#seperately or apply different algorithm in different groups(split-apply-merge analysis).

#Objective
#Understanding why and when we should split and modify;
#Achieveing the ability of using split function to derive proper dataset we want.

#Outcome
#ablility to use split in proper situation
#ablility to use split correctly
#data set derived from split is proper for further usage
#completion of tasks to test the abilities above.


#Section 1: subset
# The most simplist way to split data is just get subset by known indices.
data = data.frame(x=c(1,2,3),variable = c("a","b","c"))
subset = data[1:2, 1:2]


#Section 1: split() in R
#What if the subset we want is not continuously distributed in the data or the
#data is too large to look for specific term? we use split function.
help(split)
#states usage of split.split(x,f,...)
#x is the data frame that we want to split, and f is factor or list of factors that we split based on.
#split(data,data$variable)

#Task 1:
df <- data.frame(
  x=rnorm(25),
  y=rnorm(25),
  g=rep(factor(LETTERS[1:5]), 5)
)

#question: how to split df by g?

#Section 2: split-apply-merge analysis
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

#Section 3: Train-Test strategy
# When our objective turns to prediction instead of description and sammaries of primary data, such as Maching
# Learning that will be discussed in other unit, we typically use test data to simulate the predictive model
# to see whether the model works fine or not.
#One of methods to get train and test data is useing split().
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

#Task 2:
GSE4987 <- getGEO("GSE4987", GSEMatrix =TRUE, AnnotGPL=TRUE)
length(GSE4987) # 1
GSE4987 <- GSE4987[[1]]
save(GSE4987, file="./data/GSE4987.RData")
load(file="./data/GSE4987.RData")
gset2 <- GSE4987

#produce Train subset using data from first 40 samples and Test subset from the rest sample.





#= Merge.R
#=Abstract
#merging and joining multiple dataset for preparation of analysis

#Objective
#learning how to merge two data sets for proper usage.

#Outcome
#familiarize with how to merge two data frames based on requirement
#Complete tasks correctly.

#Section 1: add columns or rows prespectively
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

#Section2 : Merge() function in R
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

#Task: merge aaTrans and nucle by their common columns
aaTrans <- newset$`amino acid transport`
nucle <- newset$nucleolus




# Section 3: combine() for eset
#combine(eset1, eset2)


#Task:
gset <- GSE3635
gset2 <- GSE4987
#since gset and gset has common featureNames, if we want to merge this two ExpressionSets
# for 6 common featureNames(YAL001C to YAL007C) with 6 samples in gset and 6 samples in gset2
#what whould you code for?



#Reshape
#Abstract
#Reshaping data in R for pivot-table-like analysis of data.
#usually when we access data, the raw form is not able for us to use directly so that
#we need to change its form for further usage. One of the methods is reshaping data.
#R provides various functions (such as melt and cast) to reshape the data as table or matrix
#before analysis, making it into useful form.
#In bioinformatics, we often use in preparation of data from GEO expression profile, GO,GOA and GOSlim,etc.


#Prerequisites
#RPR-Data-Import (Importing data in R)
#R and Rstudio basic concepts and functions, e.g:vector, factor,etc.
# Understanding basic Table,matrix, and data frame structures.


#Objectives
#introduce the concept of data reshaping and applications.
#Understanding why we need to reshape data.
#learn different functions or methods in R to reshape data.
#getting to know Reshape R package.

#Outcomes
#ability to transform raw dataset into specific form that we like to use.
#ability to use reshape R package


#Section 1: Transpose
#switch the row variables and column variables.
#R code : t() usually a matrix or data frame.
#t(data)



#Section 2.1 :
#reshape package in R : usually we use melt() and cast() and reshape().
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
reshape(mdata, idvar = "id", timevar = c("time","variable"), direction = "wide")


#Section 2.2: reshape2
#there is reshape2 package in R with acast() and dcast() produce array/matrix or frame respectively.


#Section 2.3 : Task: reshape subset tmp2 from wide format into long format



#Section 3.1 : Task solutions



# [END]

