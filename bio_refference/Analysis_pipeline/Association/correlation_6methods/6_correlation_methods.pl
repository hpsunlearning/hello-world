#! /usr/bin/perl

=head1 Program: 6_correlation_methods.pl
=head1 Version: V1.0
=head1 Updated: Dec 3 2014, Wednesday, 18:18:18
=head1 Description: This program was used to caculate correlation coefficient with 6 methods(spearman\bicor\MIC\trigress\CLR\boruta\)

=head1 
        	
	Usage: perl 6_correlation_methods.pl [options]

        Options: 
        -a  <str> input file 1 [xxx.mlg.pro]
        -b  <str> input file 2 [xxx.phenotype.txt]  
        -n  <num> the rownumbers of input file 2 (without Title)
        -o  <str> prefix of output file [RA]
        --queue <str>  marker the queue [STN11029]     

Contact: wangxiaokai@genomics.org.cn
   
=head1 Example

nohup perl $0 -a 151.sample.more.100.mlg.prof -b 151_148_metabolites_intensity.txt -n 148 -o RA.mlg --queue STN11029
     	
=cut

use strict;
#use warnings;
use FindBin qw($Bin $Script);
use lib "$FindBin::Bin/";
use File::Basename qw(basename dirname);
use Getopt::Long;
use Data::Dumper;
use Pod::Text;
use threads;
use threads::shared;

##initialize some parameters fot GetOptions
our ($input1,$input2,$num,$out,$queue);

GetOptions( 
        "a=s"=>\$input1,
        "b=s"=>\$input2,
        "n=i"=>\$num,
        "o=s"=>\$out,
        "queue=s"=>\$queue,
);
##get the introduction information
die `pod2text $0` if ( !$input2 );
print STDERR "Program Beginning...\n";

##spearman
`echo "/ifs1/ST_META/USER/xiahuihua/bin/R-3.1.0/bin/Rscript $FindBin::Bin/spearman.R $input1 $input2 $out">spearman.sh`;
#`qsub -cwd -l vf=3g,p=3 -q st.q -P $queue spearman.sh`;

##bicor
`echo "/ifs1/ST_META/USER/xiahuihua/bin/R-3.1.0/bin/Rscript $FindBin::Bin/bicor.R $input1 $input2 $out">bicor.sh`;
#`qsub -cwd -l vf=3g,p=3 -q st.q -P $queue bicor.sh`;

##MIC
`echo "/ifs1/ST_META/USER/xiahuihua/bin/R-3.1.0/bin/Rscript  $FindBin::Bin/mine.process.V1.R $input1 $input2 $out">mine.process.sh`;
`sh mine.process.sh &`;
`/usr/java/latest/bin/java -Xms1024m -Xmx4512m -jar $FindBin::Bin/MINE.jar $out.mine.process.csv -pairsBetween  $num`;
`mv $out.mine.process.csv*R*.csv $out.mine.process.csv.Results.csv`;
`mv $out.mine.process.csv*S*.txt $out.mine.process.csv.Status.txt`;
`perl -e ' open I,"$out.mine.process.csv.Results.csv"; while(<I>){chomp; \@a=split /,/,\$_; if(not \$_=~/MIC/){print \$a[1]."\t".\$a[0]."\t".\$a[2]."\n"}}'|sort -rnk 3  >$out.mine.Results.csv.sort`;

##trigress
`echo "/ifs1/ST_META/USER/xiahuihua/bin/R-3.1.0/bin/Rscript  $FindBin::Bin/tigress_gp.V1.R --data  $out.mine.process.csv  --cut 1000 --nbootstrap 100 --nstepsLARS 5  --norm T --scoring area --usemulticore T --num $num">trigress.sh`;
#`qsub -cwd -l vf=3g,p=3 -q st.q -P $queue trigress.sh`;

##CLR
`echo "/ifs1/ST_META/USER/xiahuihua/bin/R-3.1.0/bin/Rscript $FindBin::Bin/CLR.process.R $input1 $input2 $out">CLR.process.sh`;
`sh CLR.process.sh & `;
`/ifs5/ST_METABO/USER/liyanli/meta/huzeyun/MI_CLR/CLRv1.2.2/Code/clr --data $out.CLR.process --tfidx  $out.CLR.process.tfidx.csv --map $out.CLR.result --bins 10  --spline 3`;
`echo "/ifs1/ST_META/USER/xiahuihua/bin/R-3.1.0/bin/Rscript $FindBin::Bin/CLR.after.R $input1 $input2 $out.CLR.result $out.CLR.zscore">CLR.after.sh`;
#`qsub -cwd -l vf=3g,p=3 -q st.q -P $queue CLR.after.sh`;

