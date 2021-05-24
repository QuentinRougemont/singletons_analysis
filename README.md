# singletons_analysis

#script to analyse the distribution of singletons after normalizing for sample size

The distribution of singletons and rare allele can provide information about the demographic history of a given population this is one metric that I used for the study of coho salmon demography in our Plos Genetics paper see:  https://journals.plos.org/plosgenetics/article?id=10.1371/journal.pgen.1008348

These scripts compute the distribution of singletons at each sampling locality according to the smallest sample size in your populations.
To get an estimate of the uncertainty around this analyses it performs random sampling of individuals to test for significant difference in singleton distribution among biologically meaningful group (e.g. clusters inferred from a PCA or clustering algorithm).
Then it plot de results  

/!\ Beware that you need some variance in the distribution of sample size. Otherwise, the same individuals will be repeatedly sampled.  

/!\ Beware that data will not be independant.  

Here the smallest sample size was 13 and the median sample size was 36.


## dependencies 

```Linux```  

vcftools available [here](https://github.com/vcftools/vcftools.git)  
this should be installed and in your path 
 
```R```  
this should be installed and in your path  

The specific R libraries will be installed automatically if not already present in your R environment

bgzip from [htslib](https://www.htslib.org/doc/bgzip.html) 

this should be installed and in your path


## quick usage:

see details in script:
```./01_analyse_singletons.sh ``` to see the list of arguments and input necessary

## detailed usage: 

By running ```./01_analyse_singletons.sh``` you will see the list of arguments, these are as follows:  

 * 1. strata file : a three colomn tab separated file containing the population id in 1st colomn, individual names in 2nd colomn and a 3rd colomn with groupings information such as regional group, or any clustering level as infered for instance from a global ancestry analyses, clustering or PCA analysis
 * 2. vcf file : name of the vcffile compressed or not
 * 3. sample size: minimum sample size (should match the minimum sample size in the 
    observed dataset)
 * 4. n_rep = number of replicates to performed #optional: default = 200. This is used to estimate the variance in the distribution of singleton accross groups.

the script ```./01_analyse_singletons.sh``` will run automatically the two Rscript. 
 
The first script ```02.random_sampling.R ```  will simply produce random list of individuals according to the smallest sample size.
This list will be used randomly produce vcffile from which singleton will be computed. 

After reshaping the result the script ```03.plot_distrib.R``` will test for significant differences in the distribution of singleton among the cluster provided in the strata file.  
For now I only perform a simple wilcoxon test and kruskall wallis test because the data are not independant

ultimately a graph like this will be produced:  
![example_graph](https://github.com/QuentinRougemont/singletons_analysis/blob/main/pictures/example_plot.png)  

Interestingly the Alaskan samples displayed a high number of singleton after accounting for sample_size. A pattern that was not obvious at first look.
 

## To do:
Customize ggplot script choice of colors for any number of groups
