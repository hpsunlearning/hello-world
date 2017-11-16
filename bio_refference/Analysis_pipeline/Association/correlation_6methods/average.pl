#####################################################
###   jiezhuye@genomics.cn
##    2014-7-14
#####################################################
## file are stored in file.list,each file are sort decresing
open I,"all.list";
my %listId=();
my %listId2=();

my %file=();
my %file1=();
my %corr=();
my %corr1=();
my $fileid=1;
my $num=1;
my %name;
while(<I>){
    chomp;
        #open each file
        open II,"<$_";
#my @corr = ();
#my (%listId, %idList);
         my $id = 1;
		                  my $idbefore=0;
						                   my $sbefore=0;

## file id
#       $file{$_}=1;
         $name{$fileid}=$_;
    while(<II>){
            chomp; 
            my @s=split /\t/,$_; 
                ##mlg
             unless (exists $listId{$s[0]}) {
                    $listId{$s[0]} = $s[0]; 
                    #$idList{$id} = $s[0]; $id++;
             }
## mebo
             unless (exists $listId2{$s[1]}) {
                     $listId2{$s[1]} = $s[1]; 
#$idList{$id} = $s[1]; $id++;
            }
               my $cc = $id;
#29     $cc = $maxi if $cc > $maxi;
#                  30     $cc = -1/2*log(1 - $cc);
                    my ($a, $b) = ($listId{$s[0]}, $listId2{$s[1]});
                    $corr{$a}{$b}{$fileid} = $cc;
                    $corr{$b}{$a}{$fileid} = $cc;
                    $corr1{$a}{$b}{$fileid} = $s[2];
                    $corr1{$b}{$a}{$fileid} = $s[2];
        $file{$fileid}=$id;
        $file1{$fileid}=$s[2];
        #if cor is not change then rank will not change
		                if($s[-1]==$sbefore){
							                        $id=$idbefore;
													                }else{
																		                         $sbefore=$s[-1];
																								 $id++;
																								                          $idbefore=$id;
																														                   
																																		               }

#print $a."\t".$b."\t".$cc."\t".$corr{$b}{$a}{$_}."\n";
    }
        close II;
        $fileid++;
        $num++;
}
close I;
    my @arr= keys %listId;
    my @arr2= keys %listId2;

    my %rank=();
# open O,">average.rank.output";
    print  "Id1\tId2\t";
    foreach my $f1 (keys %file){
            my @la=split /\//,$name{$f1};
            my @la1=split /\./,$la[-1];
            print  $la1[0]."\t";
    }
    print "average\n"; 

for my $a (0..$#arr){

        for my $b ( 0..$#arr2){
                my $sum=0;
                print $arr[$a]."\t".$arr2[$b]."\t";
                foreach my $f1 (keys %file){
#print $f1."\n";
#print $file{$f1}."\n";
#                        print  $corr{$arr[$a]}{$arr2[$b]}{$f1}."\n";
                        if(defined $corr{$arr[$a]}{$arr2[$b]}{$f1} ){
                               $sum=$sum+  $corr{$arr[$a]}{$arr2[$b]}{$f1};
                                print  $corr1{$arr[$a]}{$arr2[$b]}{$f1}."\t";
                        }else{
                                $sum=$sum+ $file{$f1} ;
                               print $file1{$f1}."\t";
                        }
                
                }
            
                $rank{$arr[$a]}{$arr2[$b]}=$sum/($num-1);
                print $sum/$num;
                print "\n";
# print O $arr[$a]."\t".$arr2[$b]."\t"; print O $sum/$num; print O "\n";
        }

}



