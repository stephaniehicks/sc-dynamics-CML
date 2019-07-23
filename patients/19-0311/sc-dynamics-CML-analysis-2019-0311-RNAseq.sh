#$ -l mem_free=10G,h_vmem=10G
#$ -cwd

R -e "rmarkdown::render('/users/shicks1/projects/sc-dynamics-CML/patients/19-0311/sc-dynamics-CML-analysis-2019-0311-RNAseq.Rmd')"
