#!/usr/bin/perl -w
use strict;
use FindBin qw/$Bin/;

#my $SCFA_list = "$Bin/../data/SCFA.gene.list";
my $diversityBin = "$Bin/alpha_shannon.pl";

#die "usage: perl $0 gene_reletive.profile sample.number output outdir\n" unless(@ARGV == 4);
my $usage = <<"usage";
perl $0 gene.profile org_sample_gene.profile SCFA_list pic_dir Rscript_path sample.number total_gene.profile
diversity diversity.dir SCFA_gene.profile function.dir
usage
die $usage unless (@ARGV == 10);

#my $Rscript = "/ifs3/solexa/data/heyuan/R/bin/Rscript";
my $bin = "$Bin/diversity.R";
#my $pic = "$Bin/../data/pic";
my ($pro,$org_pro,$SCFA_list,$Rscript,$sampleNumber,$total_pro,$diversity,$div_dir,$SCFA_pro,$fun_dir) = @ARGV;
my (%target_gene,%abun,%SCFA_abun);

############# total gene profile ############
open INO,$org_pro or die "$!\n";
while(<INO>){
	chomp;
	my @temp = split /\t/;
	my $mark = shift @temp;
	my $mess = join "\t",@temp;
	$abun{$mark} = $mess;
}
close INO;

open INP,$pro or die "$!\n";
open OUT,">$total_pro" or die "$!\n";
while(<INP>){
	chomp;
	my @temp = split /\t/;
	print OUT "$_\t$abun{$temp[0]}\n";
}
close INP;
close OUT;

############# SCFA profile ###########
`mkdir $fun_dir` unless ( -e $fun_dir);
open INS,"$SCFA_list" or die "$!\n";
while(<INS>){
    chomp;
    my @temp = split;
    $target_gene{$temp[0]} = "SCFA";
}
close INS;

open INT,$total_pro or die "$!\n";
open OUS,"> $SCFA_pro" or die "$!\n";
while(<INT>){
    chomp;
    if($. == 1){
        print OUS "$_\n";
    }else{
        my @temp = split /\t/;
        next unless(exists $target_gene{$temp[0]});
        for my $i(1..$#temp){
            $SCFA_abun{$target_gene{$temp[0]}}{$i} += $temp[$i];
        }
    }
}
close INT;

foreach my $S(sort keys %SCFA_abun){
    print OUS "$S";
    foreach my $num(sort {$a <=> $b} keys %{$SCFA_abun{$S}}){
        print OUS "\t$SCFA_abun{$S}{$num}";
    }
    print OUS "\n";
}
close OUS;

############ diversity profile ################

`mkdir $div_dir` unless ( -e $div_dir);
#chomp(my $pwd = `pwd`);
#if($total_pro =~ /\//){
    `perl $diversityBin $total_pro $diversity`;
chdir $div_dir;
    `$Rscript $bin $diversity`;
#}else{
#    `perl $diversityBin $pwd/$total_pro $diversity`;
#    `$Rscript $bin $diversity $sampleNumber`;
#}
#chdir $pwd;

