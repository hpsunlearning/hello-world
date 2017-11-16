#!/usr/bin/env Rscript
library(scatterplot3d)
argv <- commandArgs(T)

inputFile <- argv[1]
outputFile <- argv[2]

data <- read.table(inputFile, header=TRUE)
sample <- data[1,]
data <- data[-1,]

colors <- c(hsv(alpha=0.9,s=0.5,v=0.85,h=0),hsv(alpha=0.9,s=0.5,v=0.85,h=2/3),hsv(alpha=0.9,s=0.5,v=0.85,h=1/3))
data.color <- colors[data$type]

pdf(outputFile)
s3d <- scatterplot3d(data$PC1, data$PC2, data$PC3, color=data.color, pch=20, xlab="", ylab="", zlab="", angle=70)
s3d$points3d(sample$PC1, sample$PC2, sample$PC3, col="purple", pch=19, cex=2)
legend(-0.4444444, 12.44444, levels(data$type), col=colors, pch=20)
dot <- s3d$xyz.convert(sample$PC1, sample$PC2, sample$PC3)
s3d$xyz.convert(-0.4, 0.3, 0.7)
text(dot$x, dot$y, sample$type, pos=1, offset=1)
dev.off()
