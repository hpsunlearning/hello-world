use warnings;
use strict;

############################################################
### Author: lishenghui@genomics.org.cn                   ###
### Version: 1.0 (Apr. 1st, 2012)                        ###
############################################################

die "perl $0 [gene-gene.corr] [gene-t2d.corr] [*.out]\n" unless @ARGV == 3;
my ($gg_f, $gt_f, $out_f) = @ARGV;
### print STDERR "Program $0 Start...\n";

my $maxi = 0.999999;
my @corr = ();

my (%listId, %idList);
my $id = 0;
open IN, $gg_f or die $!;
while(<IN>){
	chomp;
	my @s = split /\t+/;
	unless (exists $listId{$s[0]}) {
		$listId{$s[0]} = $id; $idList{$id} = $s[0];	$id++;
	}
	unless (exists $listId{$s[1]}) {
		$listId{$s[1]} = $id; $idList{$id} = $s[1];	$id++;
	}
	my $cc = $s[2] * $s[2]; 
	$cc = $maxi if $cc > $maxi;
	$cc = -1/2*log(1 - $cc);
	my ($a, $b) = ($listId{$s[0]}, $listId{$s[1]});
	$corr[$a][$b] = $cc;
	$corr[$b][$a] = $cc;
}
close IN;
my @k = keys %listId;

my (%corr_t2d, %copy_corr_t2d);
open IN, $gt_f or die $!;
while(<IN>){
	chomp;
	my @s = split /\t+/;
	die "Error...\n" unless exists $listId{$s[0]};
	$copy_corr_t2d{$listId{$s[0]}} = $s[1];
	my $cc = $s[1] * $s[1];
	$cc = $maxi if $cc > $maxi;
	$cc = -1/2*log(1 - $cc);
	$corr_t2d{$listId{$s[0]}} = $cc;
}
close IN;

my @ks = keys %corr_t2d;
print STDERR "No. of genes: ".($#k+1)."\n";
die "Error...\n" unless $#k == $#ks;

my (@sort_id, @sort_gene) = ();
open OT, ">$out_f" or die $!;
while (@ks > 0){
	my ($max, $maxV) = ($ks[0], 0);
	for my $k(@ks){
		my $mean = 0;
		for(@sort_id){ $mean += $corr[$k][$_]; }
		$mean /= @sort_id+1 unless @sort_id==0;
		my $v = $corr_t2d{$k} - $mean;
		($max, $maxV) = ($k, $v) if $v > $maxV;
		### print STDERR "$mean\t$v\n" if $k==212;
	}
	push @sort_id, $max;
	print OT "$idList{$max}\t$copy_corr_t2d{$max}\t$maxV\n";
	delete $corr_t2d{$max};
	@ks = keys %corr_t2d;
}
close OT;

print STDERR "Program End...\n";
############################################################
sub function {
	return;
}
############################################################

