  Rscript  CLR.process.control.R stageI.mlg.list.prof stageI.urine.txt Control/CLR/stageI.urine.csv
 /ifs5/ST_METABO/USER/liyanli/meta/huzeyun/MI_CLR/CLRv1.2.2/Code/clr --data Control/CLR/stageI.urine.csv --tfidx Control/CLR/stageI.urine.csv.tfidx.csv --map CLR.zscore.stageI.urine --bins 10 --spline 3
 /ifs1/ST_META/USER/xiahuihua/bin/R-3.1.0/bin/Rscript CLR.after.R stageI.mlg.list.prof stageI.urine.txt Control/CLR/CLR.zscore.stageI.urine Control/CLR/CLR.zscore.stageI.urine.melt

  /ifs1/ST_META/USER/xiahuihua/bin/R-3.1.0/bin/Rscript mrmr.boruta.intersect.control.R stageI.mlg.list.prof  stageI.urine.txt Control/boruta/mrmr.boruta
    find  Control/boruta/mrmr.boruta_table_*txt|perl -ne 'chomp; @a=split /\//,$_; @b=split /_/,$a[-1]; $c=$b[-1]; $c=~s/\.txt//g; print "/ifs1/ST_META/USER/xiahuihua/bin/R-3.1.0/bin/Rscript  /ifs1/ST_META/USER/xiahuihua/jiezhuye/CHD/ALl_stage/stageIV_vs_stageII/MLG_metabolite/boot.borutia.R $_     Control/boruta/$c\n"'>boruta.sh
	 perl /ifs1/ST_META/USER/luoxiao/bin/qsub.pl -l vf=1.2G,p=5 -m 100 -P st_meta boruta.sh
	 find  Control/boruta/*-zscore.txt| perl -ne 'open I,"$_";  <I>; while(<I>){chomp;   @a=split /\s+/,$_; @b=split /\//,$a[1]; $a[0]=~s/X//g;if(not $a[0]=~"new"){ print $a[0]."\t".$b[-1]."\t".$a[2]."\n"}}'|sort -rnk 3 > Control/boruta.combine.zscore.txt
	 wc -l  Control/boruta/*-final.txt> boruta.final.stat
	 cat  Control/boruta/*-final.txt >Control/boruta.final.txt
	 cat stageI.urine_*,Results.csv >stageI.urine.final.result.csv
 perl -e ' open I,"Control/MINE/stageI.urine.final.result.csv"; while(<I>){chomp; @a=split /,/,$_; if(not $_=~/MIC/){print $a[0]."\t".$a[1]."\t".$a[2]."\n"}}'|sort -rnk 3  >Control/MINE/stageI.urine.mine.results.csv.sort
  Rscript mine.process.V1.control.after.R stageI.mlg.list.prof stageI.urine.txt
   Rscript  trigress.control.afater.R  stageI.mlg.list.prof stageI.urine.txt
perl -e 'open I,"mine.meto.name.txt"; %g; while(<I>){chomp; @a=split /\t/,$_; $g{$a[-1]}=$a[0]}close I; open I,"/ifs1/ST_META/USER/xiahuihua/jiezhuye/CHD/ALl_stage/stageIV_vs_stageII/MLG_metabolite/Control/MINE/stageI.urine.mine.results.csv.sort"; while(<I>){chomp; @a=split /\t/,$_; print $a[1]."\t".$g{$a[0]}."\t".$a[-1]."\n"}'>/ifs1/ST_META/USER/xiahuihua/jiezhuye/CHD/ALl_stage/stageIV_vs_stageII/MLG_metabolite/Control/MINE/MINE.results.csv.sort.stageI.urine
 perl -e 'open I,"trigress.meto.name.txt"; %g; while(<I>){chomp; @a=split /\t/,$_; $g{$a[-1]}=$a[0]}close I; open I,"/ifs1/ST_META/USER/xiahuihua/jiezhuye/CHD/ALl_stage/stageIV_vs_stageII/MLG_metabolite/Control/Trigress/stageI.urine.trigresstrigress_TIGRESS_predictions.txt.naremove"; while(<I>){chomp; @a=split /\t/,$_; if( not $a[0] =~ /C/ ){print $a[0]."\t".$g{$a[1]}."\t".$a[-1]."\n"}  }'>/ifs1/ST_META/USER/xiahuihua/jiezhuye/CHD/ALl_stage/stageIV_vs_stageII/MLG_metabolite/Control/Trigress/Trigress.trigress_TIGRESS_predictions.txt.naremove.stageI.urine
le /ifs1/ST_META/USER/xiahuihua/jiezhuye/CHD/ALl_stage/stageIV_vs_stageII/MLG_metabolite/Control/Bicor/stageI.urine.bicor.melt|perl -e 'while(<>){if(not $_=~/Var/){print $_}}'>/ifs1/ST_META/USER/xiahuihua/jiezhuye/CHD/ALl_stage/stageIV_vs_stageII/MLG_metabolite/Control/Bicor.melt.stageI.urine

le /ifs1/ST_META/USER/xiahuihua/jiezhuye/CHD/ALl_stage/stageIV_vs_stageII/MLG_metabolite/Control/Spearman/stageI.urine.spearman.melt|perl -e 'while(<>){if(not $_=~/Var/){print $_}}'>/ifs1/ST_META/USER/xiahuihua/jiezhuye/CHD/ALl_stage/stageIV_vs_stageII/MLG_metabolite/Control/Spearman.melt.stageI.urine
le /ifs1/ST_META/USER/xiahuihua/jiezhuye/CHD/ALl_stage/stageIV_vs_stageII/MLG_metabolite/Control/CLR/CLR.zscore.stageI.urine.melt.melt|perl -e 'while(<>){if(not $_=~/Var/){ @a=split /\t/,$_;  print $a[0]."\t".$a[1]."\t"; $rounded = sprintf("%.3f", $a[-1]); print $rounded."\n"; }}' >/ifs1/ST_META/USER/xiahuihua/jiezhuye/CHD/ALl_stage/stageIV_vs_stageII/MLG_metabolite/Control/CLR/CLR.zscore.stageI.urine
le /ifs1/ST_META/USER/xiahuihua/jiezhuye/CHD/ALl_stage/stageIV_vs_stageII/MLG_metabolite/Control/boruta/boruta.combine.zscore.txt t|perl -e 'while(<>){ @a=split /\t/,$_;  print $a[0]."\t".$a[1]."\t"; $rounded = sprintf("%.2f", $a[-1]); print $rounded."\n"; }' >/ifs1/ST_META/USER/xiahuihua/jiezhuye/CHD/ALl_stage/stageIV_vs_stageII/MLG_metabolite/Control/boruta/boruta.combine.zscore.txt.v1
perl average.pl|sort -nk 9  >average.rank.output.ful

