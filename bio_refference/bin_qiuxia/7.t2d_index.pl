#!/usr/bin/perl -w
use strict;
use FindBin qw/$Bin/;

#my $geneList = "$Bin/../data/T2D.50.gene.marker";
my $bin = "$Bin/Health_index.R";
my $bin2 = "$Bin/T2D.R";
my $T2D_species_marker = "$Bin/04.T2D_speciesmarker.R";
my $T2D_index_distribution = "$Bin/T2D_index_terminal.R";
my $T2D_tendency = "$Bin/T2D_tendency.R";
#my $Rscript = "/ifs3/solexa/data/heyuan/R/bin/Rscript";
#my $control_list = "$Bin/../data/T2D.control.list";
#my $pic = "$Bin/../data/pic";

#print STDERR "$geneList\n";
my $usage = <<"usage";
perl $0 gene.profile org_sample_gene.profile gene_list
control_list pic_dir Rscript_path sample.num targe_gene.pro T2D_dir
usage
die $usage unless(@ARGV == 11);
my($pro,$org_pro,$geneList,$control_list,$pic,$Rscript,$sampleNum,$targetPro,$T2D_dir,$species_marker,$control_198) = @ARGV;
my (%abun,%gene);
#################################################
open ING,$geneList or die "$!\n";
while(<ING>){
    chomp;
    my @temp = split;
    $gene{$temp[0]} = 1;
}
close ING;

open INP,"<$pro" or die "$!\n";
open OUT,">tmp.pro" or die "$!\n";
my $head = <INP>;
print OUT $head;
while(<INP>){
    chomp;
    my @temp = split /\t+/;
    print OUT $_."\n" if(exists $gene{$temp[0]});
}
close INP;
close OUT;
##################################################
open INO,$org_pro or die "$!\n";
while(<INO>){
        chomp;
        my @temp = split /\t/;
        my $mark = shift @temp;
        my $mess = join "\t",@temp;
        $abun{$mark} = $mess;
}
close INO;

open INP,"<tmp.pro" or  die "$!\n";
open OUT,">$targetPro" or die "$!\n";
while(<INP>){
        chomp;
        my @temp = split /\t/;
        print OUT "$_\t$abun{$temp[0]}\n";
}
close INP;
close OUT;

#################################################
`rm tmp.pro`;
`mkdir -p $T2D_dir` unless (-e $T2D_dir);
chdir $T2D_dir;
#chomp(my $pwd = `pwd`);
#if($geneList =~ /^\//){
#print "$Rscript\t$T2D_species_marker\t../T2D_346samples_species.pro\t1\t$species_marker\t$control_list\t./\n";
#print "$Rscript\t$T2D_index_distribution\t$control_198\tT2D_index.txt\n";
#print "$Rscript\t$T2D_tendency\t$targetPro\t$control_list\n";
#exit 0;
    `$Rscript $bin $targetPro $geneList $sampleNum "T2D"`;
    `$Rscript $bin2 $control_list $sampleNum`;
    `$Rscript $T2D_species_marker ../T2D_346samples_species.pro  1 $species_marker $control_list ./`;
    `$Rscript $T2D_index_distribution $control_198 T2D_index.txt`;
    `$Rscript $T2D_tendency $targetPro $control_list $geneList`; 
#}else{
#    `$Rscript $bin $targetPro $pwd/$geneList $sampleNum "T2D"`;
#    `$Rscript $bin2 $pwd/$control_list $sampleNum`;
#}
#chdir $pwd;
open IN,"$T2D_dir/T2D" or die;
while(<IN>){
    chomp;
    my @tmp = split /\t/;
    next if @tmp < 2;
    my ($name,$value) = @tmp[0..1];
    if ($value <= 0.15){
        `cp $pic/dis_1.png $T2D_dir/$name"_T2D".png`;
    }elsif($value <= 0.3){
        `cp $pic/dis_2.png $T2D_dir/$name"_T2D".png`;
    }elsif($value <= 0.45){
        `cp $pic/dis_3.png $T2D_dir/$name"_T2D".png`;
    }elsif($value <= 0.6){
        `cp $pic/dis_4.png $T2D_dir/$name"_T2D".png`;
    }elsif($value <= 0.7){
        `cp $pic/dis_5.png $T2D_dir/$name"_T2D".png`;
    }elsif($value <= 0.8){
        `cp $pic/dis_6.png $T2D_dir/$name"_T2D".png`;
    }elsif($value <= 0.875){
        `cp $pic/dis_7.png $T2D_dir/$name"_T2D".png`;
    }elsif($value <= 0.95){
        `cp $pic/dis_8.png $T2D_dir/$name"_T2D".png`;
    }elsif($value <= 0.975){
        `cp $pic/dis_9.png $T2D_dir/$name"_T2D".png`;
    }elsif($value <= 1.0){
        `cp $pic/dis_10.png $T2D_dir/$name"_T2D".png`;
    }
}
close IN;
