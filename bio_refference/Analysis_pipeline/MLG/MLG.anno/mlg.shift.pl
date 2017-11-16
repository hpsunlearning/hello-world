#!/usr/bin/perl 

open FILE,"<","@ARGV[0]" or die "can't find the file\n";
open OUT,">","@ARGV[1]";

while (<FILE>)
        { chomp ;
        @seq = split(/\t/,$_);
        $mlgid=@seq[0];
        @gene= split(/,/,@seq[3]);
        foreach $geneid (@gene){
        printf OUT"$geneid\n";
                               }
        }

close FILE;
close OUT;

