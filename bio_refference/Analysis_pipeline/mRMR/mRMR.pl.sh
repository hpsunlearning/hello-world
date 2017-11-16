/ifs1/ST_MD/USER/guanyl/program/kendall/profiling_kendall_tau_self_thread cluster.prof -1 8 kedall.cor.cluster
Rscript Gene_CC.corr.R cluster.prof config Gene_CC.corr
perl mrmr-v2.pl kedall.cor.cluster Gene_CC.corr mrmr.results

