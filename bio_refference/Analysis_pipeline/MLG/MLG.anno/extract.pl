#!/usr/bin/perl -w
use strict;
use Getopt::Std;
sub usage{
	print STDERR <<USAGE;
	Vision 1.0 2011-11-28 
	Usage: perl $0 -i <input> -t <list> -o <output>
	Options
	-i <c>:  input data profile
	-t <c>:  target list
	-o <c>:  output data profile
	-r    :  extract info by row
	-s    :  sort by list order or not
	-T    :  if the table have title, -T is needed
USAGE
}
our ($opt_i,$opt_t,$opt_o,$opt_r,$opt_s,$opt_T);
getopts("i:t:o:rsT");
unless($opt_i && $opt_t && $opt_o){
	usage;
	exit;
}
my $input = $opt_i;   # input file
my $list = $opt_t;    # target list
my $output = $opt_o;  # output file

if(!defined $opt_r){
my %h;
my $t0 = 0;
open IN,"$list" or die "No such file $list\n";
my @order;
while(<IN>){
	$t0++;
	chomp;
	my @temp = split /\t/,$_;
	$h{$temp[0]} = 1;
	push @order,$temp[0];
}
close IN;

open IN,"$input" or die "No such file $input\n";
my $title = <IN>;
chomp $title;
my @T = split /\t/,$title;
shift @T;
my $t1 = @T;

my @ID;
my @col_name;
my %order_id;
for(my $i=0;$i<@T;$i++){
	if(exists $h{$T[$i]}){
		push @ID,$i;
		push @col_name,$T[$i];
		$order_id{$T[$i]} = $i;
	}
}

my @order_n;
foreach my $i(@order){
	push @order_n,$order_id{$i};
}

my $t2 = @ID;
my $t3 = @col_name;
die "program error\n" unless $t0 == $t2 && $t0 == $t3;
open OU,">$output";
if(!defined $opt_s){
#	print OU "\t",join("\t",@col_name),"\n";
	print OU "\t",join("\t",@col_name),"\n" if defined $opt_T;
	while(<IN>){
		chomp;
		my @temp = split /\t/,$_;
		my $id = shift @temp;
		die "# sample error\n" unless $t1 == @temp;
		my @ex = @temp[@ID];
		print OU $id,"\t",join("\t",@ex),"\n";
	}
}
else {
	print OU "\t",join("\t",@order),"\n" if defined $opt_T;
	while(<IN>){
		chomp;
		my @temp = split /\t/,$_;
		my $id = shift @temp;
		die "# sample error\n" unless $t1 == @temp;
		my @ex = @temp[@order_n];
		print OU $id,"\t",join("\t",@ex),"\n";
	}
}
close IN;
close OU;
}
else{
my %h;
open IN,"$list" or die "No such file $list\n";
while(<IN>){
	chomp;
	my @temp = split /\t/,$_;
	$h{$temp[0]} = 1;
}
close IN;
print STDERR "#{target id}: ",scalar keys %h,"\n";
open IN,"$input" or die "No such file $input\n";
open OU,">$output" or die;
my $t = <IN>;
print OU $t if defined $opt_T;
while(<IN>){
	chomp;
	my @temp = split /\t/,$_;
	print OU $_,"\n" if defined $h{$temp[0]};
}
close IN;
close OU;
}
