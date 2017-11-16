#!/usr/bin/perl -w
use strict;
use FindBin qw/$Bin/;

#my $level2_list = "$Bin/../data/level2.ko.list.f";
#my $level3_list = "$Bin/../data/level3.mappedKO.list";
#my $Oxidative_list = "$Bin/../data/EC.list.ko";
#my $H2S_list = "$Bin/../data/H2S.ko.list";
#my $toxin_list = "$Bin/../data/toxin.ko.list";

my (%level2_ko,%level3_ko,%oxidative_ko,%H2S_ko,%toxin_ko);
my (%level2_abun,%level3_abun,%oxidative_abun,%H2S_abun,%toxin_abun);

my $usage = <<"usage";
perl $0 ko.profile level2_list level3_list Oxidative_list H2S_list
toxin_list level2.profile level3.profile oxidative.profile
H2S.profile toxin.profile
usage
die $usage unless(@ARGV == 11);
my($koProfile,$level2_list,$level3_list,$Oxidative_list,$H2S_list,$toxin_list,$level2_pro,$level3_pro,$oxidative_pro,$H2S_pro,$toxin_pro) = @ARGV;

open INL2,$level2_list or die "$!\n";
while(<INL2>){
    chomp;
    my @temp = split /\t+/;
    my @info = split /\,/,$temp[-1];
    foreach my $ko(@info){
        $level2_ko{$ko}{$temp[0]} = 1;
    }
}
close INL2;

open INL3,$level3_list or die "$!:cannot open $level3_list\n";
while(<INL3>){
    chomp;
    my @temp = split /\t+/;
    my @info = split /\,/,$temp[-1];
    foreach my $ko(@info){
        $level3_ko{$ko}{$temp[0]} = 1;
    }
}
close INL3;

open INO,$Oxidative_list or die "$!:canot open $Oxidative_list\n";
while(<INO>){
    chomp;
    my @temp = split /\t+/;
    $oxidative_ko{$temp[0]} = "Oxidative_stress_resistance";
}
close INO;

open INH,$H2S_list or die "$!\n";
while(<INH>){
    chomp;
    my @temp = split /\t+/;
    $H2S_ko{$temp[0]} = "H2S";
}
close INH;

open INT,$toxin_list or die "$!:cannot open $toxin_list\n";
while(<INT>){
    chomp;
    my @temp = split /\t+/;
    $toxin_ko{$temp[0]} = "toxin";
}
close INT;

open INP,$koProfile or die "$!\n";
open OUL2,"> $level2_pro" or die "$!\n";
open OUL3,"> $level3_pro" or die "$!\n";
open OUO,"> $oxidative_pro" or die "$!\n";
open OUH,"> $H2S_pro" or die "$!\n";
open OUT,"> $toxin_pro" or die "$!\n";
while(<INP>){
    chomp;
    if($. == 1){
        print OUL2 "$_\n";
        print OUL3 "$_\n";
        print OUO "$_\n";
        print OUH "$_\n";
        print OUT "$_\n";
    }else{
        my @temp = split /\t+/;
        for my $i(1..$#temp){
            if(exists $level2_ko{$temp[0]}){
                foreach my $level2(sort keys %{$level2_ko{$temp[0]}}){
                    $level2_abun{$level2}{$i} += $temp[$i];
                }
            }
            if(exists $level3_ko{$temp[0]}){
                foreach my $level3(sort keys %{$level3_ko{$temp[0]}}){
                    $level3_abun{$level3}{$i} += $temp[$i];
                }
            }
            $oxidative_abun{$oxidative_ko{$temp[0]}}{$i} += $temp[$i] if(exists $oxidative_ko{$temp[0]});
#            print "$temp[0]\t$i\t$oxidative_abun{$oxidative_ko{$temp[0]}}{$i}\n" if(exists $oxidative_ko{$temp[0]});
            $H2S_abun{$H2S_ko{$temp[0]}}{$i} += $temp[$i] if(exists $H2S_ko{$temp[0]});
            $toxin_abun{$toxin_ko{$temp[0]}}{$i} += $temp[$i] if(exists $toxin_ko{$temp[0]});
        }
    }
}
close INP;

foreach my $level2(sort keys %level2_abun){
    print OUL2 "$level2";
    foreach my $num (sort {$a <=> $b} keys %{$level2_abun{$level2}}){
        print OUL2 "\t$level2_abun{$level2}{$num}";
    }
    print OUL2 "\n";
}
close OUL2;

foreach my $level3(sort keys %level3_abun){
    print OUL3 "$level3";
    foreach my $num(sort {$a <=> $b} keys %{$level3_abun{$level3}}){
        print OUL3 "\t$level3_abun{$level3}{$num}";
    }
    print OUL3 "\n";
}
close OUL3;

foreach my $oxidative(sort keys %oxidative_abun){
    print OUO "$oxidative";
    foreach my $num(sort {$a <=> $b} keys %{$oxidative_abun{$oxidative}}){
        print OUO "\t$oxidative_abun{$oxidative}{$num}";
    }
    print OUO "\n";
}
close OUO;

foreach my $H2S(sort keys %H2S_abun){
    print OUH "$H2S";
    foreach my $num(sort {$a <=> $b} keys %{$H2S_abun{$H2S}}){
        print OUH "\t$H2S_abun{$H2S}{$num}";
    }
    print OUH "\n";
}
close OUH;

foreach my $toxin(sort keys %toxin_abun){
    print OUT "$toxin";
    foreach my $num(sort {$a <=> $b} keys %{$toxin_abun{$toxin}}){
        print OUT "\t$toxin_abun{$toxin}{$num}";
    }
    print OUT "\n";
}
close OUT;
