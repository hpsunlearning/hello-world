#! /usr/bin/perl
use strict;

my $bac_list = shift;
my $profile = shift;
my $outpro = shift;
my $stat = shift;
my $tree = "/ifs3/solexa/data/heyuan/Meta/prepare_data/01.taxonomy/NewTree/merge_tree_6levels_withoutViruses";
my (%bac,%phy,%oppo,%bene);

open OUT1,">$outpro";
open OUT2,">$stat";

open IN,"<$bac_list";
%bac=map{chomp;$_.="\t-";(split/\t/,$_)[0,1]}<IN>;
close IN;

open IN,"</ifs3/solexa/data/heyuan/Meta/Samples/PO069/data/oppo.bac.species";
%oppo = map{chomp;(split/\t/,$_)[0,1]}<IN>;
close IN;
open IN,"</ifs3/solexa/data/heyuan/Meta/Samples/PO069/data/benefit.bac.species";
%bene = map{chomp;(split/\t/,$_)[0,1]}<IN>;
close IN;

open IN,"<$tree";
<IN>;
while (<IN>){
	chomp;
	my @line = split /\t/;
	my $phy =(split/\:/,$line[0],2)[1];
	my $spe = (split/\:/,$line[-1],2)[1];
	next unless ($bac{$spe});
	$phy{$spe}=$phy; 
}
close IN;

open IN,"<$profile";
my $out = <IN>;
print OUT1 $out;
print OUT2 "Chinese name\tSpecies name\tSample abundance\tNormal range\tPhylum\n";
while(<IN>){
	chomp;
	my @line = split /\t/;
	next unless ($bac{$line[0]});
	print  OUT1 "$_\n";
	my $spe = shift(@line);
	my $abu = shift(@line);
	$abu = sprintf "%.3e",$abu unless ($abu == 0);
	my ($normal_min,$normal_max)=calculate(@line);
	my $out = "$bac{$spe}\t$spe\t$abu\t$normal_min\~$normal_max\t$phy{$spe}";
	if ($oppo{$spe}){$out.="\toppo\n";}
	elsif ($bene{$spe}){$out.="\tbene\n";}
	else {$out.="\n";}
	print OUT2 $out;

}
close IN;

#########################################
sub calculate{
	my @array = @_;
        my ($normin,$normax);

        for my $i(1..$#array){
		                if ($array[$i]<$array[$i-1]){
                        my $j = $i-1;
                        my $x = $array[$i];
                        $array[$i]=$array[$i-1];
                        while ($x<$array[$j] && $j>-1){
                                $array[$j+1]=$array[$j];
                                $j=$j-1;
                        }
                        $array[$j+1]=$x;        
                }
        }
      	$normin = $array[int(($#array+1)*0.1)-1];
        $normax = $array[int(($#array+1)*0.9)-1];	
	$normin = sprintf "%.3e",$normin unless ($normin == 0);
	$normax = sprintf "%.3e",$normax unless ($normax == 0);
	return ($normin,$normax);
}
