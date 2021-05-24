#!/usr/bin/env Rscript

#date: 15-05-2020
#Author: QR
#Description:
#simple script to analyze the distribution of singleton:
#perform test for difference in their distribution and plot them

## library: 
if("dplyr" %in% rownames(installed.packages()) == FALSE)
    {install.packages("dplyr", repos="https://cloud.r-project.org") }
if("reshape2" %in% rownames(installed.packages()) == FALSE)
    {install.packages("reshape2", repos="https://cloud.r-project.org") }
if("data.table" %in% rownames(installed.packages()) == FALSE)
    {install.packages("data.table", repos="https://cloud.r-project.org") }
if("ggplot2" %in% rownames(installed.packages()) == FALSE)
    {install.packages("ggplot2", repos="https://cloud.r-project.org") }

library(reshape2)
library(dplyr)
library(data.table)
library(ggplot2)

## load data
#argument
argv <- commandArgs(T)
strata <- argv[1] #argument provided automatically to the Rscript
singletons <-fread("zcat ALL.txt.gz")
strata <- read.table(strata)
colnames(strata) <- c("ID","IND","GROUP")
strata <- select(strata, -IND)
c <- merge(strata, singletons , by.x ="ID", by.y="V1") #keep group for plotting

aggreg <- aggregate(c[,3:ncol(c)],by=list(c[,2]),mean)
aggreg <- melt(aggreg)

#fit <- aov(agg$value ~ agg$Group.1)
#TukeyHSD(fit) #only for independent data that fit the anova assumption

#here data are non-independent:
KW <- kruskal.test(value ~ Group.1, data = aggreg)

sink("kruskal_Wallis.score.txt")
print(KW)
print("KW exact p.value:")
print(KW$p.value)
sink()
writeLines("\nKruskall-Wallis test printed in kruskal_Wallis.score.txt file\n")

pw <- pairwise.wilcox.test(aggreg$value, aggreg$Group.1,
                 p.adjust.method = "BH")

sink("p.wilcox.test.txt")
print(pw)
sink()

writeLines("\npairwise wilcoxon test printed in p.wilcox.test.txt file \n")

#group_by(aggreg, Group.1) %>%
#  summarise(
#    count = n(),
#    mean = mean(value, na.rm = TRUE),
#    sd = sd(value, na.rm = TRUE)
#  )

colnames(aggreg)[1] <- "Region"

#Coho samples specific renaming
#aggreg$Region <- gsub('Washington&Oregon','Cascadia',agg$Region)
#aggreg$Region <- factor(agg$Region,
#    levels = c('California', 'Cascadia', 'BC',
#     'HaidaGwaii','Thompson','Alaska'),
#    ordered = TRUE)

p <- ggplot(aggreg, aes(x = Region, y = value ,fill=Region ))
p <- p+ geom_violin(trim = F, width=1)  + theme_minimal() #+ theme_classic() #
p <- p + labs(x="Region", y = "Singleton Counts") 

#code specific to salmon
#The colours scheme could be customzied depending on the group size!
#p <- p +scale_fill_manual(values=c("Red", "Green","Orange", 
#    "darkviolet","springgreen4","Blue"))
p <- p + scale_fill_brewer(palette="Dark2")

p <- p + stat_summary(fun.data=mean_sdl, mult=1, 
                 geom="pointrange", color="black")

p <- p + theme(axis.title.x=element_text(size=14, 
    family="Helvetica",face="bold"),
     axis.text.x=element_text(size=14,family="Helvetica",
     face="bold", angle=45, hjust=0, vjust=0),
     axis.title.y=element_text(size=16, family="Helvetica",
     face="bold",angle=90, hjust=0.5, vjust=0.5),
     axis.text.y=element_text(size=14,family="Helvetica",face="bold"),
     strip.text.x = element_text(size=18))
#p <- p + theme(legend.text=element_text(size=14))
p <- p + theme(plot.title = element_text(size = 16, face = "bold"),
    legend.title=element_text(size=16), 
    legend.text=element_text(size=14))

pdf(file="singleton_distribution.pdf",12,8)
p
dev.off()
