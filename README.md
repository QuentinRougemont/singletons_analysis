# singletons_analysis

#script to analyse distribution of singleton after normalizing for sample size

# the distribution of singletons and rare allele can provide information about the demographic history of a given population this is one metric that I used for the study of coho salmon demography in our Plos Genetic paper see:  https://journals.plos.org/plosgenetics/article?id=10.1371/journal.pgen.1008348

this scripts performs random sampling of individuals to test for significant difference in singleton distribution and plot de results
 

## dependencies 

```Linux```  

vcftools available [here](https://github.com/vcftools/vcftools.git)  
this should be installed and in your path 
 
```R```  
this should be installed and in your path
The specific R libraries will be installed automatically if not already present

bgzip from [htslib](https://www.htslib.org/doc/bgzip.html)
this should be installed and in your path


## quick usage:

see details in script:
```./01_analyse_singletons.sh ``` to see the list of arguments and input necessary

## detailed usage: 

by running ```./01_analyse_singletons.sh``` you will see the list of arguments, these are as follows:  

 * 1. strata file : a three colomn tab separated file containing the population id in 1st colomn, individual names in 2nd colomn and a 3rd colomn with groupings information such as regional group, or any clustering level as infered for instance from a global ancestry analyses, clustering or PCA analysis
 * 2. vcf file : name of the vcffile compressed or not
 * 3. sample size: minimum sample size (should match the minimum sample size in the 
    observed dataset)
 * 4. n_rep = number of replicates to performed #optional: default = 500. This is used to estimate the variance in the distribution of singleton accross groups.

