#!/usr/bin/perl -w
use strict;

@ARGV == 3 or die "perl $0 <gene_nucl.taxo> <gene_prot.taxo> <mlg.list>\n";
open I,$ARGV[0];
my %nucl;
while(<I>){
    chomp;
    my @temp=split /\t/;
    $nucl{$temp[0]}{$temp[2]}=$temp[1];
}
close I;
open I, $ARGV[1];
my %prot;
while(<I>){
    chomp;
    my @temp=split /\t/;
    $prot{$temp[0]}{$temp[2]}=$temp[1];
}
close I;

open I, $ARGV[2];
while(<I>){
    chomp; my @temp=split;
    if(@temp==1 or $temp[-2]<10){next;}
    my @array=split/,/,$temp[-1];
    my %count95=(); my %count85=();
    my %iden95=(); my %iden85=();
    foreach(@array){
        if(exists $nucl{$_}){
            foreach my $k(keys %{$nucl{$_}}){
                my $iden=$nucl{$_}{$k};
                if($iden>=95){ $count95{$k}++; $iden95{$k}+=$iden;}
                if($iden>=85){ $count85{$k}++; $iden85{$k}+=$iden;}
            }
        }
    }
    my @temp1=sort {$count95{$b} <=> $count95{$a}} keys %count95;
    my @temp2=sort {$count85{$b} <=> $count85{$a}} keys %count85;
    print $temp[0],"\t",$temp[-2];
    if(@temp1>0 and $count95{$temp1[0]}/$temp[-2]>=0.9){
        my $sp=join(" ", (split /\s+/,$temp1[0])[0,1]);
        print "\t",$sp, "\tspecies\n";
#        for $k(@temp1){
#            last if($count95{$k}/$temp[-2]<0.9);
#            print "\t",$k,"\t",$count95{$k},"\t",$count95{$k}/$temp[-2],"\t",$iden95{$k}/$count95{$k};
#        }
#        print "\n";
    }
    elsif(@temp2>0 and $count85{$temp2[0]}/$temp[-2]>=0.8){
        my %prot_count=();
        foreach(@array){
            if(exists $prot{$_}){
                foreach my $k(keys  %{$prot{$_}}){
                    my $iden=$prot{$_}{$k};
                    if($iden>=85) { $prot_count{$k}++;}
                }
            }
        }
#        if($temp[0]==1261 or $temp[0]==492) { print STDERR $temp[0],"\t",$temp[-2],"\n"; }
        my %prot_genus=();
        for my $k(sort {$prot_count{$b} <=> $prot_count{$a}} keys %prot_count) {
#                if(($temp[0]==1261 or $temp[0]==492) and $prot_count{$k}/$temp[-2]>0) {
#                    print STDERR "\t",$k,"\t",$prot_count{$k}/$temp[-2];
#                }
            if($prot_count{$k}/$temp[-2]>=0.8) {
                my $genus=(split /\_/,$k)[0];
                $prot_genus{$genus}=undef;
            }
        }
#        if($temp[0]==1261 or $temp[0]==492) { print STDERR "\n";}
        my $anno=0;
        for my $k(@temp2){
            if($count85{$k}/$temp[-2]<0.8){ last;}
#            if($temp[0]==1261 or $temp[0]==492) {
#                print STDERR "\t", $k, "\t", $count85{$k}/$temp[-2];
#            }
            my $sp=join("_", (split /\s+/,$k)[0,1]);
            my $genus=(split /\s+/,$k)[0];
            if((exists $prot_count{$sp} and $prot_count{$sp}/$temp[-2]>=0.8) or
               exists $prot_genus{$genus}) {
                print "\t", $genus, " sp.\tgenus\n";
                $anno=1;
                last;
            }
        }
#        if($temp[0]==1261 or $temp[0]==492) { print STDERR "\n"; }
        if($anno==0) {print "\tUnclassified\n";};
    }
    else{ print "\tUnclassified\n";}
}
close I;

