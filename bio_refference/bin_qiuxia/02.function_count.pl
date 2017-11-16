#! /usr/bin/perl
use strict;

my $profile = shift;
my $stat = shift;

open OUT,">$stat";
open IN,"<$profile";
<IN>;
print OUT "Function name\tSample abundance\tNormal range\n";
while(<IN>){
	chomp;
	my @line = split /\t/;
	print  OUT1 "$_\n";
	my $fun = shift(@line);
	my $abu = shift(@line);
	$abu = sprintf "%.3e",$abu;
	my ($normal_min,$normal_max)=calculate(@line);
	print OUT "$fun\t$abu\t$normal_min\~$normal_max\n";
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
	$normin = sprintf "%.3e",$normin;
	$normax = sprintf "%.3e",$normax;
	return ($normin,$normax);
}
