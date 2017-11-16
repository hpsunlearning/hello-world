#! /usr/bin/perl
use strict;
use warnings;
my($list,$in,$out)=@ARGV;
open LI,$list or die;
open IN,$in or die;
open OUT,">",$out or die;
my(%hash,%abun,$head);
<LI>;
while(<LI>){
    chomp;
    my @tmp=split /\t/;
    next if ($tmp[0]=~/-/ or $tmp[-1]=~/-/);
    my $phy=(split /:/,$tmp[0],2)[1];
    my $spe=(split /:/,$tmp[-1],2)[1];
#    print "$phy\t$spe\n";
    $hash{$spe}{$phy}=1;
}
close LI;

$head=<IN>;
while(<IN>){
    chomp;
    my @temp=split /\t/;
    my $spe=shift @temp;
    next unless defined $hash{$spe};
    foreach my $phy(keys %{$hash{$spe}}){
        for my $i(0..$#temp){
            $abun{$phy}{$i} += $temp[$i];
        }          
    }
}
close IN;
print OUT $head;
foreach my $phy(sort keys %abun){
    print OUT "$phy\t";
    my @all;
    foreach my $i(sort {$a <=> $b} keys %{$abun{$phy}}){
        push @all,$abun{$phy}{$i};
    }
    print OUT join "\t",@all;
    print OUT "\n";
}
close OUT;
