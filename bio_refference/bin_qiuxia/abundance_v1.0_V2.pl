#!/usr/bin/perl -w

############################################################
#	Copyright (C) 2012 BGI-shenzhen-MicrobeGroup
#	Written by Yuanlin Guan (guanyuanlin@genomics.org.cn)
#	Version: 1.0 (Jul 27th, 2012)
############################################################

use strict;
use Getopt::Std;
use FindBin;
use PerlIO::gzip;

=pod
sub usage{
	print STDERR "usage: $0 <option> <value>...\n";
	print STDERR "Options\n";
	print STDERR "\t-a : read1 file, required\n";
	print STDERR "\t-b : read2 file, optional\n";
	print STDERR "\t-c : single read file, optional\n";
	print STDERR "\t-d : geneset database, required\n";
	print STDERR "\t-g : geneset id and length information, required\n";
	print STDERR "\t-m : match mode, default 4\n";
	print STDERR "\t-s : seed length, default 30\n";
	print STDERR "\t-r : repeat hit, default 1\n";
	print STDERR "\t-n : minimal insert size, default 400\n";
	print STDERR "\t-x : maximal insert size, default 600\n";
	print STDERR "\t-v : maximum number of mismatches, default 7\n";
	print STDERR "\t-i : identity, default 0.9\n";
	print STDERR "\t-t : number of processors, default 3\n";
	print STDERR "\t-f : simple soap result, default Y (Y/N)\n";
	print STDERR "\t-z : delete soap mapping file.default delete.[Y]\n";
	print STDERR "\t-p : output prefix, required\n";
	print STDERR "\t-h : show the help message\n";
	exit(1);
}

our ($opt_a, $opt_b, $opt_c, $opt_d, $opt_g, $opt_m, $opt_s, $opt_r);
our ($opt_n, $opt_x, $opt_v, $opt_i, $opt_t, $opt_f, $opt_p, $opt_h, $opt_z);
getopts('a:b:c:d:g:m:s:r:n:x:v:i:t:f:z:p:h');
=cut

sub usage{
    print STDERR "usage: $0 <option> <value>...\n";
    print STDERR "Options\n";
    print STDERR "\t-a : alignment file, required\n";
    print STDERR "\t-g : geneset id and length information, required\n";
    print STDERR "\t-p : output prefix, required\n";
    print STDERR "\t-h : show the help message\n";
    exit(1);
}
our ($opt_a,$opt_g,$opt_p,$opt_h);
getopts('a:g:p:h');

&usage if $opt_h;
&usage unless $opt_a && $opt_g && $opt_p;
=pod
$opt_m = 4 unless $opt_m;
$opt_s = 30 unless $opt_s;
$opt_r = 1 unless $opt_r;
$opt_n = 400 unless $opt_n;
$opt_x = 600 unless $opt_x;
$opt_v = 7 unless $opt_v;
$opt_i = 0.9 unless $opt_i;
$opt_t = 3 unless $opt_t;
$opt_f = "Y" unless $opt_f;
$opt_z = "Y" unless $opt_z;
=cut

my (%readsnum, %length, @tmp, @name, @id, $i, %abundance, $total_abundance, $sam_name);
#my ($soap_path, $shell, @database, $database, $paired, $single, $single_single);

=pod
$soap_path ="/ifs5/PC_MICRO_META/PRJ/MetaSystem/analysis_flow_clone/bin/program/soap2.22";
##切分大基因集的切分建库结果
@database = split /:/, $opt_d;
$database = join " -D ", @database;

##进行soap比对
if($opt_b){
	$shell = "$soap_path -a $opt_a -b $opt_b -D $database -M $opt_m -l $opt_s -r $opt_r -m $opt_n -x $opt_x -v $opt_v -c $opt_i -p $opt_t ";
	if($opt_f eq "Y"){ ##是否输出质量值
		$shell .= "-S ";
	}
	$shell .= "-o $opt_p.abundance.soap.pe -2 $opt_p.abundance.soap.se 2> $opt_p.abundance.soap.log";
	if(system($shell)){
		print STDERR "reads align database error\n";
		exit(1);
	}
	if($opt_c){
		$shell = "$soap_path -a $opt_c -D $database -M $opt_m -l $opt_s -r $opt_r -v $opt_v -c $opt_i -p $opt_t ";
		if($opt_f eq "Y"){
			$shell .= "-S ";
		}
		$shell .= "-o $opt_p.abundance.soap.single 2> $opt_p.abundance.soap.single.log";
		if(system($shell)){
			print STDERR "single read align database error\n";
			exit(1);
		}
	}
}
else{
	$shell = "$soap_path -a $opt_a -D $database -M $opt_m -l $opt_s -r $opt_r -v $opt_v -c $opt_i -p $opt_t ";
	if($opt_f eq "Y"){
		$shell .= "-S ";
	}
	$shell .= "-o $opt_p.abundance.soap -u $opt_p.abundance.soap.unmap 2> $opt_p.abundance.soap.log";
	if(system($shell)){
		print STDERR "single read align database error\n";
		exit(1);
	}
}
=cut

