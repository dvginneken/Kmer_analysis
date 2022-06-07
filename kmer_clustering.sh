#!/bin/bash

fastq_folder=$1
output_folder=$2

mkdir -p ${output_folder}

#Convert fastq to fasta
mkdir -p ${output_folder}/reads
if [ -z "$(ls -A ${output_folder}/reads)" ]; then
    for file in `ls -l ${fastq_folder} | grep -E ".fastq$" | awk '{print $9}' | tr "\n" " "`
    do
        base=${file##*/}
        seqtk seq -a ${fastq_folder}/${file} > ${output_folder}/reads/"${base%.*}".fasta
        echo "Converted fastq to fasta"
    done
else
   echo "Already converted fastq to fasta"
fi

#Count kmers
mkdir -p ${output_folder}/kmer_counts
if [ -z "$(ls -A ${output_folder}/kmer_counts)" ]; then
    for file in `ls -l ${output_folder}/reads | grep -E ".fasta$" | awk '{print $9}' | tr "\n" " "`
    do
        base=${file##*/}
        jellyfish count -m 3 -s 100M -t 10 -C ${output_folder}/reads/${file} -o ${output_folder}/kmer_counts/"${base%.*}"_kmer_counts.jf
        jellyfish dump ${output_folder}/kmer_counts/"${base%.*}"_kmer_counts.jf > ${output_folder}/kmer_counts/"${base%.*}"_kmer_counts_dump.fa
        echo "Counted kmers"
    done
else
   echo "Already countend kmers"
fi

#Cluster
if [ -f "${output_folder}/ClusterPlot.png" ]; then
    echo "    Already clustered"
else
    Rscript Cluster.R ${output_folder}
    echo "Saved Cluster Plot"
fi