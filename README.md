# wcGeneSummary

  <!-- badges: start -->
  [![R-CMD-check](https://github.com/noriakis/wcGeneSummary/workflows/R-CMD-check/badge.svg)](https://github.com/noriakis/wcGeneSummary/actions)
  <!-- badges: end -->

Make wordcloud or a plot of correlation network of gene set from RefSeq description using R libraries [`GeneSummary`](https://bioconductor.org/packages/release/data/annotation/html/GeneSummary.html), [`tm`](https://www.jstatsoft.org/article/view/v025i05) and `wordcloud`. Input is gene list with the type `ENTREZID`. I think it is useful when the enrichment analysis returns no significant results for a set of genes. The idea for using RefSeq description in [`simplyfyEnrichment`](https://github.com/jokergoo/simplifyEnrichment) is already raised [here](https://github.com/jokergoo/simplifyEnrichment/issues/56).

### Installation
```R
devtools::install_github("noriakis/wcGeneSummary")
library(wcGeneSummary)
```

### Documentation
[https://noriakis.github.io/software/wcGeneSummary/](https://noriakis.github.io/software/wcGeneSummary/)

### Example of ERCC
```R
erccs <- c("ERCC1","ERCC2","ERCC3","ERCC4","ERCC5","ERCC6","ERCC8")
gwc <- wcGeneSummary(erccs, excludeFreq = 5000, max.words=200, random.order=FALSE,
                     colors=palettetown::pokepal(150), rot.per=0.4)
# ggsave("erccWc.png", gwc$wc, width=8, height=8)
```
<img src="https://github.com/noriakis/software/blob/main/images/erccWc.png?raw=true" width="800px">

### Example of CXCL
```R
cxcls <- c()
for (i in c(1,2,3,5,6,8,9,10,11,12,13,14,16)){
    cxcls <- c(cxcls, paste0("CXCL",i))
}
gwc <- wcGeneSummary(cxcls, excludeFreq=14000,
                     madeUpper=c("dna","rna",tolower(keys(org.Hs.eg.db, keytype="SYMBOL"))),
                     max.words=200, random.order=FALSE,
                     colors=palettetown::pokepal(151), rot.per=0.4)
# ggsave("cxclWc.png", gwc$wc, width=8, height=8)
```
<img src="https://github.com/noriakis/software/blob/main/images/cxclWc.png?raw=true" width="800px">

### Example of CCL (correlation network)
```R
library(wcGeneSummary)
library(org.Hs.eg.db)
library(ggraph)
ccls <- c()
for (i in c(1,2,3,4,5,6,7,8,9)){
    ccls <- c(ccls, paste0("CCL",i))
}
cclNet <- wcGeneSummary(ccls, plotType="network",
                        layout="nicely",
                        madeUpper=c("dna","rna",tolower(keys(org.Hs.eg.db, keytype="SYMBOL"))),
                        numWords = 15, excludeFreq = 5000, edgeLink=FALSE, showLegend=FALSE)
cclNetTrans <- cclNet$net + theme(plot.background = element_rect(fill = "transparent",colour = NA))
# ggsave(file="cclNet.png", cclNetTrans, width=7, height=7, bg="transparent")
```

<img src="https://github.com/noriakis/software/blob/main/images/cclCorNetNicely.png?raw=true" width="800px">

### Example of a corelation network of words in the pathway
```R
library(org.Hs.eg.db)
keggPathways <- org.Hs.egPATH2EG
mappedKeys <- mappedkeys(keggPathways)
keggList <- as.list(keggPathways[mappedKeys])
## Hepatitis C
hCNet <- wcGeneSummary(keggList$`05160`, plotType="network",
                        layout="nicely", corThresh = 0.2, keyType="ENTREZID",
                        madeUpper=c("dna","rna",tolower(keys(org.Hs.eg.db, keytype="SYMBOL"))),
                        numWords = 30, excludeFreq = 5000, colorText=TRUE,
                        edgeLink=FALSE, showLegend=FALSE)
hCNetTrans <- hCNet$net + theme(plot.background = element_rect(fill = "transparent",colour = NA))
# ggsave(file="hCNet.png", hCNetTrans, width=12, height=12, bg="transparent")
```
<img src="https://github.com/noriakis/software/blob/main/images/hCNet.png?raw=true" width="800px">

Additionally perform enrichment analysis on the same gene list and plot a correlation network.
```R
hCNetReac <- wcGeneSummary(keggList$`05160`, enrich="reactome", keyType="ENTREZID"
                           topPath=30, numWords=30,
                           plotType="network", corThresh=0.2)
hCNetReacTrans <- hCNetReac$net + theme(plot.background = element_rect(fill = "transparent",colour = NA))
# ggsave(file="hCNetTrans.png", hCNetReacTrans, width=12, height=12, bg="transparent")
```
<img src="https://github.com/noriakis/software/blob/main/images/hCNetTrans.png?raw=true" width="800px">

### Example of annotating Bayesian network

Interactive inspection of Bayesian network of module eigengenes using `Cytoscape.js` and `wcGeneSummary`.
<img src="https://github.com/noriakis/software/blob/main/images/wcbn.png?raw=true" width="800px">

Using barplots.  
<p align="center">
<img src="https://github.com/noriakis/software/blob/main/images/bbn.png?raw=true" width="400px">
</p>

You can also export to `vis.js`.
<p align="center">
<img src="https://github.com/noriakis/software/blob/main/images/bbn_visjs.png?raw=true" width="400px">
</p>


### Example of annotating dendrogram of gene cluster by words

The example of annotating dendrogram by pyramid plots of word counts is shown. In this example, `WGCNA` was used to cluster the gene expression values. Module eigengenes are further clustered by `pvclust`. `getWordsOnDendro` can be used to obtain the `patchworkGrob` list. Grobs can be plotted on dendrogram plot using the `annotation_custom`.

```R
library(wcGeneSummary)
## MEs and colors are stored in `bwmod`, a blockwise module result from WGCNA
plotEigengeneNetworksWithWords(bwmod$MEs, bwmod$colors)
```

<img src="https://github.com/noriakis/software/blob/main/images/plotDendro.png?raw=true" width="800px">

### The other examples

- [Example annotating gene clusters using WGCNA](https://noriakis.github.io/software/wcGeneSummary/WGCNA.html)
- [Example in Bayesian network analysis](https://github.com/noriakis/compare_sign)

### References
- [Zuguang Gu. GeneSummary](https://doi.org/doi:10.18129/B9.bioc.GeneSummary)
- Feinerer I, Hornik K, Meyer D. Text Mining Infrastructure in R. J Stat Softw 2008;25:1???54. doi:10.18637/jss.v025.i05
- [Ian Fellows. wordcloud: Word Clouds. R package version 2.6. 2018.](https://cran.r-project.org/web/packages/wordcloud/index.html)
- [Lucas T. palettetown: Pokemon themed colour schemes for R.](https://github.com/timcdlucas/palettetown)