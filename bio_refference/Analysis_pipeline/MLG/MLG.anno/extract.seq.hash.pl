unless (@ARGV==3){die "perl $0 gene.id.list gene.fa query.gene.fa\n";}
my($in_f,$in_f1,$out_f)=@ARGV;
open IN,$in_f or die "$!";
while(<IN> ){
  chomp;  
  my ($name)=$_=~/^(\S+)/;
  $hash{$name}=1;
 # print "$name\n";
            }

open INI,$in_f1 or die "$!";
open OUT,">$out_f" or die "$!";
local $/ = ">";
while(<INI>){
  chomp;
  my ($head,$seq) = split(/\n/,$_,2);
  @info=split(/  /,$head);
  $head=@info[0];
  my ($name)=$head=~/^(\S+)/;
  if(exists $hash{$name}){
  printf OUT ">$head\n$seq";
		   }
	   }
close INI;
close OUT;
