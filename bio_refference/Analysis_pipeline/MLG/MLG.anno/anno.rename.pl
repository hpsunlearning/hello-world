
my ($in_f1,$in_f2,$out_f)=@ARGV;
open OUT, ">$out_f" or die $!;
open IN, $in_f1 or die "$!\n";
while(<IN>){chomp; 
           @temp=split /\t/; 
           $hash{$temp[0]}=$temp[2];
           } 
close IN; 
open FF, $in_f2 or die "$!\n";
while(<FF>){chomp; 
           @temp=split /\t/; 
           next if($temp[3]<10); 
           $sp=$hash{$temp[0]}; 
              if($sp eq "Unclassified") { 
                 if($temp[2]==1){ 
                                 $sp="RA-$temp[0]";} 
                 else{ 
                                 $sp="Con-$temp[0]";} 
                                        }  
              printf OUT join("\t",@temp[0..3],$sp,@temp[4..$#temp]);
              printf OUT "\n";
           }
close FF;
close OUT;
