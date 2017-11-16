#!/usr/bin/perl
use strict;
use FindBin qw/$Bin/;

#my $mlg_gene = "/ifs3/solexa/data/heyuan/meta/Obese/Obese.18mlg.gene";
my $Rbin = "$Bin/04.Obese_risk.R";
my $Obese_species_marker = "$Bin/04.Obese_speciesmarker.R";
my $Obese_risk_distribution="$Bin/Obese_risk.R";
#my $Rscript = "/ifs3/solexa/data/heyuan/R/bin/Rscript";
#my $pic = "$Bin/../data/pic";
die "usage:perl $0 abun.pro old.mlg.pro mlg_gene pic_dir Rscript_path num
new.mlg.pro Obese_dir" unless ( @ARGV == 10 );
my($abun_pro,$old_mlg,$mlg_gene,$pic,$Rscript,$num,$new_mlg,$Obese_dir,$species_marker,$Obese_control_risk) = @ARGV;

my (%cluster,%need,%prof);

open FILE,"<$mlg_gene" || die $!;
while (<FILE>){
	chomp;
	split;
	my $id=$_[0];
	my @array=split/,/,$_[-1];
	@{$cluster{$id}}=@array;
	foreach my $k(@array){$need{$k}=undef;}
}
close FILE;

open FILE,"<$abun_pro" ||die $!;
while(<FILE>){
	chomp;
	split;
	next unless (exists $need{$_[0]} || $.==1);
	my @array=split /\t/;
        my $id=shift @array;
        @{$prof{$id}}=@array;
}
close FILE;

undef %need;
%need=();

open FILE,"<$old_mlg" || die $!;
open OUT,">$new_mlg" || die $!;
while (<FILE>){
	chomp ;
 	my @temp = split /\t/;
	my $id = shift(@temp);
	print OUT "$id\t";
	if ($. == 1){
		unshift @temp,@{$prof{$id}};
		my $line = join ("\t",@temp);
		print OUT "$line\n";
		next;
	}
	my @array = ();
	my @s = ();
	foreach my $k1(@{$cluster{$id}}){
                for my $k2(0..$#{$prof{$k1}}){
                         push @{$array[$k2]},${$prof{$k1}}[$k2];
                }
        }
        foreach my $k3(@array){
                my @t=sort {$a <=> $b} @{$k3};
                my $sum=0;
                for my $k4(0..$#t){
                        $sum+=$t[$k4];
                }
      	push @s,$sum/($#t+1);
        }
	unshift @temp ,@s;
	my $line = join ("\t",@temp);
	print OUT "$line\n";
}
close OUT;
close FILE;

`mkdir -p $Obese_dir` unless (-e $Obese_dir);
#chomp(my $pwd = `pwd`);
chdir $Obese_dir;
#if($new_mlg =~ /^\//){ 
    `$Rscript $Rbin $new_mlg $num ./`;
    `$Rscript $Obese_species_marker ../Obese_201samples_species.pro 1 $species_marker ./`;
    `$Rscript $Obese_risk_distribution $Obese_control_risk Obese.risk.txt`;
#}else{
#    `$Rscript $Rbin $pwd/$new_mlg $num`;
#}
#chdir $pwd;
open IN,"$Obese_dir/Obese.risk.txt" or die;
while(<IN>){
    chomp;
    if($.==2){
        my @tmp = split /\t/;
        my ($name,$value) = @tmp[0..1];
        if ($value <= 0.1){
            `cp $pic/dis_1.png $Obese_dir/$name"_Obese".png`;
        }elsif($value <= 0.2){
            `cp $pic/dis_2.png $Obese_dir/$name"_Obese".png`;
        }elsif($value <= 0.3){
            `cp $pic/dis_3.png $Obese_dir/$name"_Obese".png`;
        }elsif($value <= 0.4){
            `cp $pic/dis_4.png $Obese_dir/$name"_Obese".png`;
        }elsif($value <= 0.5){
            `cp $pic/dis_5.png $Obese_dir/$name"_Obese".png`;
        }elsif($value <= 0.6){
            `cp $pic/dis_6.png $Obese_dir/$name"_Obese".png`;
        }elsif($value <= 0.7){
            `cp $pic/dis_7.png $Obese_dir/$name"_Obese".png`;
        }elsif($value <= 0.8){
            `cp $pic/dis_8.png $Obese_dir/$name"_Obese".png`;
        }elsif($value <= 0.9){
            `cp $pic/dis_9.png $Obese_dir/$name"_Obese".png`;
        }elsif($value <= 1.0){
            `cp $pic/dis_10.png $Obese_dir/$name"_Obese".png`;
        }
    }
}
close IN;

