#!/usr/bin/perl -w
use strict;

my ($index_s,$index_f,$index_a,$index_d);
my $usage=<<"usage";
perl $0 specie.stat function.stat anti.stat T2D.risk.stat CC.risk.stat Obese.risk.stat 86_samples_IBD_4.3_species.pro IBD_species_markers health_index
usage
die $usage unless (@ARGV==7);
my ($species_stat,$function_stat,$anti_stat,$T2D_risk_stat,$CC_risk_stat,$Obese_risk_stat,$IBD_species_pro,$IBD_species_marker,$health_index)=@ARGV;

open IN,"<",$species_stat or die $!;
open OUT,">",$health_index or die $!;
my $absolute_index=0;
my $species_count=0;
while(<IN>){
	chomp;
	next if($.==1);
	$species_count++;
	my @array=split/\t/,$_;
	my $temp=$array[2];
	my @range=split/~/,$array[3];
	my $lowest=$range[0];
	my $highest=$range[1];
	if($temp >= $lowest && $temp <= $highest){
		$absolute_index++;}
}
close IN;
$index_s=$absolute_index/$species_count;
my $formatted_index=sprintf("%.3f",$index_s);
print OUT "\tHealth\tSample\n物种\t0.95\t$formatted_index\n";

open IN1,"<",$function_stat or die $!;
my $absolute_index_1=0;
my $function_count=0;
while(<IN1>){
	chomp;
	next if($.==1);
	$function_count++;
	my @array=split/\t/,$_;
	my $temp=$array[1];
	my @range=split/~/,$array[2];
	my $lowest=$range[0];
	my $highest=$range[1];
	if($temp >= $lowest && $temp <= $highest){
		$absolute_index_1++;}
}
close IN1;
$index_f=$absolute_index_1/$function_count;
my $formatted_index_1=sprintf("%.3f",$index_f);
print OUT "功能\t0.875\t$formatted_index_1\n";

open IN2,"<",$anti_stat or die $!;
my $absolute_index_2=0;
my $anti_count=0;
while(<IN2>){
	chomp;
	next if($.==1);
	$anti_count++;
	my @array=split/\t/,$_;
	my $temp=$array[1];
	my $lowest=$array[3];
	my $highest=$array[4];
	if($temp >= $lowest && $temp <= $highest){
		$absolute_index_2++;}
}
close IN2;
$index_a=$absolute_index_2/$anti_count;
my $formatted_index_2=sprintf("%.3f",$index_a);
print OUT "抗生素\t0.769\t$formatted_index_2\n";

open IN3,"<",$T2D_risk_stat or die $!;
my $T2D;
while(<IN3>){
	chomp;
	if($.==2){
		my @array=split;
		$T2D=$array[1];}
}
close IN3;

open IN4,"<",$CC_risk_stat or die $!;
my $CC;
while(<IN4>){
	chomp;
	if($.==2){
		my @array=split;
		$CC=$array[1];
	}
}
close IN4;

open IN5,"<",$Obese_risk_stat or die $!;
my $Obese;
while(<IN5>){
	chomp;
	if($.==2){
		my @array_1=split;
		$Obese=$array_1[1];
	}
}
close IN5;

open IN6,"<",$IBD_species_marker or die $!;
my %hash;
while(<IN6>){
	chomp;
	s/_/ /g;
	if($.<=4){
		$hash{$_}=0;
	}else{
		$hash{$_}=1;}
}
close IN6;
open IN7,"<",$IBD_species_pro or die $!;
my $abnormal_numer=0;
my $marker_number=0;
while(<IN7>){
	chomp;
	next if($.==1);
	my @array_2=split/\t/;
	my $species=$array_2[0];
	my $sample_profile=$array_2[1];
	my @case=splice @array_2,2,49;
	my @control=splice @array_2,2,38;
	if(exists $hash{$species}){
		$marker_number++;
		if($hash{$species}==0){
			my $less_number_case=0;
			my $less_number_control=0;
			foreach(@case){
				if($_<=$sample_profile){
					$less_number_case++;}}
			foreach(@control){
				if($_<=$sample_profile){
					$less_number_control++;}}
			if($less_number_case/48 < 0.2 || $less_number_control/37 < 0.2){
				$abnormal_numer++;}
		}else{
			my $less_number_case_1=0;
			my $less_number_control_1=0;
			foreach(@case){
				if($_<=$sample_profile){
					$less_number_case_1++;}}
			foreach(@control){
				if($_<=$sample_profile){
					$less_number_control_1++;}}
			if($less_number_case_1/48 > 0.8 || $less_number_control_1/37 > 0.8){				
				$abnormal_numer++;}
		}
	}
}
close IN7;
my $IBD=$abnormal_numer/$marker_number;

	
my $absolute_index_4=0;
my $disease_count=4;
if($T2D<=0.95){
	$absolute_index_4++;}
if($CC<=0.8){
	$absolute_index_4++;}
if($Obese<=0.8){
	$absolute_index_4++;}
if($IBD<=0.8){
	$absolute_index_4++;}
$index_d=$absolute_index_4/$disease_count;
my $formatted_index_3=sprintf("%.3f",$index_d);
print OUT "疾病\t0.75\t$formatted_index_3\n";
close OUT;



