argv <- commandArgs(T)
if(length(argv)==0){stop("Rscript /home/xiehailiang/us/usr/bin/Rscript DMM.fit.R [input1]
input1 : Genus counts profile.
")}
################################################################################
library(DirichletMultinomial)
library(lattice)
library(xtable)
library(parallel)
library(vegan)
library(MASS)


count <- read.table(argv[1])
count <- as.matrix(count)
count <- t(count[rowSums(count)!=0,])

fit <- mclapply(1:7, dmn, count=count, verbose=TRUE)
save(fit, file="fit.rda")

