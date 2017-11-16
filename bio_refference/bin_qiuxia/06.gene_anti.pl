#! /usr/bin/perl
use strict;

my $genepro = shift;
my $Gene_anti = shift;
my $outpro = shift;

my (%hash,%abu);
open LIST,"<$Gene_anti";
%hash=map{chomp;(split/\t/,$_)[0,1]}<LIST>;
close LIST;

open IN,"<$genepro";
open OUT,">$outpro";
while(<IN>){
	if ($.==1){
		print OUT $_;
		next;
	}
	chomp;
	my @line = split /\t/;
	next unless ($hash{$line[0]});
	my $id = shift(@line);
	my @anti = split/\,/,$hash{$id};
	foreach my $a(@anti){
		if ($abu{$a}){
			my @tmp = split /\t/,$abu{$a};
			foreach my $n(0..$#tmp){
				$tmp[$n]+=$line[$n];
			}
			$abu{$a}=join "\t",@tmp;
		}
		else {
			$abu{$a}=join "\t",@line;
		}
	}	
}
close IN;

foreach (keys %abu){
	print OUT "$_\t$abu{$_}\n";
}
close OUT;
