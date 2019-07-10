#$ -l mem_free=10G,h_vmem=10G
#$ -cwd

# Rscript /users/shicks1/projects/sc-dynamics-CML/patients/sc-dynamics-CML-analysis-2019-0114Patient-RNAseq-cluster.R
R -e "rmarkdown::render('/users/shicks1/projects/sc-dynamics-CML/patients/sc-dynamics-CML-analysis-2019-0114Patient-RNAseq.Rmd')"
