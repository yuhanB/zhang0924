# dataPrep.R
#
# Purpose:  download a variety of yeast data for subsequent preparation and
#           crossreferencing
#
# Version:  0.2
# Date:     2017 10 04
# Author:   Boris Steipe (boris.steipe@utoronto.ca)
#
# Dependencies:
#           <List dependencies and preconditions>
#
# License: GPL-3 (https://www.gnu.org/licenses/gpl-3.0.en.html)
#
# Version history:
#    0.2  Added GOslims; add example for GOslim/Expression data set
#    0.1  First draft
#
# ToDo:
#    <list ...>
#
# ==============================================================================
 
#TOC> ==========================================================================
#TOC> 
#TOC>   Section  Title                                                  Line
#TOC> ----------------------------------------------------------------------
#TOC>   1        Packages                                                 49
#TOC>   2        Download GEO expression data from NCBI                   60
#TOC>   3        Download GO and GOA from Gene ontology                  157
#TOC>   3.1      Gene ontology (GO):                                     160
#TOC>   3.2      Gene Ontology annotations (GOA)                         214
#TOC>   3.3      GOSlim                                                  235
#TOC>   3.3.1    Sample GOslim import code                               262
#TOC>   4        Download sequences and annotations from EBI             286
#TOC>   5        Download network data from STRING                       302
#TOC>   5.1      Sample STRING import code                               329
#TOC>   6        Download ID cross references from EBI                   350
#TOC>   7        Example: selected GOslim terms plus expression data     417
#TOC>   7.1      Read GOslims                                            425
#TOC>   7.2      Add expression data                                     462
#TOC> 
#TOC> ==========================================================================
 




# =    1  Packages  ============================================================

# readr is much faster and more verstile than the read.XYZ funcions of base
# R. Caution: readr functions return tibbles.

if (!require(readr, quietly = TRUE)) {
  install.packages("readr")
  library(readr)
}


# =    2  Download GEO expression data from NCBI  ==============================
#


# Load the bioconductor package installer
source("https://bioconductor.org/biocLite.R")


if (!require(Biobase, quietly=TRUE)) {
  biocLite("Biobase")
  library(Biobase)
}


if (!require(GEOquery, quietly=TRUE)) {
  biocLite("GEOquery")
  library(GEOquery)
}

# Version info: R 3.2.3, Biobase 2.30.0, GEOquery 2.40.0, limma 3.26.8
# R scripts generated  Wed Jan 11 17:39:46 EST 2017


# Load series and platform data from GEO
gset <- getGEO("GSE3635", GSEMatrix =TRUE, getGPL=FALSE)

if (length(gset) > 1) {
  idx <- grep("GPL1914", attr(gset, "names"))
} else {
  idx <- 1
}

gset <- gset[[idx]]

# Fallback data - in case the GEO server is not working:
# GSE3635 <- gset
# save(GSE3635, file="./data/GSE3635.RData")
# load(file="./data/GSE3635.RData")
# gset <- GSE3635

# This is an "Expression Set" - cf.
# https://bioconductor.org/packages/release/bioc/vignettes/Biobase/inst/doc/ExpressionSetIntroduction.pdf

# What does this contain?
help("ExpressionSet-class")

# Print gset
gset

# Access contents via methods:
featureNames(gset)[1:20]   # rows
sampleNames(gset)[1:10]    # columns

# Access contents by subsetting:
( tmp <- gset[12:17, 1:6] )

# Access data
exprs(tmp)

# We need to understand:

# What is the data:
#  ... in each cell
#  ... in each column
#  ... in each row
#  Are values present for all columns?
#  What do the columns mean?

#  Are values present for each row?
#  Are all rows genes?
#  What identifiers are being used?
#     (cf. http://www.yeastgenome.org/help/community/nomenclature-conventions)
#  Are all rows/genes unique?
#  Are all yeast genes accounted for?


# == GSE4987: HIGHER RESOLUTION DATA, TECHNICAL REPLICATE
# https://www.ncbi.nlm.nih.gov/geo/geo2r/?acc=GSE4987

GSE4987 <- getGEO("GSE4987", GSEMatrix =TRUE, AnnotGPL=TRUE)
if (length(GSE4987) > 1) {
  idx <- grep("GPL1914", attr(GSE4987, "names"))
} else {
  idx <- 1
}
GSE4987 <- GSE4987[[idx]]
# again: ... Fallback data
# save(GSE4987, file="./data/GSE4987.RData")
# load(file="./data/GSE4987.RData")


# More questions:

# What is the relationship of these columns to the previous set?
# Can we/should we merge the two sets?


# =    3  Download GO and GOA from Gene ontology  ==============================


# ==   3.1  Gene ontology (GO):  ===============================================
#

