library(tidyr)
library(dplyr)
library(stringr)
library(microseq)

args <- commandArgs()
path = args[6]

#Create count table
count_table <- data.frame()
filelist <- list.files(paste0(path,"/kmer_counts"), pattern = ".mer_counts_dump.fa")
for (x in filelist){
  data = readFasta(paste0(path,"/kmer_counts/",x))
  sample = str_split(x, pattern = "_")[[1]][1]
  repl = str_sub(sample, start = -1)
  sample = str_sub(sample, start = 3, end = nchar(sample)-1)
  df = data.frame(sample, repl)
  colnames(df) <- c("Sample", "Replicate")
  data_t = data.frame(t(data))
  colnames(data_t) <- data_t[2,]
  data_t <- data_t[1,]
  new_table = cbind(df, data_t)
  count_table = dplyr::bind_rows(count_table, new_table)
  rownames(count_table) <- c()
}
write.table(count_table, file=paste0(path,"/kmer_counts.tsv"), sep="\t", row.names=FALSE)


#Calculate Euclidean distance between each point
EuclideanDistance <- function(vect1, vect2) sqrt(sum((vect1 - vect2)^2))

for (row_nr in seq(1:nrow(count_table)){
    row = count_table[row_nr,]
    d_vec_repl = numeric()
    d_vec_nonrepl = numeric()
    rem = count_table[-row_nr, ]
    for (row_nr2 in seq(1:nrow(rem)){
	row2 = rem[row_nr2,]
        d = EuclideanDistance(as.numeric(count_table[row_nr, 3:ncol(count_table)]),
                              as.numeric(rem[row_nr2, 3:ncol(rem)]))
        if (row$Sample == row2$Sample){
        d_vec = c(d_vec, d)
    }
    
}