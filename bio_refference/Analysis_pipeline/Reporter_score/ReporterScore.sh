echo "Reporter Score calculation V1"
echo "Chen Ning @ Desease Metagenomics Group, BGI Research"
echo "Email: chenning1@genomics.cn"
echo "2014/1/6"
echo ""

echo "Step 1/5: Performing data check..."
echo "Your KO profile file is: kegg.prof.normalize"
echo "Your config file is: config.file"
echo "Your color config file is: color.config"
echo "Your color pallete file is: color.pallete"
echo "Done."

echo "Step 2/5, Performing wilcox test..."
mkdir 01_test
less -S kegg.prof.normalize | perl -e '$a=<>;print $a;while(<>){chomp;$x=$_;@s=split /\s+/;$a=0;shift @s;for(@s){$a++ if $_>0;} print "$x\n" if $a>=6;}' > 01_test/relative_abun.m6
/home/lishenghui/R/bin/Rscript /ifs1/ST_META/USER/tanglongqing/Function/ReporterScore_59/mgl_v2.R 01_test/relative_abun.m6 config.file 01_test/wilcox.m6
echo "Done."

echo "Step 3/5, Calculating pathway reporter score..."
mkdir 02_pathway
perl /ifs1/ST_META/USER/pengyj/Infant/func_compare/bin/pathway_reporter_score_v2.pl -p kegg.prof.normalize  -f config.file  -b wilcox -t F -o 02_pathway/pathway_KO.ipath59 -x 1000 -r /ifs1/ST_META/PMO/Annotation/KEGG/KO2state/All_map_ko.list
perl -e '%hash; open I,"/ifs1/ST_META/USER/tanglongqing/Function/ReporterScore_59/pathway.info";while(<I>){chomp;@a=split /\t/,$_; $hash{$a[0]}=$a[1]} close I;open I,"02_pathway/pathway_KO.ipath59.wilcox.reporterscore.list";<I>;while(<I>){chomp;@a=split /\t/,$_;if($a[2]/$a[1]>=0.4| $a[3]/$a[1]>=0.4){ print $a[0]."\t";print $hash{$a[0]}."\t"; if($a[6]>0){print  $a[6]."\n";}else{print -$a[7]; print "\n"};  } }'>02_pathway/pathway_KO.ipath59.wilcox.reporterscore.list.stat
perl -e 'open I,"02_pathway/pathway_KO.ipath59.wilcox.reporterscore.list.stat"; %h; %name; while(<I>){chomp;@a=split /\t/,$_;if(abs($a[-1])>=1.7){$h{$a[0]}=$a[1];$name{$a[0]}=$a[-1]} } close I; open I,"01_test/wilcox.m6"; %ko;while(<I>){chomp; @a=split /\t/,$_; $id=shift @a; $ko{$id}=join("\t",@a);} close I; open I,"/ifs1/ST_META/PMO/Annotation/KEGG/KO2state/All_map_ko.list";while(<I>){chomp;@a=split /\t/,$_; if(defined $h{$a[0]}){ @b=split /,/,$a[-1]; for(0..$#b){ print $a[0]."\t".$h{$a[0]}."\t".$name{$a[0]}."\t".$b[$_]."\t".$ko{$b[$_]}."\n"  }  }}'>02_pathway/sig.pathway.ko.stat
echo "Done."

echo "Step 4/5, Calculating module reporter score..."
mkdir 03_module
perl /ifs1/ST_META/USER/pengyj/Infant/func_compare/bin/pathway_reporter_score_v2.pl -p kegg.prof.normalize  -f config.file  -b wilcox -t F -o 03_module/module_KO.ipath59 -x 1000 -r  /ifs1/ST_META/PMO/Annotation/KEGG/KO2state/All_module_ko.list
perl -e '%hash; open I,"/ifs1/ST_META/USER/tanglongqing/Function/ReporterScore_59/module.info";while(<I>){chomp;@a=split /\t/,$_; $hash{$a[0]}=$a[1]} close I;open I,"03_module/module_KO.ipath59.wilcox.reporterscore.list";<I>;while(<I>){chomp;@a=split /\t/,$_;if($a[2]/$a[1]>=0.4| $a[3]/$a[1]>=0.4){ print $a[0]."\t";print $hash{$a[0]}."\t"; if($a[6]>0){print $a[6]."\n";}else{print -$a[7]; print "\n"};}}'>03_module/module_KO.ipath59.wilcox.reporterscore.list.stat
perl -e 'open I,"03_module/module_KO.ipath59.wilcox.reporterscore.list.stat"; %h; %name; while(<I>){chomp;@a=split /\t/,$_;if(abs($a[-1])>=1.7){$h{$a[0]}=$a[1];$name{$a[0]}=$a[-1]} } close I; open I,"01_test/wilcox.m6"; %ko;while(<I>){chomp; @a=split /\t/,$_; $id=shift @a; $ko{$id}=join("\t",@a);} close I; open I,"/ifs1/ST_META/PMO/Annotation/KEGG/KO2state/All_module_ko.list";while(<I>){chomp;@a=split /\t/,$_; if(defined $h{$a[0]}){ @b=split /,/,$a[-1]; for(0..$#b){ print $a[0]."\t".$h{$a[0]}."\t".$name{$a[0]}."\t".$b[$_]."\t".$ko{$b[$_]}."\n"  }  }}'>03_module/sig.module.ko.stat
echo "Done."

echo "Step 5/5, Coloring pathway KOs..."
mkdir 04_map_color
mkdir 04_map_color/color_pathway
perl -e 'open I,"01_test/wilcox.m6";while(<I>){chomp;@a=split /\t/,$_; if($a[1]>0.05){print $_."\t0\n"}; if($a[1]<=0.05&$a[1]>0.01&$a[4]==0){print $_."\t1\n"};  if($a[1]<=0.05&$a[1]>0.01&$a[4]==1){print $_."\t3\n"};  if($a[1]<=0.01&$a[4]==0){print $_."\t2\n"};  if($a[1]<=0.01&$a[4]==1){print $_."\t4\n"}; }'>04_map_color/wilcox.test
perl /ifs1/ST_META/USER/tanglongqing/Function/ReporterScore_59/KO_color_config_type2.pl 04_map_color/wilcox.test  F 15  color.pallete 04_map_color/wilcox.test.color
perl /ifs1/ST_META/USER/tanglongqing/Function/ReporterScore_59/draw_full_list.pl /ifs1/ST_META/USER/tanglongqing/Function/ReporterScore_59/map_coloring.pl color.config /ifs1/ST_META/USER/tanglongqing/Function/ReporterScore_59/map_KO_info.list.cleanonly 04_map_color/color_pathway/ 04_map_color/map.log
echo "All done."
