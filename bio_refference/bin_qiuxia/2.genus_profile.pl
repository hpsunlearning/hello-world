#!/usr/bin/perl -w
use strict;
use FindBin qw/$Bin/;

my $entertypeBin = "$Bin/03.enterotype.R";
#my $boxplotBin = "$Bin/genus_boxplot.R";
my $normalize_bin = "$Bin/normalize.pl";
my $genus_compair = "$Bin/Genus_V3.R";
#my $Rscript = "/ifs3/solexa/data/heyuan/R/bin/Rscript";
my $enter_3d = "$Bin/03.3d-plot.R";
my $usage=<<"usage";
perl $0 relative.profile original.genus.profile gene.genus
Rscript_path new.genus.profile outDir
usage
die $usage unless(@ARGV == 7);
my ($geneProfile,$old_genusProfile,$gene_genusFile,$Rscript,$new_genusProfile,$outDir,$bac_dir) = @ARGV;

my (%gene_genus,%abun,%org_sampleAbun);
my $sample_num;

open ING,$gene_genusFile or die "$!\n";
while(<ING>){
    chomp;
    my @temp = split /\t/;
    $gene_genus{$temp[0]} = $temp[2];
}
close ING;

open INO,$old_genusProfile or die "$!\n";
while(<INO>){
    chomp;
    my @temp = split /\t/;
    my $mark = shift @temp;
    my $mess = join "\t",@temp;
    $org_sampleAbun{$mark} = $mess;
}
close INO;

open INP,$geneProfile or die "$!\n";
open OUTT,">temp_genus.profile" or die "$!\n";
#open OUN,">$new_genusProfile" or die "$!\n";
while(<INP>){
    chomp;
    my @temp = split /\t/;
    if($. == 1){
        $sample_num = @temp - 1;
        print OUTT "$_\n";
#       print OUN "$_\t$org_sampleAbun{$temp[0]}\n";
    }else{
        next unless(exists $gene_genus{$temp[0]});
        for my $i(1..$#temp){
            $abun{$gene_genus{$temp[0]}}{$i} += $temp[$i];
        }
    }
}
close INP;

foreach my $genus(sort keys %abun){
#   print OUN $genus;
    print OUTT "$genus";
    foreach my $num(sort {$a <=> $b} keys %{$abun{$genus}}){
#       print OUN "\t$abun{$genus}{$num}";
        print OUTT "\t$abun{$genus}{$num}";
    }
#   print OUN "\t$org_sampleAbun{$genus}\n";
    print OUTT "\n";
}
#close OUN;
close OUTT;

#print "perl $normalize_bin temp_genus.profile temp_genus.profile.normalize\n";
`perl $normalize_bin temp_genus.profile temp_genus.profile.normalize`;

open INT,"temp_genus.profile.normalize" or die "$!\n";
open OUN,">$new_genusProfile" or die "$!\n";
while(<INT>){
    chomp;
    my @temp = split /\t/;
    print OUN "$_\t$org_sampleAbun{$temp[0]}\n";
}
close INT;
close OUN;

`rm temp_genus.profile`;
`rm temp_genus.profile.normalize`;

`mkdir $outDir` unless ( -e  $outDir);
#chomp(my $pwd = `pwd`);
chdir $outDir;
#if($new_genusProfile =~ /^\//){
    `$Rscript $entertypeBin $new_genusProfile $sample_num ./`;
    `$Rscript $enter_3d enterotype.out 3d-plot.pdf`;
#}else{
#    print "Rscript $entertypeBin $pwd/$new_genusProfile $sample_num\n";
#    `$Rscript $entertypeBin $pwd/$new_genusProfile $sample_num`;
#    `$Rscript $boxplotBin $pwd/$new_genusProfile $sample_num`;
#}
chdir $bac_dir;
    `$Rscript $genus_compair $new_genusProfile `
