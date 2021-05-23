#!/usr/bin/env Rscript

#script to randomly sample individuals

#library
if("dplyr" %in% rownames(installed.packages()) == FALSE)
    {install.packages("data.table", repos="https://cloud.r-project.org") }

library(dplyr)
#check if install, else install

#argument
argv <- commandArgs(T)

strata <- argv[1] #argument provided automatically to the Rscript
n <- argv[2]      #idem
n_rep <- argv[3]  #idem

df <- read.table(strata)[,c(1:2)]
colnames(df) <- c("ID","IND") #,"GROUP")

#easy sampling
my_func = function(df1) {
 df1 %>% group_by(ID) %>% sample_n(n)
 }

new_df <- replicate(n_rep, my_func(df))

for(i in 1:n_rep){
write.table(new_df[,i][2],
 paste("random_sample",i,"txt",sep="."),
 quote=F,row.names=F,col.names=F)
}

