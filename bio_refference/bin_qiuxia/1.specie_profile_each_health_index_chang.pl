#!/usr/bin/perl -w
use strict;
use FindBin qw/$Bin/;

#my $opp_file = "$Bin/../data/oppo.bac.species";
#my $ben_file = "$Bin/../data/benefit.bac.species";
#my $BeneBin = "$Bin/ben_boxplot.R";
#my $OppoBin = "$Bin/oppo_boxplot.R";
my $quanBin = "$Bin/quantile.R";
my $bac_count = "$Bin/01.bac_count.pl";
my $phylum_count = "$Bin/phylum_calculate.pl";
my $bac_boxplot = "$Bin/01.bac_boxplot.R";
my $Phylum_pic = "$Bin/Phylum_V3.R";
my $species_anno = "$Bin/04.gene_species.pl";
my $combine = "$Bin/04.combine.pl"; 
my $species_health_index ="$Bin/species_health_index.pl";
#my $Rscript = "/ifs3/solexa/data/heyuan/R/bin/Rscript";
my $opp_stat = "oppo.stat";
#my $ben_stat = "ben.stat";

my $usage=<<"usage";
perl $0 gene.profile gene.specie foodborne.specie 
orgSample.specie.pro bacteria_list Rscript SampleNumber total.specie.profile 
foodborne.specie.profile bacteria_dir foodborne
usage
die $usage unless (@ARGV==18);
my($geneProfile,$geneSpecie,$geneProfile2,$geneSpecie2,$foodborneSpecie,$orgSample_speciePro,$bac_list,$tree_list,$Rscript,$sampleNumber,$totalSpecieProfile,$foodborneProfile,$bac_dir,$foodborne,$T2D_species_pro,$CC_species_pro,$Obese_species_pro,$IBD_species_pro) = @ARGV;
my (%specie,%abun,%target,%orgPro,%bac);

open INS,$geneSpecie or die "$!\n";
while(<INS>){
    chomp;
    my @temp = split /\t/;
    $specie{$temp[0]} = $temp[2];
}
close INS;

open INT,$foodborneSpecie or die "$!\n";
while(<INT>){
    chomp;
    my @temp = split /\t/;
    $target{$temp[0]} = 0;
}
close INT;

open INO,$orgSample_speciePro or die "$!\n";
while(<INO>){
    chomp;
    my @temp = split /\t/;
    my $mark = shift @temp;
    my $mess = join "\t",@temp;
    $orgPro{$mark} = $mess;
}
close INO;

open ING,$geneProfile or die "$!\n";
open OUT,">$totalSpecieProfile" or die "$!\n";
open OUTT,">$foodborneProfile" or die "$!\n";
#my $head = <ING>;
#print OUT $head;
#print OUTT $head;
while(<ING>){
    chomp;
    if($. == 1){
        my @temp = split /\t/;
        print OUT "$_\t$orgPro{$temp[0]}\n";
        print OUTT "$_\t$orgPro{$temp[0]}\n";
    }else{
        my @temp = split /\t/;
        next unless(exists $specie{$temp[0]});
        for my $i(1..$#temp){
            $abun{$specie{$temp[0]}}{$i} += $temp[$i];
        }    
    }
}
close ING;

foreach my $spe(sort keys %abun){
    print OUT "$spe";
    print OUTT "$spe" if(exists $target{$spe});
    foreach my $num(sort {$a <=> $b} keys %{$abun{$spe}}){
        print OUT "\t$abun{$spe}{$num}";
        print OUTT "\t$abun{$spe}{$num}" if(exists $target{$spe});
    }
    print OUT "\t$orgPro{$spe}\n";
    print OUTT "\t$orgPro{$spe}\n" if(exists $target{$spe});
}
close OUT;
close OUTT;

`less -S $foodborneProfile|awk -F "\\t" 'NR>1{if(\$2>0.001){print \$1}}' > $foodborne`;

open INO,$bac_list or die "$!\n";
while(<INO>){
	chomp;
	next if ($_=~/^#/);
	my @line = split /\t/,$_;
	$bac{$line[0]} = 1;
}
close INO;

my (@sample);
=pod
open INP,$totalSpecieProfile or die "$!\n";
open OUO,">bac_pro" or die "$!\n";
while(<INP>){
    chomp;
    if($. == 1){
        @sample = split /\t/;
        print OUO "$_\n";
    }else{
        my @temp = split /\t/;
    	if (exists $bac{$temp[0]}){
	    	my @temp2 = @temp;
	    	$temp2[0] = $bac{$temp[0]};
	    	print OUO join "\t",@temp2;
	    	print OUO "\n";
        }
    }
}
close INP;
close OUO;
=cut

`perl $species_anno $geneProfile $geneSpecie sample_4.3M_species.pro`;
`perl $combine sample_4.3M_species.pro $T2D_species_pro T2D_346samples_species.pro`;
`perl $combine sample_4.3M_species.pro $CC_species_pro CC_129samples_species.pro`;
`perl $species_anno $geneProfile2 $geneSpecie2 sample_9.9M_species.pro`;
`perl $combine sample_9.9M_species.pro $Obese_species_pro Obese_201samples_species.pro`;
`perl $combine sample_9.9M_species.pro $IBD_species_pro IBD_86samples_species.pro`;
`mkdir -p $bac_dir` unless(-e $bac_dir);
#chomp(my $pwd = `pwd`);
`perl $bac_count $bac_list $totalSpecieProfile $bac_dir/out.specie.pro $bac_dir/specie.stat`;
`perl $species_health_index $bac_dir/specie.stat $bac_dir/species_health_index`;
`perl $phylum_count $tree_list $totalSpecieProfile $bac_dir/phylum.pro`;
#if($opp_abun =~ /^\//){
chdir $bac_dir;
	`$Rscript $bac_boxplot out.specie.pro $sampleNumber ./`;
    `$Rscript $Phylum_pic phylum.pro`;
#}else{
#	`$Rscript $OppoBin $pwd/$opp_abun $sampleNumber`;
#	`$Rscript $quanBin $pwd/$opp_abun $sampleNumber $opp_stat`;
#}

#chdir $pwd;
#`mkdir -p $ben_dir` unless(-e $ben_dir);
#chomp(my $pwd = `pwd`);
#chdir $ben_dir;
#if($opp_abun =~ /^\//){
#	`$Rscript $BeneBin $ben_abun $sampleNumber`;
#	`$Rscript $quanBin $ben_abun $sampleNumber $ben_stat`;
#}else{
#	`$Rscript $BeneBin $pwd/$ben_abun $sampleNumber`;
#	`$Rscript $quanBin $pwd/$ben_abun $sampleNumber $ben_stat`;
#}


#`convert -density 72 a.pdf a.jpg
