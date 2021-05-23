#!/bin/bash

#date: 15-05-2020
#Author: QR
#Description:
#script to analyse the distribution of singletons accross mutliple 
#populations corrected by sample size.
#generate several random dataset by random sampling of individual to
#test for significant difference in the singleton distribution among
#multiple individuals 
#script used in our plos genetics paper on the load of coho salmon

#arguments
#if [ $# -ne 4 ]; then
if [ $# -lt 3 ] || [ $# -gt 4 ]; then
    echo "umber of arguments must  3 or 4"
    echo "USAGE: $0 strata vcf sample_size n_rep "
    echo "Expecting the following values on the command line, in that order:"
    echo "1) strata: tab separated file containing the population id in first colomn, individual names in 2nd colomn and a third colomn with groupings information"
    echo "2) vcf: name of the vcffile"
    echo "3) sample size: minimum sample size (should match the minimum sample size in the 
    observed dataset"
    echo "4) n_rep = number of replicate #optional: default = 500"
    exit 1
else
    strata=$1      #stata file name
    vcf=$2         #vcf file name
    sample_size=$3 #min number of ind.
    n_rep=$4       #e.g. 500 replicate
fi

if [ -z "$n_rep" ] ; then
    n_rep=20
fi

    echo "strata file is $strata"
    echo "vcf fime is $vcf"
    echo "sample size is $sample_size"
    echo "number of replicate is $n_rep"


#ici verifier la compression du vcf sinon le compression avec bgzip
if file --mime-type "$vcf" | grep -q gzip$; then
  echo "$vcf is gzipped"
else
  echo "$vcf is not gzipped"
  echo "will compress with bgzip"
  bgzip "$vcf"
  vcf=$( echo "$vcf".gz )
  echo "compression is done"
fi

vcf=$(echo $(readlink -f $vcf ))
strata=$(echo $(readlink -f $strata ))

echo -e "\n"
echo -e "perform random sapling \n"

Rscript 02.random_sampling.R $strata $sample_size $n_rep

# then create architecture:
mkdir BOOT
mv random_sample.*.txt BOOT
cd BOOT
mkdir COUNTS
for i in $(seq $n_rep) ; do mkdir random.$i ; done 

echo -e "create dataset\nand compute singletons distributions"

for i in $(seq 1 "$n_rep") ; do
    vcftools --gzvcf "$vcf" \
    --keep random_sample.$i.txt \
    --out random.$i/sample.$i --recode --recode-INFO-all --mac 1

     vcftools --vcf random.$i/sample.$i.recode.vcf --singletons --out singletons.$i
     sed 1d singletons.$i.singletons | \
     awk '$3=="S" {print $5}' |\
     cut -d "_" -f 1 |\
     sort |\
     uniq -c |awk '{print $1}' > COUNTS/singletons_counts.$i.txt

done 

sed 1d singletons.1.singletons | \
   awk '$3=="S" {print $5}' |\
   cut -d "_" -f 1 |sort |uniq -c |\
   awk '{print $2}' > COUNTS/pop.vector


cd COUNTS
paste pop.vector single*txt >> ../ALL.txt
cd ../
gzip ALL.txt.gz 
#then perform plot of the distribution and test for differences in R:

Rscript ./03_plot_distrib.R  $strata

echo "analysis done "
echo "runn timing is time"
