#!/bin/bash
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --mail-user=M.I.vanGinneken@umcutrecht.nl

bash kmer_clustering.sh /hpc/dla_lti/dvanginneken/HaploHIV_Daphne/haplohiv4/patient4_out/ec patient4
