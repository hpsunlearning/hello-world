#! /bin/bash
usage(){
    echo "Usage:sh $0 data_dir bin_dir out_dir sam_profile1 sam_profile2 cut_off sam_num Rscript_path"
    exit 1
}
if [ $# -ne 8 ]
then 
    usage
    exit 1
fi
#输入文件
data_dir=`cd $1;pwd`
bin_dir=`cd $2;pwd`
out_dir=`cd $3;pwd`
sam_profile1=$4
sam_profile2=$5
cut_off=$6
sam_num=$7
Rscript_path=$8

#data文件
gene_species=$data_dir/GeneSet.10th.fa.bt.conn.f.species
foodborne_specie=$data_dir/14.di.sp
opp_file=$data_dir/oppo.bac.species
bene_file=$data_dir/benefit.bac.species
old_specie_pro=$data_dir/198sample_specie_relativeAbun.profile
old_genus_pro=$data_dir/198sample_genus_relative.profile
gene_genus_file=$data_dir/GeneSet.10th.fa.bt.conn.f.genus
fun_old_pro=$data_dir/198.Control.sample.relative_abun
fun_gene_KO=$data_dir/Gene2KEGG.list 
fun_org_pro=$data_dir/198sample_ko_relativeAbun.profile.normalize
T2D_org_pro=$data_dir/StageI_StageII.gene.relative_abun
CC_org_pro=$data_dir/128.sample.relative_abun.sort.final
Obese_org_pro=$data_dir/200.obese.gene.18mlg.abun.pro
SCFA_list=$data_dir/SCFA.gene.list
pic=$data_dir/pic
level2_list=$data_dir/level2.ko.list.f
level3_list=$data_dir/level3.mappedKO.list
Oxidative_list=$data_dir/EC.list.ko
H2S_list=$data_dir/H2S.ko.list
toxin_list=$data_dir/toxin.ko.list
T2D_gene_list=$data_dir/T2D.50.gene.marker
T2D_control_list=$data_dir/T2D.control.list
CC_gene_list=$data_dir/CC.31.gene.marker
CC_config=$data_dir/config
Obese_mlg_gene=$data_dir/Obese.18mlg.gene

#输出目录
oppo_dir=$out_dir/oppo_dir
bene_dir=$out_dir/bene_dir
enterotype=$out_dir/enterotype
diversity_dir=$out_dir/diversity_dir
function_dir=$out_dir/function
T2D_dir=$out_dir/T2D
CC_dir=$out_dir/CC
Obese_dir=$out_dir/Obese

#输出文件
sam_specie_pro=$out_dir/t2samples_198sample_specie.pro
sam_foodborne_pro=$out_dir/t2samples_198sample_foodborne_specie.pro
sam_high_abun=$out_dir/t2samples_highAbun.stat
sam_oppo_pro=$out_dir/t2samples_198sample_oppoSpecie.pro
sam_bene_pro=$out_dir/t2samples_198sample_beneSpecie.pro
sam_genus_pro=$out_dir/t2samples_198sample_genus.pro
sam_gene_pro=$out_dir/t2samples_198sample_gene.pro
sam_diver_pro=$out_dir/t2samples_198sample.diversity
sam_SCFA_pro=$function_dir/SCFA.profile
sam_ko_pro=$out_dir/t2samples_198sample_ko.pro
level2_pro=$function_dir/level2.profile
level3_pro=$function_dir/level3.profile
oxidative_pro=$function_dir/oxidative.profile
H2S_pro=$function_dir/H2S.profile
toxin_pro=$function_dir/toxin.profile
SCFA_pro=$function_dir/SCFA.profile
important_fun_pro=$function_dir/important_function.profile
t2d_50gene_pro=$out_dir/t2samples_345sample_50gene.pro
cc_128sam_genepro=$out_dir/ccsamples_128sample_gene.pro
cc_128sam_31genepro=$out_dir/ccsamples_128sample_31gene.pro
obese_200sam_18mlg_pro=$out_dir/obsampels_200samples_18mlg.abun.pro

perl $bin_dir/1.specie_profile.pl $sam_profile1 $gene_species $foodborne_specie $cut_off $old_specie_pro $opp_file $bene_file $Rscript_path $sam_num $sam_specie_pro $sam_foodborne_pro $sam_high_abun $sam_oppo_pro $oppo_dir $sam_bene_pro $bene_dir

perl $bin_dir/2.genus_profile.pl $sam_profile1 $old_genus_pro $gene_genus_file $Rscript_path $sam_genus_pro $enterotype

perl $bin_dir/3.gene_profile.pl $sam_profile1 $fun_old_pro $SCFA_list $pic $Rscript_path $sam_num $sam_gene_pro $sam_diver_pro $diversity_dir $sam_SCFA_pro $function_dir

perl $bin_dir/4.ko_profile.pl $sam_profile1 $fun_gene_KO $fun_org_pro $sam_ko_pro

perl $bin_dir/5.ko_function_profile.pl $sam_ko_pro $level2_list $level3_list $Oxidative_list $H2S_list $toxin_list $level2_pro $level3_pro $oxidative_pro $H2S_pro $toxin_pro

perl $bin_dir/6.combine_function_profile.pl $level2_pro $level3_pro $oxidative_pro $H2S_pro $toxin_pro $SCFA_pro $sam_num $Rscript_path $important_fun_pro $function_dir

perl $bin_dir/7.t2d_index.pl $sam_profile1 $T2D_org_pro $T2D_gene_list $T2D_control_list $pic $Rscript_path $sam_num $t2d_50gene_pro $T2D_dir

perl $bin_dir/8.cc_index.pl $sam_profile1 $CC_org_pro $CC_gene_list $CC_config $pic $Rscript_path $cc_128sam_genepro $sam_num $cc_128sam_31genepro $CC_dir

perl $bin_dir/9.obese_index.pl $sam_profile2 $Obese_org_pro $Obese_mlg_gene $pic $Rscript_path $sam_num $obese_200sam_18mlg_pro $Obese_dir
