unless (@ARGV==2){die "perl $0 len.info blast.mlg.strain >mlg.strain.annotation.txt\n";}
open IN, $ARGV[0] or die "$!\n";
%hash;
while(<IN>){
	chomp;
	my @info = split /\t/;
	$hash{$info[1]}=$info[0];
}

open AN,$ARGV[1] or die "$!\n";
while(<AN>){
	chomp;
        @info1 = split /\t/;
        if(exists $hash{$info1[0]}){
        	@info1[0]=$hash{$info1[0]};
	}
	print "@info1[0]\t@info1[1]\t@info1[2]\t@info1[3]\t@info1[4]\t@info1[5]\t@info1[6]\t@info1[7]\t@info1[8]\t@info1[9]\t@info1[10]\t@info1[11]\n";
}
close IN;
close AN;
