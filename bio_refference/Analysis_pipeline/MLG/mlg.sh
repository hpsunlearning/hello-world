less -S /ifs1/ST_META/USER/wangxiaokai/Obese/158/158.obese.gene.reads_count.pro  | perl -e '$a=<>;print $a;while(<>){chomp;$x=$_;@s=split /\s+/;$a=0;shift @s;for(@s){$a++ if $_>1;} print "$x\n" if $a>=7;}' > 158.reads_count.m7

less -S 158.reads_count.m7  | perl -e 'chomp($h=<>);@h=split /\s+/,$h; %h; while(<>){chomp;@s=split /\s+/;for(1..$#s){$h{$_}+=$s[$_];}} for(1..$#h){print "$h[$_]\t$h{$_}\n";}' > 158.reads_count.m7.stat


/home/lishenghui/bin/diff_head  /ifs1/ST_META/USER/wangxiaokai/Obese/158/obese.158.gene.p.0.01.gene.id  1 158.reads_count.m7  1 158.reads_count.m7.p01
#select gene.id.0.01 in the whole profile reads_count.m7 into a significant profile reads_count.m7.p01


/ifs1/ST_MD/USER/guanyl/program/SOAPmeta-MGL/source/profiling_to_pattern_thread_v1.1 -r 158.reads_count.m7.stat  -t  158.reads_count.m7.p01  -o 158.reads_count.m7.p01.pat  -c 0.05 -p 8
#pattern

perl /ifs1/ST_META/USER/lishenghui/Diabetes3/20.workflow/rank_SORT.pl  158.reads_count.m7.p01.pat   158.reads_count.m7.p01.pat


less -S  158.reads_count.m7.p01.pat.srk | perl -ne 'chomp;@s=split /\s+/;$a=0;for(1..$#s){$a++ if $s[$_]>1;} print "$_\n" if $a>=8;' > 158.reads_count.m7.p01.pat.srk.m8


/home/lishenghui/bin/diff_lsh   158.reads_count.m7.p01.pat.srk.m8 1  158.reads_count.m7.p01.pat  1  158.reads_count.m7.p01.pat.m8

/ifs1/ST_MD/USER/guanyl/program/kendall/pattern_kendall_tau_self_thread_v2.1  158.reads_count.m7.p01.pat.m8   158   0.60 10  158.reads_count.m7.p01.pat.corr
#generate correlation coefficient


/ifs1/ST_MD/USER/guanyl/program/hierarchical_clustering_relative_v2.0/cluster   -w 60 -s 0.6 -m 9999999 158.reads_count.m7.p01.pat.corr -o 158.reads_count.m7.p01.pat.corr.s60
#hirarchical clustring of a corr



/opt/blc/self-software/bin/msort -k rn3  158.reads_count.m7.p01.pat.corr.s60 >158.reads_count.m7.p01.pat.corr.s60.sort
#annotation
anno_file=760MetaHit_139HMP_368PKU_511Bac.uniq.fa.minal.tax
old_4_3_anno=/ifs1/ST_META/USER/lishenghui/Diabetes3/31.GeneSet/blastn-taxa/LSH.blastn-img.f.f.f
perl -e 'open I,"760MetaHit_139HMP_368PKU_511Bac.uniq.fa.minal.tax";%hash;while(<I>){chomp;split/\t/;$hash{$_[0]}{$_[2]}=$_[1];}close I;open I,"158.reads_count.m7.p01.pat.corr.s60.sort";while(<I>){chomp;split;if(@_==1){print "$_\n";next;}my @array=split/,/,$_[-1];my %count=();my %iden=();foreach(@array){if(exists $hash{$_}){foreach my $k(keys %{$hash{$_}}){$count{$k}++;$iden{$k}+=$hash{$_}{$k};}}}my @temp=sort {$count{$b} <=> $count{$a} or $iden{$b} <=> $iden{$a}} keys %count;print "$_[0]\t$_[-2]";if($count{$temp[0]}/$_[-2]<0.5){print "\tUnclassified\n";next;}print "\t$temp[0]\t$count{$temp[0]}\t",$count{$temp[0]}/$_[-2],"\t",$iden{$temp[0]}/$count{$temp[0]};for my $k(1..$#temp){if($count{$temp[$k-1]}/$_[-2]-$count{$temp[$k]}/$_[-2]>0.2){last;}print "\t$temp[$k]\t$count{$temp[$k]}\t",$count{$temp[$k]}/$_[-2],"\t",$iden{$temp[$k]}/$count{$temp[$k]};}print "\n";}' > 158.reads_count.m7.p01.pat.corr.s60.sort.taxo

perl -e 'open I,"<158.reads_count.m7.p01.pat.corr.s60.sort";%cluster;%need;while(<I>){chomp;split;my    $id=$_[0];my @array=split/,/,$_[-1]; @{$cluster{$id}}=@array; foreach my $k(@array){$need{$k}=undef;}}close I;open I,"</ifs1/ST_META/USER/wangxiaokai/Obese/158/158.obese.gene.pro";%prof;$head=<I>;print $head;while(<I>){chomp;split;next unless exists $need{$_[0]};my @array=split;my $id=shift @array;@{$prof{$id}}=@array;}close I;undef %need;%need=();open I,"<158.reads_count.m7.p01.pat.corr.s60.sort";while(<I>){chomp;split;print $_[0];my @array=();foreach my $k1(@{$cluster{$_[0]}}){for my $k2(0..$#{$prof{$k1}}){push @{$array[$k2]},${$prof{$k1}}[$k2];}}foreach my $k3(@array){my @temp=sort {$a <=> $b} @{$k3};my $size=$#temp+1;my $sum=0;for my $k4(int($size*0.05)..$#temp-int($size*0.05)){$sum+=$temp[$k4];}print "\t",$sum/($size-2*int($size*0.05));}print "\n";}' >158.reads_count.m7.p01.pat.corr.s60.sort.prof


perl -e 'open I,"158.reads_count.m7.p01.pat.corr.s60.sort.taxo";while(<I>){chomp;@a=split /\t/,$_; for(0..13){print $a[$_]."\t"}print "\n"}' >158.reads_count.m7.p01.pat.corr.s60.sort.taxo3
/ifs5/PC_MICRO_META/PRJ/MetaSystem/software/R-3.0.0/bin/Rscript  /ifs1/ST_META/USER/wangxiaokai/Obese/158/mlg/mlg.r 158.reads_count.m7.p01.pat.corr.s60.sort.prof 158.obese.mlg.config  158.stat.txt
paste  158.stat.txt    158.reads_count.m7.p01.pat.corr.s60.sort.taxo3  >158.mgl.stat

