use strict;
use warnings;
open IN1,$ARGV[0] or die;
open IN2,$ARGV[1] or die;
open OUT,">",$ARGV[2] or die;
my(%hash,%common,$all,$sam);
my @tmp=split /\t/,<IN1>;
shift @tmp;
$all=join "\t",@tmp;
%hash=map{chomp;(split /\t/,$_,2)[0..1]}<IN1>;
close IN1;
$sam=(split /\t/,<IN2>)[1];
print OUT "\t$sam\t$all";
while(<IN2>){
    chomp;
    next unless $hash{(split /\t/)[0]};
    $common{(split /\t/)[0]} = (split /\t/)[1];
}
close IN2;
foreach my $key(sort keys %common){
    print OUT join "\t",$key,$common{$key},$hash{$key};
    print OUT "\n";
}