##读取geneid,gene名和gene长度信息
open F, "<:gzip(autopop)", "$opt_g" or die "can't open file $opt_g $!\n";
while(<F>){
	chomp;
	@tmp = split;
	$length{$tmp[0]} = $tmp[2];
	push @id, $tmp[0];
#	push @name, $tmp[1];
}
close F;

##生成比对信息文件
=pod
open O, ">$opt_p.abundance.stat_out" or die "can't open file $opt_p.abundance.stat_out $!\n";
print O "Paired\tSingle\tSingle_Single\n";
if($opt_b){
	&get_abundance_pe("$opt_p.abundance.soap.pe");
	&get_abundance_se("$opt_p.abundance.soap.se");
	&stat_pair_log("$opt_p.abundance.soap.log");
	if($opt_c){
		&get_abundance_single("$opt_p.abundance.soap.single");
		&stat_single_log("$opt_p.abundance.soap.single.log");
		print O "$paired\t$single\t$single_single\n";
	}
	else{
		print O "$paired\t$single\t0\n";
	}
}
else{
=cut
	&get_abundance_single("$opt_a");
#	&stat_single_log("$opt_p.abundance.soap.log");
#	print O "0\t$single_single\t0\n";
#}
#close O;

$total_abundance = 0;
for($i = 0; $i < @id; $i++){
	$readsnum{$id[$i]} = 0 unless (defined $readsnum{$id[$i]});
	$abundance{$id[$i]} = $readsnum{$id[$i]} / $length{$id[$i]};
	$total_abundance += $abundance{$id[$i]};
}
$total_abundance = 1 if $total_abundance == 0;
open O, ">:gzip", "$opt_p.abundance.gz" or die "can't open file $opt_p.abundance.gz $!\n";
($opt_p=~/\//) ? ($sam_name = (split /\//,$opt_p)[-1]) : ($sam_name=$opt_p); #2015/01/07 add
print O "\t$sam_name\n"; # 2015/01/07 add
for($i = 0; $i < @id; $i++){
	print O "$id[$i]\t$readsnum{$id[$i]}\t$abundance{$id[$i]}\t", $abundance{$id[$i]} / $total_abundance, "\n";
}
close O;
#system("rm -f $opt_p.abundance.soap $opt_p.abundance.soap.single $opt_p.abundance.soap.pe $opt_p.abundance.soap.se") if($opt_z eq "Y");

=pod
sub get_abundance_pe{
	my $file = shift;
	open I, $file or die "can't open file $file $!\n";
	my @temp;
	while(<I>){
		chomp;
		@temp = split;
		next unless (1 == $temp[3]);
		$readsnum{$temp[7]} += 0.5;
	}
	close I;
}

sub get_abundance_se{
	my $file = shift;
	my (@temp, %past);
	open I, $file or die "can't open file $file $!\n";
	while(<I>){
		chomp;
		@temp = split;
		next unless ($temp[3] == 1);
		if($temp[6] eq "+"){
			if(($length{$temp[7]} - $temp[8]) < $opt_x){
				$temp[0] =~ /^(\S+)\/[12]/;
				$past{$temp[7]}{$1} = 1;
			}
		}
		elsif($temp[6] eq '-') {
			if(($temp[8]) < $opt_x - $temp[5]){
				$temp[0] =~ /^(\S+)\/[12]/;
				$past{$temp[7]}{$1} = 1;
			}
		}
	}
	close I;
	foreach my $key(keys %past){
		foreach my $read(keys %{$past{$key}}){
			if($past{$key}{$read}){
				++$readsnum{$key};
			}
		}
	}
}
=cut

sub get_abundance_single{
	my $file = shift;
	my @temp;
	open I,"-|","samtools view  $file" or die "can't open file $file $!\n";
	while(<I>){
		chomp;
		@temp = split;
#        next unless ($temp[3] == 1);
#		$temp[0] =~ /^(\S+)\/[12]/;
		$readsnum{$temp[2]}++;
	}
}

=pod
sub stat_pair_log{
	my $file = shift;
	open I, $file or die "can't open file $file $!\n";
	while(<I>){
		chomp;
		if(/^Paired:\s+(\d+)/){
			$paired = $1;
		}
		elsif(/^Singled:\s+(\d+)/){
			$single = $1;
		}
	}
	close I;
}

sub stat_single_log{
	my $file = shift;
	open I, $file or die "can't open file $file $!\n";
	while(<I>){
		chomp;
		if(/^Alignment:\s+(\d+)/){
			$single_single = $1;
			last;
		}
	}
	close I;
}
=cut
