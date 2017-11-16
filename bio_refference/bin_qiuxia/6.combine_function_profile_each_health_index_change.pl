#!/usr/bin/perl -w
use strict;
use FindBin qw/$Bin/;

my $usage = <<"usage";
perl $0 level2.pro level3.pro oxidative.pro H2S.pro toxin.pro
SCFA.pro sample.num Rscript_path total.pro outDir
usage
die $usage unless(@ARGV == 10);
my $plotBin = "$Bin/02.function_boxplot.R";
my $func_count= "$Bin/02.function_count.pl";
my $func_health_index="$Bin/function_health_index.pl";
#my $Rscript = "/ifs3/solexa/data/heyuan/R/bin/Rscript";

my ($level2,$level3,$oxidative,$H2S,$toxin,$SCFA,$sample_num,$Rscript,$output,$outDir) = @ARGV;
my $mess;
my $head;

#alevel2
$head = `head -1 $level2`;
$mess .= `head -1 $level2`;
my $info = `grep Energy $level2`;
$mess .= $info;
$info = `grep Glycan $level2`;
$mess .= $info;
$info = `grep Vitamins $level2`;
$mess .= $info;

#level3
my $temp = `head -1 $level3`;
die "ERROR: $temp\n" unless($temp eq $head);
$info = `grep Lipopolysaccharide $level3`;
$mess .= $info;

#oxidative
$temp = `head -1 $oxidative`;
die "ERROR: $temp\n" unless($temp eq $head);
$info = `tail -1 $oxidative`;
$mess .= $info;

#H2S
$temp = `head -1 $H2S`;
die "ERROR: $temp\n" unless($temp eq $head);
$info = `tail -1 $H2S`;
$mess .= $info;

#toxin
$temp = `head -1 $toxin`;
die "ERROR: $temp\n" unless($temp eq $head);
#$info = `tail -1 $toxin`;
#$mess .= $info;

#SCFA
$temp = `head -1 $SCFA`;
die "ERROR: $temp\n" unless($temp eq $head);
$info = `tail -1 $SCFA`;
$mess .= $info;

open OUT,"> $output" or die "$!\n";
print OUT $mess;
close OUT;

#chomp(my $pwd = `pwd`);
chdir $outDir;
#if($output =~ /^\//){
    `perl $func_count $output function.stat`;
    `perl $func_health_index function.stat function_health_index`;
	`$Rscript $plotBin  $output $sample_num ./`;
#}else{
#    `$Rscript $plotBin $pwd/$output $sample_num`;
#}
