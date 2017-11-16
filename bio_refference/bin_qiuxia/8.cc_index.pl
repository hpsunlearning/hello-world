#!/usr/bin/perl -w
use strict;
use FindBin qw/$Bin/;

#my $geneList = "$Bin/../data/CC.31.gene.marker";
my $bin = "$Bin/04.CC_risk.R";
my $CC_species_marker = "$Bin/04.CC_speciesmarker.R";
my $CC_risk_distribution = "$Bin/CC_risk.R";
#my $Rscript = "/ifs3/solexa/data/heyuan/R/bin/Rscript";
#my $config = "$Bin/../data/config";
#my $pic = "$Bin/../data/pic";

#print STDERR "$geneList\n";
die "usage: perl $0 gene.profile org_sample_gene.profile geneList config
pic_dir Rscript_path total_gene.profile sample.num target_gene.pro CC_dir\n"
unless(@ARGV == 12);
my
($pro,$org_pro,$geneList,$config,$pic,$Rscript,$total_pro,$sampleNum,$targetPro,$CC_dir,$species_marker,$CC_control_risk) = @ARGV;
my (%abun,%gene);
############ total gene profile #################
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
############target gene profile ###################

open ING,$geneList or die "$!\n";
while(<ING>){
    chomp;
    my @temp = split;
    $gene{$temp[0]} = 1;
}
close ING;

open INP,$total_pro or die "$!\n";
open OUT,">$targetPro" or die "$!\n";
my $head = <INP>;
print OUT $head;
while(<INP>){
    chomp;
    my @temp = split /\t+/;
    print OUT $_."\n" if(exists $gene{$temp[0]});
}
close INP;
close OUT;
#################################################
`mkdir -p $CC_dir` unless (-e $CC_dir);
#chomp(my $pwd = `pwd`);
chdir $CC_dir;
#if($targetPro =~ /^\//){
    `$Rscript $bin $targetPro 1 $config ./`;
    `$Rscript $CC_species_marker ../CC_129samples_species.pro 1 $species_marker $config ./`;
    `$Rscript $CC_risk_distribution $CC_control_risk CC.risk.txt`;
#}else{
#    `$Rscript $bin $pwd/$targetPro $geneList $sampleNum "CC"`;
#    `$Rscript $bin2 $config $sampleNum`;
#}
#chdir $pwd;
open IN,"$CC_dir/CC.risk.txt" or die;
while(<IN>){
    chomp;
    if($.==2){
        my @tmp = split /\t/;
        my ($name,$value) = @tmp[0..1];
        if ($value <= 0.1){
            `cp $pic/dis_1.png $CC_dir/$name"_CC".png`;
        }elsif($value <= 0.2){
            `cp $pic/dis_2.png $CC_dir/$name"_CC".png`;
        }elsif($value <= 0.3){
            `cp $pic/dis_3.png $CC_dir/$name"_CC".png`;
        }elsif($value <= 0.4){
            `cp $pic/dis_4.png $CC_dir/$name"_CC".png`;
        }elsif($value <= 0.5){
            `cp $pic/dis_5.png $CC_dir/$name"_CC".png`;
        }elsif($value <= 0.6){
            `cp $pic/dis_6.png $CC_dir/$name"_CC".png`;
        }elsif($value <= 0.7){
            `cp $pic/dis_7.png $CC_dir/$name"_CC".png`;
        }elsif($value <= 0.8){
            `cp $pic/dis_8.png $CC_dir/$name"_CC".png`;
        }elsif($value <= 0.9){
            `cp $pic/dis_9.png $CC_dir/$name"_CC".png`;
        }elsif($value <= 1.0){
            `cp $pic/dis_10.png $CC_dir/$name"_CC".png`;
        }
    } 
}
close IN;

