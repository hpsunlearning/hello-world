open IN, $ARGV[0] or die "$!\n";
%hash;
my $num=1;
while(<IN>){
	chomp;
	my @info = split /\t/;
        $info[3]=$num;
        $hash{$info[3]}=$info[2];
        $num++;
        #print $hash{$info[3]}."\n";
           }

open AN,$ARGV[1] or die "$!\n";
while(<AN>){
	chomp;
        @info1 = split /\t/;
        if(exists $hash{$info1[$ARGV[2]]}){
        	#@info1[2]=$hash{$info1[0]};
	
	print @info1[0]."\t".@info1[1]."\t".@info1[$ARGV[2]]." (".$hash{$info1[$ARGV[2]]}.")"."\n";
}
}
close IN;
close AN;
