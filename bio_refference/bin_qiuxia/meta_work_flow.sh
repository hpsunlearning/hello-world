in_dir=$1
sam_name=$2
out_dir=`cd $3;pwd`

data_dir=/ifs1/ST_MED/USER/yangyueqing/project/CD/Meta/Meta_work_flow/meta_adult/data
bin_path=/ifs1/ST_MED/USER/yangyueqing/project/CD/Meta/Meta_work_flow/meta_adult/bin
Bin_path=/ifs1/ST_MED/USER/yangyueqing/project/CD/Meta/Meta_work_flow/meta_adult/Bin
export PATH=$PATH:$bin_path:$Bin_path
cd $out_dir;
mkdir profile_4.3M profile_9.9M
filter_v1.0.pl -a $in_dir/1.fq.gz -b $in_dir/2.fq.gz -c $in_dir/1.adapter.gz -d $in_dir/2.adapter.gz -l 15 -n 3 -p filtered
/ifs5/PC_MICRO_META/PRJ/MetaSystem/analysis_flow/bin/program/trim_v1.0 -a filtered.clean.1.fq.gz -b filtered.clean.2.fq.gz -l 30 -q 20 -o trimed
rmhost_database="/nas/RD_09C/resequencing/resequencing/tmp/pub/Genome/Human/human.fa.index"
rmhost_v1.0.pl -a trimed.trim.1.fq.gz  -b trimed.trim.2.fq.gz -d $rmhost_database -m 4 -s 32 -r 1 -n 100 -x 600 -v 8 -i 0.9 -t 8 -f Y -p $sam_name -q
geneset_4="/ifs5/PC_MICRO_META/PRJ/MetaSystem/DATABASE/geneset/EU_124sample.CN_145sample.geneset/EU_124sample.CN_145sample.geneset.fa.index"
geneset_9="/ifs5/PC_MICRO_META/PRJ/MetaSystem/DATABASE/geneset/MetaHit9.9/760MetaHit_139HMP_368PKU_511Bac.fa.90_95_1.fa.index:/ifs5/PC_MICRO_META/PRJ/MetaSystem/DATABASE/geneset/MetaHit9.9/760MetaHit_139HMP_368PKU_511Bac.fa.90_95_2.fa.index"
info_4="/ifs5/PC_MICRO_META/PRJ/MetaSystem/DATABASE/geneset/EU_124sample.CN_145sample.geneset/EU_124sample.CN_145sample.geneset.len.info"
info_9="/ifs5/PC_MICRO_META/PRJ/MetaSystem/DATABASE/geneset/MetaHit9.9/760MetaHit_139HMP_368PKU_511Bac.fa.90_95.len.info"
abundance_v1.0_V2.pl -a $sam_name.rmhost.1.fq.gz -b $sam_name.rmhost.2.fq.gz -d $geneset_4 -g $info_4 -m 4 -s 32 -r 2 -n 100 -x 600 -v 8 -i 0.9 -t 8 -f Y -p profile_4.3M/$sam_name
abundance_v1.0_V2.pl -a $sam_name.rmhost.1.fq.gz -b $sam_name.rmhost.2.fq.gz -d $geneset_9 -g $info_9 -m 4 -s 32 -r 2 -n 100 -x 600 -v 8 -i 0.9 -t 8 -f Y -p profile_9.9M/$sam_name
profile_combine.pl -p profile_4.3M/$sam_name.abundance.gz -o profile_4.3M/4.3M
profile_combine.pl -p profile_9.9M/$sam_name.abundance.gz -o profile_9.9M/9.9M

Rscript_path=`which Rscript`
cut_off=0.01
sam_num=1
sam_profile1=$out_dir/profile_4.3M/4.3M.gene_profile
sam_profile2=$out_dir/profile_9.9M/9.9M.gene_profile

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

1.specie_profile.pl $sam_profile1 $gene_species $foodborne_specie $cut_off $old_specie_pro $opp_file $bene_file $Rscript_path $sam_num $sam_specie_pro $sam_foodborne_pro $sam_high_abun $sam_oppo_pro $oppo_dir $sam_bene_pro $bene_dir
2.genus_profile.pl $sam_profile1 $old_genus_pro $gene_genus_file $Rscript_path $sam_genus_pro $enterotype
3.gene_profile.pl $sam_profile1 $fun_old_pro $SCFA_list $pic $Rscript_path $sam_num $sam_gene_pro $sam_diver_pro $diversity_dir $sam_SCFA_pro $function_dir
4.ko_profile.pl $sam_profile1 $fun_gene_KO $fun_org_pro $sam_ko_pro
5.ko_function_profile.pl $sam_ko_pro $level2_list $level3_list $Oxidative_list $H2S_list $toxin_list $level2_pro $level3_pro $oxidative_pro $H2S_pro $toxin_pro
6.combine_function_profile.pl $level2_pro $level3_pro $oxidative_pro $H2S_pro $toxin_pro $SCFA_pro $sam_num $Rscript_path $important_fun_pro $function_dir
7.t2d_index.pl $sam_profile1 $T2D_org_pro $T2D_gene_list $T2D_control_list $pic $Rscript_path $sam_num $t2d_50gene_pro $T2D_dir
8.cc_index.pl $sam_profile1 $CC_org_pro $CC_gene_list $CC_config $pic $Rscript_path $cc_128sam_genepro $sam_num $cc_128sam_31genepro $CC_dir
9.obese_index.pl $sam_profile2 $Obese_org_pro $Obese_mlg_gene $pic $Rscript_path $sam_num $obese_200sam_18mlg_pro $Obese_dir
                                                                                                                                                  
