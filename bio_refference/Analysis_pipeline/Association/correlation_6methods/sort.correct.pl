#my ($in_f,$out_f)=@ARGV;
open IN,$ARGV[0]  or die "$!\n";
#open OUT,">$out_f" or die $!;
my %hash;
while(<IN>){chomp;
           $count++;
           my @info=split /\t/;
	   my $key=$info[0]."\t".$info[2];
	   if(!$hash{$key} || $hash{$key}<$info[1]){
		 for ($i=0;$i<=2;$i++){
            $b[$count-1][$i]= ($info[$i]);
                                 }
                      }
}
my $num=1;
for $i (0..($count-2)){
           #print $b[$count-1][0]."\t".$b[$count-1][1]."\t".$b[$count-1][2]."\n";
           if($b[$i][2]!=$b[$i+1][2]){
              $b[$i][3]=$num;
              $b[$i+1][3]=$num+1;
              $num++;
              print $b[$i][0]."\t".$b[$i][1]."\t".$b[$i][2]."\t".$b[$i][3]."\n";
}                
           if($b[$i][2]==$b[$i+1][2]){ 
              $b[$i][3]=$num;
              $b[$i+1][3]=$num;
              print $b[$i][0]."\t".$b[$i][1]."\t".$b[$i][2]."\t".$b[$i][3]."\n";
                          
}                   
}

close IN;
