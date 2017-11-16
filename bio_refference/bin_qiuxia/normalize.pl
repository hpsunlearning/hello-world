#!/usr/bin/perl -w
use strict;
die "Usage:\tperl $0 [*prof] [out]\n" unless (@ARGV == 2);
my ($in,$out) = (@ARGV);
my (@tmp) = ();
my (@sum) = ();
print STDERR "Program Start...\n";

if ($in =~ /\.gz/) { open IN,"gzip -dc $in |"|| die $!;
} else { open IN,$in || die $!;}
while(<IN>) {
	chomp;
	next if(/^\s+/);
	@tmp = split /\t+/;
	shift @tmp;
	foreach(0 .. $#tmp) {
		$sum[$_] += $tmp[$_];
	}
}
close IN;
if ($in =~ /\.gz/) { open IN,"gzip -dc $in |"|| die $!;
} else { open IN,$in || die $!;}
open OUT,"> $out" || die $!;
my $head = <IN>;
print OUT $head;
while(<IN>) {
	chomp;
	@tmp = split /\t+/;
	my $id = shift @tmp;
	$id =~ s/\s+/\_/g; #### transformat
	$id =~ s/#//g; ### transformat
	my @abd = ();
	foreach(0 .. $#tmp) {
		push @abd,$tmp[$_]/$sum[$_];
	}
	print OUT "$id\t",join("\t",@abd),"\n";
}
close IN;
close OUT;
print STDERR "Program End!\n";

sub function{

}
