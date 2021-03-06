% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/getWordsOnDendro.R
\name{plotEigengeneNetworksWithWords}
\alias{plotEigengeneNetworksWithWords}
\title{plotEigengeneNetworksWithWords}
\usage{
plotEigengeneNetworksWithWords(
  MEs,
  colors,
  nboot = 100,
  numberOfWords = 10,
  geneNumLimit = 1000,
  geneVecType = "ENSEMBL",
  excludeFreq = 10000,
  border = TRUE,
  madeUpper = c("rna", "dna")
)
}
\arguments{
\item{MEs}{module eigengene data}

\item{colors}{named vector of cluster}

\item{nboot}{pvclust bootstrap number}

\item{numberOfWords}{number of words to be included in pyramid plots}

\item{geneNumLimit}{clusters with gene number above this threshold are ignored}

\item{geneVecType}{type of IDs in `colors`}

\item{excludeFreq}{exclude the words above this threshold}

\item{border}{whether to draw border on pyramid plots}

\item{madeUpper}{words with uppercase}
}
\value{
plot of dendrogram between module eigengenes with word annotations
}
\description{
plot an eigengene dendrogram with word annotation
}
\examples{
mod <- returnExample()
plotEigengeneNetworksWithWords(mod$MEs, mod$colors)
}
