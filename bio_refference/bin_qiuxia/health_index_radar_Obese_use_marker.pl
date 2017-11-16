#!/usr/bin/perl -w
use strict;

my ($index_s,$index_f,$index_a,$index_d);
my $usage=<<"usage";
perl $0 specie.stat function.stat anti.stat common_anti T2D.risk.stat CC.risk.stat 201_samples_Obese_4.3_species.pro Obese_species_marker 86_samples_IBD_4.3_species.pro IBD_species_markers health_index health_index_average
usage
die $usage unless (@ARGV==12);
my ($species_stat,$function_stat,$anti_stat,$common_anti,$T2D_risk_stat,$CC_risk_stat,$Obese_species_pro,$Obese_species_marker,$IBD_species_pro,$IBD_species_marker,$health_index,$health_index_average)=@ARGV;

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

open ANTI,"<",$common_anti or die $!;
my %hash_anti;
while(<ANTI>){
	chomp;
	$hash_anti{$_}=0;}

open IN2,"<",$anti_stat or die $!;
my $abnormal=0;
my $anti_count_all;
my $anti_count=10;
my $absolute_index_2=0;
while(<IN2>){
	chomp;
	next if($.==1);
	$anti_count_all++;
	my @array=split/\t/,$_;
	my $antiname=$array[0];
	my $temp=$array[1];
#	my $lowest=$array[3];
	my $highest=$array[4];
	if($temp > $highest){
		if(exists $hash_anti{$antiname}){
			$abnormal++;
		}else{
			$abnormal++;
			$anti_count++;}
	}else{
		$absolute_index_2++;}
}
#if($temp >= $lowest && $temp <= $highest){
#	if($temp <= $highest){
#	 $absolute_index_2++;}
close IN2;
$index_a=$absolute_index_2/$anti_count_all;
my $index_a_1=1-$abnormal/$anti_count;
#my $formatted_index_a_1=sprintf("%.3f",$index_a_1);
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

#open IN5,"<",$Obese_risk_stat or die $!;
#my $Obese;
#while(<IN5>){
#	chomp;
#	if($.==2){
#		my @array_1=split;
#		$Obese=$array_1[1];
#	}
#}
#close IN5;
open IN5,"<",$Obese_species_marker or die $!;
my %hash1;
while(<IN5>){
	chomp;
	s/_/ /g;
	my @marker_O=split/\t/;
	my $temp_O=$marker_O[0];
	if($.<=6){
		$hash1{$temp_O}=0;
	}else{
		$hash1{$temp_O}=1;}
}
close IN5;
open IN6,"<",$Obese_species_pro or die $!;
my $abnormal_numer_1=0;
my $marker_number_1=0;
my $case_num=0;
my $con_num=0;
while(<IN6>){
	chomp;
	if($.==1){
		my @col=split/\t/;
		foreach(@col){
			if($_=~/^DB/){
				$case_num++;}
			if($_=~/^CON/){
				$con_num++;}
		}
		next;
	}
	my @array_O=split/\t/;
	my $species_O=$array_O[0];
	my $sample_profile_O=$array_O[1];
	my @case_O=splice @array_O,2,$case_num;
	my @control_O=splice @array_O,2,$con_num;
	if(exists $hash1{$species_O}){
		$marker_number_1++;
		if($hash1{$species_O}==0){
			my $less_number_case_2=0;
			my $less_number_control_2=0;
			foreach(@case_O){
				if($_<=$sample_profile_O){
					$less_number_case_2++;}}
			foreach(@control_O){
				if($_<=$sample_profile_O){
					$less_number_control_2++}}
			if($less_number_case_2/$case_num < 0.2 || $less_number_control_2/$con_num <0.2){
				$abnormal_numer_1++;}
		}else{
			my $less_number_case_3=0;
			my $less_number_control_3=0;
			foreach(@case_O){
				if($_<=$sample_profile_O){
					$less_number_case_3++;}}
			foreach(@control_O){
				if($_<=$sample_profile_O){
					$less_number_control_3++}}
			if($less_number_case_3/$case_num > 0.8 || $less_number_control_3/$con_num > 0.8){
				$abnormal_numer_1++;}
		}
	}
}
close IN6;
my $Obese=$abnormal_numer_1/$marker_number_1;

open IN7,"<",$IBD_species_marker or die $!;
my %hash;
while(<IN7>){
	chomp;
	s/_/ /g;
	if($.<=4){
		$hash{$_}=0;
	}else{
		$hash{$_}=1;}
}
close IN7;
open IN8,"<",$IBD_species_pro or die $!;
my $abnormal_numer=0;
my $marker_number=0;
my $case_num1=0;
my $con_num1=0;
while(<IN8>){
	chomp;
	if($.==1){
		my @col_1=split/\t/;
		foreach(@col_1){
			if($_=~/^HKUC/){
				$case_num1++;}
			if($_=~/^HKCT/){
				$con_num1++;}
		}
		next;
	}
	my @array_2=split/\t/;
	my $species=$array_2[0];
	my $sample_profile=$array_2[1];
	my @case=splice @array_2,2,$case_num1;
	my @control=splice @array_2,2,$con_num1;
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
			if($less_number_case/$case_num1 < 0.2 || $less_number_control/$con_num1 < 0.2){#because there are 48 cases and 37 controls.
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
			if($less_number_case_1/$case_num1 > 0.8 || $less_number_control_1/$con_num1 > 0.8){				
				$abnormal_numer++;}
		}
	}
}
close IN8;
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

open OUT1,">",$health_index_average or die $!;
my $sample_average=($index_s+$index_f+$index_a_1+$index_d)/4;
my $formatted_index_4=sprintf("%.3f",$sample_average);
print OUT1 "\tHealth\tSample\n平均值\t0.836\t$formatted_index_4\n";
close OUT1;