# Download page: http://www.geneontology.org/page/download-ontology
# Data: (33.7 mb) http://purl.obolibrary.org/obo/go/go-basic.obo
# Sample: (some lines omitted, also I have escaped quotation marks in this
#          sample)
"
format-version: 1.2
data-version: releases/2017-10-04
ontology: go

[Term]
id: GO:0000001
name: mitochondrion inheritance
namespace: biological_process
def: \"The distribution of mitochondria, including the mitochondrial genome, into daughter cells after mitosis or meiosis, mediated by interactions between mitochondria and the cytoskeleton.\"
is_a: GO:0048308 ! organelle inheritance
is_a: GO:0048311 ! mitochondrion distribution

[Term]
id: GO:0000003
name: reproduction
namespace: biological_process
alt_id: GO:0019952
alt_id: GO:0050876
def: \"The production of new individuals that contain some portion of genetic material inherited from one or more parent organisms.\"
synonym: \"reproductive physiological process\" EXACT []
is_a: GO:0008150 ! biological_process

[Term]
id: GO:0000005
name: obsolete ribosomal chaperone activity
namespace: molecular_function
def: \"OBSOLETE. Assists in the correct assembly of ribosomes or ribosomal subunits in vivo, but is not a component of the assembled ribosome when performing its normal biological function.\"
comment: This term was made obsolete because it refers to a class of gene products and a biological process rather than a molecular function.
is_obsolete: true
consider: GO:0042254
consider: GO:0044183
consider: GO:0051082

[Term]
id: GO:0000009
name: alpha-1,6-mannosyltransferase activity
namespace: molecular_function
def: \"Catalysis of the transfer of a mannose residue to an oligosaccharide, forming an alpha-(1->6) linkage.\"
xref: EC:2.4.1
xref: Reactome:REACT_22295 \"Addition of a third mannose to the N-glycan precursor by Alg2, Saccharomyces cerevisiae\"
is_a: GO:0000030 ! mannosyltransferase activity

"



# ==   3.2  Gene Ontology annotations (GOA)  ===================================

# Download page: http://www.geneontology.org/page/download-annotations
# Readme: http://geneontology.org/gene-associations/readme/sgd.README
# Data: (1 mb) http://geneontology.org/gene-associations/gene_association.sgd.gz
# Note: Primary ID is SGD ID
# Sample: (some lines omitted)
"
!GOC Validation Date: 09/13/2017 $
!Submission Date: 9/13/2017
!
!gaf-version: 2.0
!Project_name: Saccharomyces Genome Database (SGD)
!URL: http://www.yeastgenome.org/
!Date: 09/13/2017 $
!
SGD	S000007287	15S_RRNA		GO:0005763	SGD_REF:S000073641|PMID:6262728	IDA		C	Ribosomal RNA of the small mitochondrial ribosomal subunit	Q0020|14s rRNA|15S_RRNA_2	gene	taxon:559292	20150612	SGD
SGD	S000007287	15S_RRNA		GO:0032543	SGD_REF:S000073641|PMID:6262728	IC	GO:0005763	P	Ribosomal RNA of the small mitochondrial ribosomal subunit	Q0020|14s rRNA|15S_RRNA_2	gene	taxon:559292	20150612	SGD
SGD	S000007288	21S_RRNA		GO:0005762	SGD_REF:S000073372|PMID:6759872	IDA		C	Mitochondrial 21S rRNA	Q0158|21S_rRNA_3|21S_rRNA_4	gene	taxon:559292	20040202	SGD
"

# ==   3.3  GOSlim  ============================================================
#
# GOSlims are a reduced set of more general GO terms that provide a low
# resolution, categorical overview of function. Yeast GOSlims are curated by
# the SGD.

# Info page: http://www.geneontology.org/page/go-slim-and-subset-guide
# Data: (3 mb) https://downloads.yeastgenome.org/curation/literature/go_slim_mapping.tab
# Note: Primary ID is yeast systematic name
# Sample: (some lines omitted)
"
YAL005C	SSA1	S000000004	P	transmembrane transport	GO:0055085	ORF|Verified
YAL007C	ERP2	S000000005	C	cytoplasm	GO:0005737	ORF|Verified
YAL007C	ERP2	S000000005	F	molecular_function	GO:0003674	ORF|Verified
YAL007C	ERP2	S000000005	P	Golgi vesicle transport	GO:0048193	ORF|Verified
YAL008W	FUN14	S000000006	C	mitochondrial envelope	GO:0005740	ORF|Verified
YAL009W	SPO7	S000000007	F	hydrolase activity	GO:0016787	ORF|Verified
YAL009W	SPO7	S000000007	F	phosphatase activity	GO:0016791	ORF|Verified
"
colNames <- c("ID",
              "name",
              "SGDId",
              "Ontology",
              "termName",
              "termID",
              "status")

# ===  3.3.1  Sample GOslim import code                          

