#!/usr/bin/perl -w
use strict;
use FindBin qw/$Bin/;

my $usage = <<"usage";
perl $0 gene.profile gene.ko org_sample.ko.profile output
usage
die $usage unless(@ARGV == 7);
my $KO_R = "$Bin/KO_V4.R";
my ($geneProfile,$geneKO,$orgProfile,$output,$ko_dir,$Rscript,$KO_class) = @ARGV;

my (%gene_ko,%org_KOAbun,%abun);

#print "begin\n";
open INO,$orgProfile or die "$!\n";
while(<INO>){
    chomp;
    my @temp = split /\t/;
    my $mark = shift @temp;
    my $mess = join "\t",@temp;
    $org_KOAbun{$mark} = $mess;
}
close INO;

open ING,$geneKO or die "$!\n";
while(<ING>){
    chomp;
    my @temp = split;
    my @info = split /\;/,$temp[-1];
    foreach my $ko(@info){
        next if ($ko eq 'NA');
        $gene_ko{$temp[0]}{$ko} = 1;
    }
}
close ING;

open INP,$geneProfile or die "$!\n";
open OUT,"> $output" or die "$!\n";
while(<INP>){
    chomp;
    my @temp = split /\t/;
    if($. == 1){
        print OUT "$_\t$org_KOAbun{$temp[0]}\n";
    }else{
        next unless(exists $gene_ko{$temp[0]});
        foreach my $ko(sort keys %{$gene_ko{$temp[0]}}){
            for my $i(1..$#temp){
                $abun{$ko}{$i} += $temp[$i];
            }
        }
    }
}
close INP;

foreach my $ko(sort keys %abun){
    print OUT "$ko";
    foreach my $num(sort {$a <=> $b} keys %{$abun{$ko}}){
        print OUT "\t$abun{$ko}{$num}";
    }
    print OUT "\t$org_KOAbun{$ko}\n";
}
close OUT;

mkdir $ko_dir unless (-e $ko_dir);
chdir $ko_dir;
    `$Rscript $KO_R $output $KO_class`;
