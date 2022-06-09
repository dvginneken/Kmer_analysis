library(tidyr)
library(dplyr)
library(stringr)
library(microseq)
library(ggplot2)
library(FactoMineR)

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
  count_table = rbind(count_table, new_table)
  rownames(count_table) <- c()
}

write.table(count_table, file=paste0(path,"/kmer_counts.tsv"), sep="\t", row.names=FALSE)

#Kmeans clustering
k = kmeans(sapply(count_table[,3:ncol(count_table)], as.numeric), centers = 21)
table <- cbind(count_table, k$cluster)

#Plot the clustering results
table1 <- dplyr::filter(table, Replicate==1)
table2 <- dplyr::filter(table, Replicate==2)
table1 <- table1[,c(1,ncol(table1))]
colnames(table1) <- c("Sample", "Replicate1")
table2 <- table2[,c(1,ncol(table2))]
colnames(table2) <- c("Sample", "Replicate2")
data = dplyr::inner_join(table1, table2, by="Sample")
ggplot(data, aes(x=Replicate1, y=Replicate2)) +
  geom_point(size=5) +
  geom_abline(intercept = 0, slope = 1) +
  xlim(0,22) + ylim(0,22) +
  labs(title = "Assigned cluster for sample replicates",
       x="Cluster Replicate 1", y="Cluster Replicate 2")
ggsave(paste0(path, "/ClusterPlot.png"))