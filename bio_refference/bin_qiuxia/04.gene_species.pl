#! /usr/bin/perl
use strict;

my $genepro =  $ARGV[0];
my $gene_anno = $ARGV[1];
my $spepro = $ARGV[2];

my (%anno,%abun);
open ANNO,"<$gene_anno";
while(<ANNO>){
	chomp;
	my @line = split /\t/;
	$anno{$line[0]}=$line[-1];
}
close ANNO;

open IN,"<$genepro";
open OUT,">$spepro";
my $line=<IN>;
print OUT $line;
while(<IN>){
	chomp;
	my @line = split /\t/;
	next unless ($anno{$line[0]});
	for my $i(1..$#line){
            $abun{$anno{$line[0]}}{$i} += $line[$i];
        }
}
close IN;

foreach my $spe(sort keys %abun){
	print OUT "$spe";
	foreach my $num(sort {$a <=> $b} keys %{$abun{$spe}}){
		print OUT "\t$abun{$spe}{$num}";
	}
	print OUT "\n";
}
