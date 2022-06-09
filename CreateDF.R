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
count_table[is.na(count_table)] <- 0
write.table(count_table, file=paste0(path,"/kmer_counts.tsv"), sep="\t", row.names=FALSE)