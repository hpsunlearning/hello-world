#! /usr/bin/perl -w
use strict;
use warnings;
use Getopt::Long;
my ($name,$prefix,@file,@samples,%reads,%profile);
GetOptions(
    "p=s"=>\@file,
    "o=s"=>\$prefix,
);
sub usage{
    print "perl $0 -p your profiles -o your output file prefix\n";
    exit(1);
}
&usage unless (@file and $prefix);
for(my $i=0;$i<=$#file;$i++){
    open IN,"gzip -dc $file[$i]|" or die;
    chomp(my $head=<IN>);
    $name = (split /\t/,$head)[1];
    push @samples,$name;
    while(<IN>){
        chomp;
        my @tmp = split /\t/;
        $reads{$tmp[0]}[$i]=$tmp[1];
        $profile{$tmp[0]}[$i]=$tmp[3];
    }
	close IN;
}
open OUT1,">","$prefix.reads_profile" or die;
open OUT2,">","$prefix.gene_profile" or die;
print OUT1 "\t";
print OUT1 join "\t",@samples;
print OUT1 "\n";
print OUT2 "\t";
print OUT2 join"\t",@samples;
print OUT2 "\n";
foreach my $key(sort{$a <=> $b}keys %reads){
    print OUT1 join "\t",$key,@{$reads{$key}};
    print OUT1 "\n";
    print OUT2 join "\t",$key,@{$profile{$key}};
    print OUT2 "\n";
}
