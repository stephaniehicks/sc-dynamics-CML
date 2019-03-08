
library(SingleCellExperiment)
library(scater)
sce <- readRDS("/users/shicks1/projects/sc-dynamics-CML/data/0114P_RNAseq/BM_CD34/sce_0114.rds")

sce$cancer_status <- ifelse(
  (sce$jak2_reads_cancer > 0 & sce$jak2_reads_wt < 1), "mut", 
  ifelse((sce$jak2_reads_cancer < 1 & sce$jak2_reads_wt > 0), "wt", "unknown" ))
sce$cancer_status <- factor(sce$cancer_status, levels=c("wt", "mut", "unknown"))

libsize.drop <- isOutlier(sce$total_counts, nmads=3, type="lower", log=TRUE)
feature.drop <- isOutlier(sce$total_features_by_counts, nmads=3, type="lower", log=TRUE)
MT.drop <- isOutlier(sce$pct_counts_MT, nmads=3, type="higher", log=TRUE)

data.frame(ByLibSize=sum(libsize.drop), ByFeature=sum(feature.drop), 
           BySpike=sum(MT.drop), Remaining=ncol(sce))

sce <- sce[,!(libsize.drop | feature.drop | MT.drop)]

# cell cycle classification
library(scran)
human.pairs <- readRDS(system.file("exdata", "human_cycle_markers.rds", package="scran"))
assigned <- cyclone(sce, pairs=human.pairs, gene.names=rowData(sce)$ensembl_gene_id)

sce$phases <- assigned$phases
sce$cellcycle_score_G1 <- assigned$score$G1
sce$cellcycle_score_G2M <- assigned$score$G2M
sce$cellcycle_score_S <- assigned$score$S
sce$cellcycle_score_normalized_G1 <- assigned$normalized.scores$G1
sce$cellcycle_score_normalized_G2M <- assigned$normalized.scores$G2M
sce$cellcycle_score_normalized_S <- assigned$normalized.scores$S

saveRDS(sce, file = "/users/shicks1/projects/sc-dynamics-CML/data/0114P_RNAseq/BM_CD34/sce_qc_0114.rds")
