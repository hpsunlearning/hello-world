use warnings;
use strict;

die "perl $0 [*.in] [*.out]\n" unless @ARGV == 2;

my ($in_f, $out_f) = @ARGV;
die "Overlap In-Output...\n" if $in_f eq $out_f;
### print STDERR "Program $0 Start...\n";

my (@gene, @sum, @shannon) = ();

open IN, $in_f or die $!;
chomp(my $h=<IN>);
my @head = split /\s+/, $h;
shift @head;
while(<IN>){
	chomp;
	my @s = split /\s+/;
	shift @s;
	for(0..$#s){
		next if $s[$_]==0;
		### $s[$_]/=1e6;
		$gene[$_]++;
		$sum[$_] += $s[$_];
		$shannon[$_] -= $s[$_] * log($s[$_]);
	}
}
close IN;

open OT, ">$out_f" or die $!;
for(0..$#head){
	print STDERR "SUM: $head[$_]\t$sum[$_]\n";
	print OT "$head[$_]\t$gene[$_]\t$shannon[$_]\n";
}
close OT;

print STDERR "Program End...\n";
############################################################
sub function {
	return;
}
############################################################


