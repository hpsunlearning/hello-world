/ifs1/ST_META/USER/xiahuihua/bin/R-3.1.0/bin/Rscript spearman.R 151.sample.more.100.mlg.prof 151_148_metabolites_intensity.txt  All/spearman
/ifs1/ST_META/USER/xiahuihua/bin/R-3.1.0/bin/Rscript bicor.R 151.sample.more.100.mlg.prof 151_148_metabolites_intensity.txt All/bicor
/ifs1/ST_META/USER/xiahuihua/bin/R-3.1.0/bin/Rscript  mine.process.V1.R 151.sample.more.100.mlg.prof 151_148_metabolites_intensity.txt mine.process
sh mine.process.sh &
sh trigress.sh &
perl -e ' open I,"mine.process.csv,between[break=148],cv=0.0,B=n^0.6,Results.csv"; while(<I>){chomp; @a=split /,/,$_; if(not $_=~/MIC/){print $a[0]."\t".$a[1]."\t".$a[2]."\n"}}'|sort -rnk 3  >All/mine.Results.csv.sort
/ifs1/ST_META/USER/xiahuihua/bin/R-3.1.0/bin/Rscript CLR.process.R 151.sample.more.100.mlg.prof 151_148_metabolites_intensity.txt CLR.process
sh CLR.sh
/ifs1/ST_META/USER/xiahuihua/bin/R-3.1.0/bin/Rscript CLR.after.R 151.sample.more.100.mlg.prof 151_148_metabolites_intensity.txt CLR.result CLR.zscore.melt
/ifs1/ST_META/USER/xiahuihua/bin/R-3.1.0/bin/Rscript mrmr.boruta.intersect.R 151.sample.more.100.mlg.prof 151_148_metabolites_intensity.txt All/mrmr.boruta/mrmr.boruta
/ifs1/ST_MD/USER/guanyl/program/kendall/profiling_correlation_coefficient  mrmr.mlg.prof  -1 stageI.mlg.cor
find  All/mrmr.boruta/mrmr.boruta_table_*txt|perl -ne 'chomp; @a=split /\//,$_;   $c=$a[-1]; $c=~s/mrmr\.boruta_table_//g; $c=~s/\.txt//g; $file="All/mrmr.boruta/mrmr.boruta_".$c.".txt"; $file2="All/mrmr.boruta/mrmr.".$c.".txt"; print "perl /ifs1/ST_META/USER/xiahuihua/mrmr-v2.pl  stageI.mlg.cor   $file $file2\n"'>All/mrmr.boruta/mrmr.sh
sh All/mrmr.boruta/mrmr.sh
find  All/mrmr.boruta/mrmr.boruta_table_*txt|perl -ne 'chomp; @a=split /\//,$_;   $c=$a[-1]; $c=~s/mrmr\.boruta_table_//g;  $c=~s/\.txt//g; $file="All/mrmr.boruta/mrmr.".$c.".txt"; print "/ifs1/ST_META/USER/xiahuihua/bin/R-3.1.0/bin/Rscript /ifs1/ST_META/USER/xiahuihua/boot.borutia.R $_  $file  All/mrmr.boruta/$c\n"'>boruta.sh
sh boruta.sh

ls *final.txt|perl -e '%h; while(<>){chomp; @a=split /\//,$_; @b=split /-/,$a[-1]; $h{$b[0]}=1} open I,"boruta.r.sh"; while(<I>){chomp; @a=split /\s+/,$_; @b=split /\//,$a[-1]; if(not defined $h{$b[-1]}){ print $_."\n"}}' >boruta.no.sh

sh boruta.no.sh
ls *-final.txt|perl -e ' %h; while(<>){chomp; @a=split /\//,$_; @b=split /-/,$a[-1];   $h{$b[0]}=1; } open I,"boruta.r.sh";  while(<I>){ chomp; @a=split /\s+/,$_; @b=split /\//,$a[-1];  if( defined $h{$b[-1]}){ print "/ifs1/ST_META/USER/xiahuihua/bin/R-3.1.0/bin/Rscript  /ifs1/ST_META/USER/xiahuihua/borutia.after.rfcv.R  $a[2]  $a[-1]-final.txt  All/mrmr.boruta/$b[-1]\n" }}' >boruta.after.rfcv.sh
sh boruta.after.rfcv.sh

ls *rfcv.txt|perl -e '%h; while(<>){chomp; @a=split /\//,$_; @b=split /\./,$a[-1]; $h{$b[1]}=1} open I,"boruta.after.rfcv.sh"; while(<I>){chomp; @a=split /\s+/,$_; @b=split /\//,$a[-1]; if(not defined $h{$b[-1]}){ print $_."\n"}}' >boruta.after.rfcv.no.sh

sh boruta.after.rfcv.no.sh
cat  All/mrmr.boruta/*rfcv.txt>All/mrmr.boruta/All.rfcv.combine.txt
rm All/mrmr.boruta/*rfcv.txt
ls *-zscore.txt| perl -ne 'open I,"$_";  <I>; while(<I>){chomp;   @a=split /\s+/,$_; @b=split /\//,$a[1]; $a[0]=~s/X//g;if(not $a[0]=~"new"){ print $a[0]."\t".$b[-1]."\t".$a[3]."\n"}}'|sort -rnk 3 >  boruta.combine.zscore.txt
Rscript qvalue.R
perl -e 'open I,"All.rfcv.combine.txt.q"; %h; while(<I>){chomp; @a=split /\t/,$_; @b=split /\//,$a[0]; if($a[-1]<=0.05){ $h{$b[-1]}=1;  } }close I; open I,"boruta.combine.zscore.txt"; while(<I>){chomp; @a=split /\t/,$_; if(defined $h{$a[1]}){print $_."\n" }}' >boruta.combine.zscore.txt.sig

perl average.pl|sort -nk 9  >average.rank.output.ful

Rscript plot.R 151.sample.more.100.mlg.prof 151_148_metabolites_intensity.txt average.rank.output.ful 100 average.rank.output.ful.100.plot.pdf

