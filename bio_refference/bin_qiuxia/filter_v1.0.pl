#!/usr/bin/perl -w

############################################################
#	Copyright (C) 2012 BGI-shenzhen-MicrobeGroup
#	Written by Yuanlin Guan (guanyuanlin@genomics.org.cn)
#	Version: 1.0 (Jul 27th, 2012)
############################################################
use strict;
use Getopt::Std;
use PerlIO::gzip;

sub usage{
	print STDERR "usage: $0 <option> <value>...\n";
	print STDERR "Options\n";
	print STDERR "\t-a : raw read1 file, required\n";
	print STDERR "\t-b : raw read2 file, optional\n";
	print STDERR "\t-c : read1 adapter file, required\n";
	print STDERR "\t-d : read2 adapter file, optional\n";
	print STDERR "\t-l : adapter length, default 15\n";
	print STDERR "\t-n : read sequence N number, default 3\n";
	print STDERR "\t-p : output prefix, require\n";
	print STDERR "\t-h : show the help message\n";
	exit(1);
}

our ($opt_a, $opt_b, $opt_c, $opt_d, $opt_l, $opt_n, $opt_p, $opt_h);
getopts('a:b:c:d:l:n:p:h');

&usage if $opt_h;
$opt_l = 15 unless $opt_l;
$opt_n = 3 unless $opt_n;
&usage unless $opt_a and $opt_c and $opt_p;

my ($clean1, $clean2, $single, $stat);
my (@temp, $name, %a_list_rm1, %a_list_rm2, $total_num, $pair_num, $read1_single, $read2_single);
my ($name1, $seq1, $head1, $qual1, $name2, $seq2, $head2, $qual2, $flag);

open FQ1, "<:gzip(autopop)", "$opt_a" or die "can't open file $opt_a $!\n";
open A1, "<:gzip(autopop)", "$opt_c" or die "can't open file $opt_c $!\n";
if($opt_b && $opt_d){
	open FQ2, "<:gzip(autopop)", "$opt_b" or die "can't open file $opt_b $!\n";
	open A2, "<:gzip(autopop)", "$opt_d" or die "can't open file $opt_d $!\n";
}

if($opt_b && $opt_d){
	$clean1 = "$opt_p.clean.1.fq.gz";
	$clean2 = "$opt_p.clean.2.fq.gz";
	$single = "$opt_p.clean.single.fq.gz";
	$stat = "$opt_p.clean.stat_out";
	open C1, ">:gzip", "$clean1" or die "can't open file $clean1 $!\n";
	open C2, ">:gzip", "$clean2" or die "can't open file $clean2 $!\n";
	open S, ">:gzip", "$single" or die "can't open file $single $!\n";
	open O, ">$stat" or die "can't open file $stat $!\n";
}
else{
	$clean1 = "$opt_p.clean.fq.gz";
	$stat = "$opt_p.clean.stat_out";
	open C1, ">:gzip", "$clean1" or die "can't open file $clean1 $!\n";
	open O, ">$stat" or die "can't open file $stat $!\n";
}

<A1>;
while(<A1>){
	chomp;
	next unless($_);

	@temp = split;
	$temp[0] =~ /^(.+)\/(\d)$/;
	$name = $1;
	if($temp[8] >= $opt_l){
		$a_list_rm1{$name} = undef;
	}
}
close A1;
if($opt_b && $opt_d){
	<A2>;
	while(<A2>){
		chomp;
		next unless($_);
		@temp = split;
		$temp[0] =~ /^(.+)\/(\d)$/;
		$name = $1;
		if( $temp[8] >= $opt_l){
			$a_list_rm2{$name} = undef;
		}
	}
	close A2;
}

$total_num = 0;
$pair_num = 0;
$read1_single = 0;
$read2_single = 0;
$flag = 0;
while(<FQ1>){
	chomp;
	next unless($_);
	$total_num++;
	$name1 = $_;
	if(/^\@(.+)\/(\d)/){
		$seq1 = <FQ1>;$head1 = <FQ1>;$qual1 = <FQ1>;
		if(exists $a_list_rm1{$1} or ($seq1 =~ tr/nN/nN/) >= $opt_n or $seq1 =~ /^[aA]+$/
			or $seq1 =~ /^[cC]+$/ or $seq1 =~ /^[gG]+$/ or $seq1 =~ /^[tT]+$/){
			$flag = 1;
		}else{
			$flag = 0;
		}
	}else{
		print STDERR "error $opt_a : $_\n";
		exit(1);
	}
	
	if($opt_b && $opt_d){
		$name2 = <FQ2>;
		if($name2 =~ /^\@(.+)\/(\d)/){
			$seq2 = <FQ2>;$head2 = <FQ2>;$qual2 = <FQ2>;
			if(0 == $flag){
				if(exists $a_list_rm2{$1} or ($seq2 =~ tr/nN/nN/) >= $opt_n or $seq2 =~ /^[aA]+$/
					or $seq2 =~ /^[cC]+$/ or $seq2 =~ /^[gG]+$/ or $seq2 =~ /^[tT]+$/){
					print S "$name1\n$seq1$head1$qual1";
					$read1_single++;
				}else{
					print C1 "$name1\n$seq1$head1$qual1";
					print C2 "$name2$seq2$head2$qual2";
					$pair_num++;
				}
			}elsif(1 == $flag){
				unless(exists $a_list_rm2{$1} or ($seq2 =~ tr/nN/nN/) >= $opt_n or $seq2 =~ /^[aA]+$/
					or $seq2 =~ /^[cC]+$/ or $seq2 =~ /^[gG]+$/ or $seq2 =~ /^[tT]+$/){
					print S "$name2$seq2$head2$qual2";
					$read2_single++;
				}
			}
		}else{
			print STDERR "error $opt_b : $name2\n";
			exit(1);
		}
	}
	elsif(0 == $flag){
		print C1 "$name1\n$seq1$head1$qual1";
		$pair_num++;
	}
}

print O "Total\tPair\tSingle1\tSingle2\n";
print O "$total_num\t$pair_num\t$read1_single\t$read2_single\n";

close FQ1;
close C1;
close O;
if($opt_b && $opt_d){
	close FQ2;
	close C2;
	close S;
}

