#!/usr/bin/env perl

use strict;
use warnings;
use PerlIO::gzip;

my $bam_file = shift;
my $fq_file  = shift;

open my $fh_bam, "-|",     "samtools view $bam_file";
open my $fh_fq,  "| gzip > $fq_file";
local $, = "\n";

while (<$fh_bam>) {
    my ( $name, $seq, $qual ) = (split)[ 0, 9, 10 ];
#    $qual =~ s/(.)/chr ord($1) + 31/ge;
    next if (length($seq) < 35);
    print $fh_fq join "\n","\@$name", $seq, "+", $qual;
    print $fh_fq "\n";
}

close $fh_bam;
close $fh_fq;