library(readr)

scGsl <- read_tsv("./data/go_slim_mapping.tab",
                  col_names = c("ID",
                                "name",
                                "SGDId",
                                "Ontology",
                                "termName",
                                "termID",
                                "status"))

head(scGsl)
scGslTermNames <- unique(scGsl$termName)  # 169 unique terms
scGslTermNames[grep("cycle", scGslTermNames)]  # find terms containing "cycle"
# [1] "regulation of cell cycle"  "mitotic cell cycle"  "meiotic cell cycle"

# Subset IDs that have "mitotic cell cycle" annotation
sel <- scGsl$termName == "mitotic cell cycle"
scCCgenes <- unique(scGsl$ID[sel])



# =    4  Download sequences and annotations from EBI  =========================

# Check http://www.uniprot.org/uniprot/P39678 to see what information is
#    available in principle
# Primary ID is UniProt ID
# Simple access to text (or XML) files via GET:
#
# UniprotKB data is available via GET from a URL structured as:
#    http://www.uniprot.org/uniprot/<UniProtID>.txt     <<<- annotations
#    http://www.uniprot.org/uniprot/<UniProtID>.fasta   <<<- sequence only
# Try:
#    http://www.uniprot.org/uniprot/P39678.txt
#    http://www.uniprot.org/uniprot/P39678.fasta
#


# =    5  Download network data from STRING  ===================================
#
# Download page: https://string-db.org/cgi/download.pl?species_text=Saccharomyces+cerevisiae
# Data: (20.8 mb) https://string-db.org/download/protein.links.full.v10.5/4932.protein.links.full.v10.5.txt.gz
# Note: Primary ID is yeast systematic gene name with a TaxID prefix
# Note: STRING uses the generic TaxID for S. cerevisiae: 4932, not the
#         S288c specific TaxID 559292.
# Note: STRING also has a full set of sequences available, and a file of aliases
#         and accession  numbers
# Note: STRING also has a dataset "protein actions" that categorizes the
#         network edges (e.g. binding, reaction, activation ...) and identifies
#         whether this is a directed edge.

# Sample: (some lines omitted)
"
protein1 protein2 neighborhood neighborhood_transferred fusion cooccurence homology coexpression coexpression_transferred experiments experiments_transferred database database_transferred textmining textmining_transferred combined_score
4932.Q0010 4932.YPR073C 0 0 0 0 0 0 0 0 0 0 0 343 0 343
4932.Q0010 4932.YDR155C 0 0 0 0 0 0 0 0 0 0 0 419 0 418
4932.Q0010 4932.YBR055C 0 0 0 0 0 0 0 0 0 0 0 154 0 153
4932.Q0010 4932.YKR031C 0 0 0 0 0 0 0 0 0 0 0 175 0 175
4932.Q0010 4932.YMR235C 0 0 0 0 0 0 0 0 0 0 0 210 0 210
4932.Q0010 4932.Q0032 0 0 0 0 0 0 0 0 0 0 0 900 0 900
4932.YAL005C 4932.YLL024C 0 0 0 527 989 912 0 652 0 900 0 923 0 996
4932.YAL005C 4932.YPL094C 0 0 0 0 0 0 152 0 0 0 0 127 102 277
4932.YAL005C 4932.YMR214W 0 321 0 403 0 0 409 41 668 0 517 349 295 977
"

# ==   5.1  Sample STRING import code  =========================================

# Read STRING Data (needs to be downloaded from database, see URL in Notes)
STR <- read_delim("./data/4932.protein.links.full.v10.5.txt", delim = " ")

# Subset only IDs and combined_score column
STR <- STR[ , c("protein1", "protein2", "combined_score")]

# subset for approx. 100,000 highest confidence edges
STR <- STR[(STR$combined_score > 909), ]

# IDs are formatted like 4932.YAL005C ... drop the "4932." prefix
STR$protein1 <- gsub("^4932\\.", "", STR$protein1)
STR$protein2 <- gsub("^4932\\.", "", STR$protein2)
head(STR)

# Note: symmetric edges are stored twice in this data!




# =    6  Download ID cross references from EBI  ===============================

