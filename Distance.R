library(stringr)
library(ggplot2)
library(dplyr)
library(readr)

args <- commandArgs()
path = args[6]

table = read.table(paste0(path,"/kmer_counts.tsv"), sep = "\t", header = TRUE)
table[14,"Sample"] <- "2005tm"
table <- table[table$Sample != "4-SCM",]
rownames(table) <- paste0(table$Sample, "_", table$Replicate)

dist_matrix = as.matrix(dist(table[,3:ncol(table)]))
write_tsv(as.data.frame(dist_matrix), file=paste0(path,"/DistanceMatrix.tsv"))
