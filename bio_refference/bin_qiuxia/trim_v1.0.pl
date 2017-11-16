#!/usr/bin/perl -w
use strict;
use Getopt::Std;
use FindBin;
use PerlIO::gzip;

sub usage{
       print STDERR "Usage: fastq_trim_filter [method] [options]
                     method: fastx / solexaqa / bwa , default fastx
                     fastx: http://hannonlab.cshl.edu/fastx_toolkit
                     solexaqa and bwa: http://sourceforge.net/projects/solexaqa\n";
       print STDERR  "options:\n";
       print STDERR "-a <str> pair-end fastq1 file
                     or single fastq file if not set -b
                     notice: now only support illumina format\n";
       print STDERR "-b <str> pair-end fastq2 file\n";
       print STDERR "-f <int> first base to keep of -a fq1, default 1\n";
       print STDERR "-2 <int> first base to keep of -b fq2, default 1\n";
       print STDERR "-l <int> minimun length after trimming, default 30\n";
       print STDERR "-q <int> quality threshold, default 20\n";
       print STDERR "-Q <int> ascii quality offset, only can set 64/33/0, default 64
                     64 for solexa format, 33 for sanger format, 0 for auto detect
                     do not change the format in trimmed result\n";
       print STDERR "-p <int> Minimum percent of bases that must have [-q] quality
                     only apply to fastx method, default 50\n";
       print STDERR "-o <str> prefix of file name after trimming
                     output to prefix.trim.1.fq.gz, prefix.trim.2.fq.gz, prefix.trim.single.fq.gz
                     output to prefix.trim.fq.gz if only set -a\n";
       print STDERR "-h       show this help\n";

}

our($opt_a,$opt_b,$opt_f,$opt_2,$opt_l,$opt_q,$opt_Q,$opt_p,$opt_o,$opt_h);
getopts('a:b:f:2:l:q:Q:p:o:h');

&usage if $opt_h;
&usage unless $opt_a && $opt_o;
$opt_f ||=1;
$opt_2 ||=1;
$opt_l ||=30;
$opt_q ||=20;
$opt_Q ||=64;
$opt_p ||=50;

$/ = "@";
open IN,"<:gzip(autopop)",$opt_a or die;
open OUT,">:gzip","$opt_o.trim.fq.gz" or die;
<IN>;
while(<IN>){
    chomp;
    my($name,$seq,$info,$qual) = split /\n/;
    my $length = length($seq);
    my @base_qual = split //,$qual;
    my $low_qual_num = grep{(ord($_)-64)<20}@base_qual;
    my $percentage = $low_qual_num/$length*100;
    if($length>30 && $percentage<50){
        print OUT join "\n","@".$name,$seq,$info,$qual;
        print OUT "\n";
    }
}
$/="\n";
close IN;
close OUT;