##boruta
`echo "/ifs1/ST_META/USER/xiahuihua/bin/R-3.1.0/bin/Rscript $FindBin::Bin/mrmr.boruta.intersect.R $input1 $input2 $out">boruta.sh`;
`sh boruta.sh & `;
`/ifs1/ST_MD/USER/guanyl/program/kendall/profiling_correlation_coefficient  mrmr.mlg.prof  -1 boruta.stageI.mlg.cor`;
`ls $out\_*.txt>boruta.mrmr.list`;
`for i in \`cat boruta.mrmr.list\`;do echo "perl $FindBin::Bin/mrmr-v2.pl boruta.stageI.mlg.cor \$i \$i.mrmr">>boruta.mrmr.sh;done`;
`sh boruta.mrmr.sh & `;
`ls $out.mrmr.boruta_table_*>boruta.r.list`;
`for i in \`cat boruta.r.list\`;do echo "/ifs1/ST_META/USER/xiahuihua/bin/R-3.1.0/bin/Rscript $FindBin::Bin/boot.borutia.R \$i \$i.boruta">>boruta.r.sh;done`;
`split -l 1 boruta.r.sh xboruta.r.`;
`ls xboruta.r*>xboruta.r.list`;
`for i in \`cat xboruta.r.list\`;do mv \$i \$i.sh;done`;
`ls xboruta.r*.sh>xboruta.r.sh.list`;
`for i in \`cat xboruta.r.sh.list\`;do sh \$i;done`;
`rm xboruta.r*.sh xboruta.r.sh.list`;
`ls *-final.txt|perl -e '\%h; while(<>){chomp; \@a=split /\\//,\$_; \@b=split /-/,\$a[-1]; \$h{\$b[0]}=1} open I,"boruta.r.sh"; while(<I>){chomp; \@a=split /\\s+/,\$_; \@b=split /\\//,\$a[-1]; if(not defined \$h{\$b[-1]}){ print \$_."\n"}}'>boruta.no.sh`;
`sh boruta.no.sh & `;
`ls *-final.txt>boruta.r.final.list.1`;
`perl $FindBin::Bin/get.boruta.after.rfcv.sh.pl boruta.r.final.list.1 boruta.r.sh boruta.after.rfcv.sh`;
`split -l 1 boruta.after.rfcv.sh xboruta.after.rfcv.`;
`ls xboruta.after.rfcv.*>xboruta.after.rfcv.list`;
`for i in \`cat xboruta.after.rfcv.list\`;do mv \$i \$i.sh;done`;
`ls xboruta.after.rfcv.*.sh>xboruta.after.rfcv.sh.list`;
`for i in \`cat xboruta.after.rfcv.sh.list\`;do sh \$i;done`;
`ls *rfcv.txt|perl -e '\%h; while(<>){chomp; \@a=split /\\//,\$_; \@b=split /.rfcv/,\$a[-1]; \$h{\$b[0]}=1} open I,"boruta.after.rfcv.sh"; while(<I>){chomp; \@a=split /\\s+/,\$_; if(not defined \$h{\$a[-1]}){ print \$_."\n"}}' >boruta.after.rfcv.no.sh`;
`sh boruta.after.rfcv.no.sh & `;
`cat  *rfcv.txt>All.rfcv.combine.txt`;
`less -SN All.rfcv.combine.txt|perl -e 'while(<>){chomp;\@a=split/\t/,\$_;if(! defined \$a[1]){\$a[1]="NA";\$a[2]="NA";print \$a[0]."\t"."\$a[1]"."\t".\$a[2]."\n";}else{print \$_."\n";}}'>All.rfcv.combine.txt.new`;
`/ifs1/ST_META/USER/xiahuihua/bin/R-3.1.0/bin/Rscript $FindBin::Bin/qvalue.R`;
`rm *rfcv.txt xboruta.after.rfcv.*.sh boruta.r.final.list.1 xboruta.after.rfcv.list xboruta.after.rfcv.sh.list`;
`ls *-zscore.txt| perl -ne 'open I,"\$_"; <I>; while(<I>){chomp;\@a=split(/\\s\+/,\$_); \@b=split(/\\//,\$a[1]); \$a[0]=~s/X//g;if(not \$a[0]=~"new"){ print \$a[0]."\t".\$b[-1]."\t".\$a[3]."\n"}}'|sort -rnk 3 \>  boruta.combine.zscore.txt`;
`perl -e 'open I,"All.rfcv.combine.txt.new.q"; \%h; while(<I>){chomp; \@a=split /\t/,\$_; \@b=split /\\//,\$a[0]; if(\$a[-1]<=0.05){ \$h{\$b[-1]}=1;  } }close I; open I,"boruta.combine.zscore.txt"; while(<I>){chomp; \@a=split /\t/,\$_; if(defined \$h{\$a[1]}){\@b=split /\_/,\$a[1];print \$a[0]."\t".\$b[2]."_".\$b[3]."\t".\$a[2]."\n";}}'|sed 's/.mrmr.boruta.txt.boruta//g' >boruta.combine.zscore.txt.sig`;
`mv boruta.combine.zscore.txt.sig $out.boruta.combine.zscore.txt.sig`;
`mv $out.mine.process_TIGRESS_predictions.txt $out.TIGRESS_predictions.txt`;
`ls $out.spearman.melt $out.bicor.melt $out.mine.Results.csv.sort $out.CLR.zscore.melt $out.TIGRESS_predictions.txt $out.boruta.combine.zscore.txt.sig>all.list`;
`perl $FindBin::Bin/average.pl|sort -nk 9  >average.rank.output.ful`;
`sort -nk 3 average.rank.output>average.rank.output.sort`;
`rm average.rank.output`;
`/ifs1/ST_META/USER/xiahuihua/bin/R-3.1.0/bin/Rscript $FindBin::Bin/plot.R $input1 $input2 average.rank.output.ful 100 average.rank.output.ful.100.plot.pdf`;

print STDERR "Program End!\n";
sub function{}
