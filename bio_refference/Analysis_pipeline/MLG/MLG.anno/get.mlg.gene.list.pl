#! /usr/bin/perl
my ($in_f1,$in_f2,$out_f)=@ARGV;
open I,$in_f1 or die "$!\n";
%hash;
while(<I>){chomp;
           split/\t/;
           $hash{$_[0]}{$_[2]}=$_[1];
          }
close I;                                                          
open II, $in_f2 or die "$!\n";
open OUT, ">$out_f" or die $!;
while(<II>){chomp;
           split;
           if(@_==1 or $_[-2]<10){
                                   next;
                                 }
           my @array=split/,/,$_[-1];
           my %count=(); %genus=(); %iden95=(); %iden85=(); 
              foreach(@array){if(exists $hash{$_})
                                  {foreach my $k(keys %{$hash{$_}})
                                          {$iden=$hash{$_}{$k}; 
                                                if($iden>=95)
                                                  {$count{$k}++; 
                                                   $iden95{$k}+=$iden;} 
                                                if($iden>=85)
                                                  {$genus{$k}++;
                                                   $iden85{$k}+=$iden;}
                                          }
                                  } 
                             } 
           my @temp=sort {$count{$b} <=> $count{$a}} keys %count;
              @temp2=sort {$genus{$b}<=>$genus{$a}} keys %genus; 
               if($count{$temp[0]}/$_[-2]>=0.9)
                  { next; for $k(@temp)
                        {last if($count{$k}/$_[-2]<0.9); 
                         printf OUT $k."\t".$count{$k}."\t".$count{$k}/$_[-2]."\t".$iden95{$k}/$count{$k};
                        }
                    printf OUT "\n"; 
                  }
               elsif($genus{$temp2[0]}/$_[-2]>=0.8)
                  { printf OUT $_."\n";
                  } 
                          else{ next;
                                printf OUT "\tUnclassified\n";
                              } 
          }       
close II;
close OUT;              
