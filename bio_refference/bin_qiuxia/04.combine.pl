#! /usr/bin/perl
use strict;

#my $pro1 = "4.3M.gene_profile";
#my $pro2 = "StageI_StageII.gene.relative_abun";
#my $out = "t2samples_345sample_gene.pro";
my $pro1 = $ARGV[0];
my $pro2 = $ARGV[1];
my $out = $ARGV[2];

open IN1,"<$pro1" or die;
open IN2,"<$pro2" or die;
open OUT,">$out" or die;
while(<IN1>){
	chomp;
	my $line2 = <IN2>;
	my @array = split /\t/,$line2,2;
	print OUT "$_\t$array[1]";
#	print "$_\t$array[1]";
}
close IN1;
close IN2;
close OUT;
