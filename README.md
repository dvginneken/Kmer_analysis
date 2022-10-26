# Kmer Analysis
Calculate the euclidean distance of k-mer occurences between reads of replicates and non-replicates.

### How to run these scripts
Create and activate the conda environment:  
`conda env create -f environment.yaml`  
`conda activate kmer-analysis` 

Count the k-mer occurences:  
`bash kmer_count.sh /hpc/.../haplohiv_out/ec [output directory]`  

Calculate Euclidean distance and create density plots:  
`Rscript DensityPlot.R [output directory]`
