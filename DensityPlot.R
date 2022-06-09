library(stringr)
library(ggplot2)
library(dplyr)

args <- commandArgs()
path = args[6]


table = read.table(paste0(path,"/kmer_counts.tsv"), sep = "\t", header = TRUE)
table[14,"Sample"] <- "2005tm"
table <- table[table$Sample != "4-SCM",]
rownames(table) <- paste0(table$Sample, "_", table$Replicate)

dist_matrix = as.matrix(dist(table[,3:ncol(table)]))

repl <- numeric()
non_repl <- numeric()

for (row_nr in seq(1:nrow(dist_matrix))){
  sample = str_sub(rownames(dist_matrix)[row_nr], start=1,
                end=nchar(rownames(dist_matrix)[row_nr])-2)
  repl <- c(repl, dist_matrix[row_nr,str_sub(colnames(dist_matrix), start = 1,
                                   end = nchar(rownames(dist_matrix)[row_nr])-2)==sample])
  non_repl <- c(non_repl, dist_matrix[row_nr,str_sub(colnames(dist_matrix), start = 1,
                                   end = nchar(rownames(dist_matrix)[row_nr])-2)!=sample])
}
repl <- repl[repl!=0]
non_repl <- sample(non_repl, size=length(repl), replace=FALSE)

df = data.frame(distance=c(repl, non_repl), replicate=c(rep("Replicate", length(repl)), 
                                                   rep("Non-replicate", length(non_repl))))

dummy <- df %>%
  group_by(replicate) %>%
  summarize(mean = mean(distance))


ggplot(df, aes(x = distance, fill = replicate)) + 
  geom_density(alpha = 0.5) +
  geom_vline(data = dummy, aes(xintercept = mean, color = replicate))
ggsave(paste0(path, "/DensityPlot.png"))
