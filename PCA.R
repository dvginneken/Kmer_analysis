library(tidyr)
library(stringr)
library(microseq)
library(ggplot2)
library(FactoMineR)

path = "C:/Users/Daphne/OneDrive - UMC Utrecht/Kmer Clustering/"

count_table <- data.frame()
filelist <- list.files(path, pattern = ".mer_counts_dump.fa")

for (x in filelist){
  data = readFasta(paste0(path,x))
  sample = str_split(x, pattern = "_")[[1]][1]
  repl = str_sub(sample, start = -1)
  sample = str_sub(sample, start = 3, end = nchar(sample)-1)
  df = data.frame(sample, repl)
  colnames(df) <- c("Sample", "Replicate")
  data_t = data.frame(t(data))
  colnames(data_t) <- data_t[2,]
  data_t <- data_t[1,]
  new_table = cbind(df, data_t)
  count_table = rbind(count_table, new_table)
  rownames(count_table) <- c()
}


#PCA
pca_2 = PCA(sapply(count_table[, 3:66], as.numeric), ncp=2)
count_table_pca = cbind(count_table, pca_2$ind$coord)

png(paste0(path, "PCA_plot.png"))
ggplot(count_table_pca, aes(x = Dim.1, y = Dim.2, color = Sample)) +
  geom_point()
dev.off()
