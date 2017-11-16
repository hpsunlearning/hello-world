my($in,$in1,$out)=@ARGV;
my %h; 
open I,$in;
open II,$in1;
open OUT,">$out";
while(<I>){chomp; 
           @a=split /\//,$_; 
           @b=split /-/,$a[-1];   
           $h{$b[0]}=1; 
          } 

while(<II>){chomp; 
            @a=split /\s+/,$_; 
            @b=split /\//,$a[-1]; 
            if( defined $h{$b[-1]}){ 
                printf OUT "/ifs1/ST_META/USER/xiahuihua/bin/R-3.1.0/bin/Rscript  /ifs1/ST_META/USER/wangxiaokai/RA/correlation_6methods/borutia.after.rfcv.R  $a[2]  $a[-1]-final.txt  $b[-1]\n";
                                   }
           }
close I;
close II;
close OUT;
