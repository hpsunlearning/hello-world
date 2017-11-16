#!/usr/bin/perl -w
use strict;

my $index;
my $usage=<<"usage";
perl $0 specie.stat health_index
usage
die $usage unless (@ARGV==2);
my ($speciestat,$species_health_index)=@ARGV;

open IN,"<",$speciestat or die $!;
open OUT,">",$species_health_index or die $!;
my $absolute_index=0;
my $species_count=0;
while(<IN>){
	chomp;
	next if($.==1);
	$species_count++;
	my @array=split/\t/,$_;
	my $temp=$array[2];
	my @range=split/~/,$array[3];
	my $lowest=$range[0];
	my $highest=$range[1];
	if($temp >= $lowest && $temp <= $highest){
		$absolute_index++;}
}
close IN;
$index=$absolute_index/$species_count;
my $formatted_index=sprintf("%.3f",$index);
print OUT "物种\t$formatted_index\n";
close OUT;