# Download page: http://www.uniprot.org/downloads
# Readme: ftp://ftp.ebi.ac.uk/pub/databases/uniprot/current_release/knowledgebase/idmapping/README
# Data: (2.1 mb) ftp://ftp.uniprot.org/pub/databases/uniprot/current_release/knowledgebase/idmapping/by_organism/YEAST_559292_idmapping_selected.tab.gz
# Note: this table contains the GOA annotated terms too.
# Sample: (lists of Identifiers truncated to three IDs)
"
Q12089	AEP3_YEAST	856102	NP_015320.1	74676520; 965088; 51012769		GO:0019898; GO:0005743; GO:0070124; GO:0016071	UniRef100_Q12089	UniRef90_Q12089	UniRef50_Q12089	UPI000006C2D4	S52526	559292			9169875; 24374639; 17322287				19843529; 11907266; 17651441
P39678	MBP1_YEAST	851503	NP_010227.1	1431055; 402793; 157830387	1BM8:A; 1L3G:A; 1MB1:A	GO:0005737; GO:0030907; GO:0000790; GO:0003677; GO:0001077; GO:0071931	UniRef100_P39678	UniRef90_P39678	UniRef50_P39678	UPI000012ED37	A47528	559292			8372350; 9169867; 24374639	X74158; Z74104; U19608; BK006938	CAA52271.1; CAA98618.1; AAC49290.1				15965243; 16264235; 12564929
"


if (!require(readr)) {
  install.packages("readr")
  library(readr)
}

# read EBI ID-mapping file "YEAST_559292_idmapping_selected.tab"
#

IN <- "./data/YEAST_559292_idmapping_selected.tab"

readLines(IN, n = 2)  # inspect first two lines

# This is a tab-separated file that does not include column names in its first
# row, some fields have multiple values which can be separated on a semicolon.
# We define the column names manually, taking the information from:
# ftp://ftp.ebi.ac.uk/pub/databases/uniprot/current_release/knowledgebase/idmapping/README

myColNames <- c("UniProtAC",
                "UniProtID",
                "GID",
                "RefSeq",
                "GI",
                "PDB",
                "GO",
                "UniRef100",
                "UniRef90",
                "UniRef50",
                "UniParc",
                "PIR",
                "taxID",
                "MIM",
                "UniGene",
                "PubMed",
                "EMBL",
                "EMBL_CDS",
                "Ensembl",
                "Ensembl_TRS",
                "Ensembl_PRO",
                "PubMed2")

yeastIDs <- read_tsv(IN, col_names = myColNames)

yeastIDs[1, ]

str(yeastIDs)

# find all genes that do not have GO annotations
noGO <- which(is.na(yeastIDs$GO))
nrow(yeastIDs)
yeastIDs[["UniProtID"]][which(is.na(yeastIDs$GO))]

# Next -> save as RData


# =    7  Example: selected GOslim terms plus expression data  =================


# Construct an example dataset from  a subset of genes for GOslim terms "DNA
# replication", "cell budding", "response to osmotic stress", and the
# "Housekeeping" genes, ALG9, TAF10, UBC6, TFC1, and ACT1. Add expression values
# from GSE3635.

# ==   7.1  Read GOslims  ======================================================

library(readr)

scGsl <- read_tsv("./data/go_slim_mapping.tab",
                  col_names = c("ID",
                                "name",
                                "SGDId",
                                "Ontology",
                                "termName",
                                "termID",
                                "status"))


# Prepare ID, name, termID, termName subset for the target genes
iD <- which(scGsl$termName == "DNA replication")
iB <- which(scGsl$termName == "cell budding")
iO <- which(scGsl$termName == "response to osmotic stress")
iH <- grep("(ALG9)|(TAF10)|(UBC6)|(TFC1)|(ACT1)", scGsl$name) # "Housekeeping"

# subset scGsl by selected rows
sel <- c(iD, iB, iO, iH)
myGOExSet <- scGsl[sel, c("ID", "name", "termName", "termID")]

# relabel Housekeeping genes
sel <- grep("(ALG9)|(TAF10)|(UBC6)|(TFC1)|(ACT1)", myGOExSet$name)
myGOExSet$termName[sel] <- "Housekeeping"
myGOExSet$termID[sel]   <- "000000"

# remove duplicated housekeeping genes
sel <- sel[which(duplicated(myGOExSet$ID[sel]))]
myGOExSet <- myGOExSet[-sel, ]

# remove all genes that are not unique to their annotated term
dups <- unique(myGOExSet$ID[duplicated(myGOExSet$ID)])
myGOExSet <- myGOExSet[! (myGOExSet$ID %in% dups), ]

# ==   7.2  Add expression data  ===============================================
load(file="./data/GSE3635.RData")

# Make a dataframe with the IDs in the first column. We use these for matching.
# Other columns are the actual expression data.
x <- cbind(data.frame(ID = featureNames(GSE3635), stringsAsFactors = FALSE),
           exprs(GSE3635))

sel <- match(myGOExSet$ID, x$ID)  # returns the
myGOExSet <- cbind(myGOExSet, x[sel, -1])  # ...not column 1: "ID"
rm(x)
rm(GSE3635)
# Construct colnames for experiments: time in minutes (cf. sample description
#    https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE3635 )
colnames(myGOExSet)[5:17] <- sprintf("t%i", seq(0, 120, by = 10))

# Done
# save(myGOExSet, file = "./data/myGOExSet.RData")
# load(file = "./data/myGOExSet.RData")





# [END]
