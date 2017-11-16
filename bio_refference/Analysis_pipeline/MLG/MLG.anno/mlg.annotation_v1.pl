#! /usr/bin/perl

=head1 Program: MLG.annotation_v1.pl

=head1 Version: V1.0

=head1 Updated: Aug 14 2014, Thursday, 11:11:11

=head1 Description: This program was used to annotation MLG (i85%,c80%---genus; i95%,c90%---species)

=head1 
        	
	Usage: perl MLG.annotation_v1.pl [options]

        Options: 
        -b  <str> 9.9M geneset strain blastout file [blastn.out.conn.i65c80.mlg.strain.t]  
	-s  <str> mlg-gene list [xx.reads_count.m6.p01.pat.corr.s60.sort]     
	-l  <str> geneset.len.info [203.uniqgeneset.fa.len.info]
        -p  <str> geneset protein fasta file [xx.uniqGeneset.pep.fa]
        -t  <str> mlg.stat [xx.mlg.stat]
        -o  <str> prefix of output file [mlg.anno.tax]
        --queue <str>  marker the queue [STN11029]     
        --database <str>  choose database [nr_bact] 
        --identity <num>  set the BLAST identity cutoff [85]
	
Contact: wangxiaokai@genomics.org.cn
   
=head1 Example

nohup perl /ifs1/ST_META/USER/wangxiaokai/mlg.anno/mlg.annotation_v1.pl -b /ifs1/ST_META/USER/wangxiaokai/RA/dental/105.mlg/mlg.tax/blastn.out.conn.i65c80.mlg.strain.t -s /ifs1/ST_META/USER/wangxiaokai/mlg.anno/test.s60.sort -l /ifs5/PC_MICRO_META/PRJ/MetaPrj/480_203RAOralGenesetSMem2/480.203RAOralGenesetSMem2/geneset/uniq/203.uniqGeneset.fa.len.info -p /ifs5/PC_MICRO_META/PRJ/MetaPrj//480_203RAOralGenesetSMem2/480.203RAOralGenesetSMem2/geneset/uniq/203.uniqGeneset.pep -t /ifs1/ST_META/USER/wangxiaokai/RA/saliva/mlg/98.mlg.stat -o mlg.anno.tax --queue STN11029 --database nr_bact --identity 85 
     	
=cut


use strict;
use warnings;

use FindBin qw($Bin $Script);
use lib "$FindBin::Bin/";
use File::Basename qw(basename dirname);
use Getopt::Long;
use Data::Dumper;
use Pod::Text;
use threads;
use threads::shared;

##initialize some parameters fot GetOptions
our ($blast, $list, $len, $pep, $database, $identity, $queue, $stat, $out);

GetOptions( 
        "b=s"=>\$blast,
	"s=s"=>\$list,
	"l=s"=>\$len,
        "p=s"=>\$pep,
        "t=s"=>\$stat,
        "o=s"=>\$out,
        "database=s"=>\$database,
        "identity=f"=>\$identity,
        "queue=s"=>\$queue,
);
##get the introduction information
die `pod2text $0` if ( !$blast );


print STDERR "Program Beginning...\n";

###### get mlg.gene.list
`perl $FindBin::Bin/get.mlg.gene.list.pl $blast $list mlg.i85.c80.mlg.list`;
###### get mlg.shift
`perl $FindBin::Bin/mlg.shift.pl mlg.i85.c80.mlg.list mlg.i85.c80.mlg.shift`;
###### get mlg.gene-sample
`perl $FindBin::Bin/extract.pl -i $len -t mlg.i85.c80.mlg.shift -o mlg.i85.c80.gene-sample -r -s `;
###### get sample.id
`awk '{print \$2}' mlg.i85.c80.gene-sample >mlg.i85.c80.sample.id`;
###### get mlg.gene.pep.fa
`perl $FindBin::Bin/extract.seq.hash.pl mlg.i85.c80.sample.id $pep mlg.i85.c80.pep.fa`;
###### run blastp
`perl /ifs5/PC_MICRO_META/PRJ/MetaSystem/analysis_flow/bin/program/annotation/NR/Bin/NR_LCA.pl mlg.i85.c80.pep.fa --queue $queue --database $database --identity $identity  --out mlg.i85.c80.pep.fa.blastp \&`;
###### process blastout file & get mlg.anno
system `cat mlg.i85.c80.pep.fa| perl -e 'while(<>){chomp; /^>(\\S+)/; chomp(\$seq=<>); print \$1, "\t", length(\$seq), "\n";}' > mlg.i85.c80.pep.fa.length`;
system `cat Split/*.blastout > mlg.i85.c80.pep.blastout`;
`rm -rf Split`;
`/ifs1/ST_MD/USER/chenwn/bin/blast/connect_blast mlg.i85.c80.pep.blastout mlg.i85.c80.pep.blastp.conn 0`;
`perl $FindBin::Bin/change.m8.id.pl $len mlg.i85.c80.pep.blastp.conn > mlg.i85.c80.pep.blastp.conn.new`;
`perl $FindBin::Bin/change.m8.id.pl $len mlg.i85.c80.pep.fa.length > mlg.i85.c80.pep.fa.length.new`;
`sh $FindBin::Bin/blastp_filter_and_tax.sh mlg.i85.c80.pep.blastp.conn.new mlg.i85.c80.pep.fa.length.new`;
`perl $FindBin::Bin/mlg_tax_by_each_identity.pl $blast mlg.i85.c80.pep.blastp.conn.new.f.f.f $list > mlg.anno`;
###### process mlg.stat
`cut -f 1,2,5,16- $stat >mlg.tax`;
###### rename
`perl $FindBin::Bin/anno.rename.pl mlg.anno mlg.tax $out`;
#`shopt -s extglob`;
#`rm -fr !($out)`;

print STDERR "Program End!\n";
sub function{}
