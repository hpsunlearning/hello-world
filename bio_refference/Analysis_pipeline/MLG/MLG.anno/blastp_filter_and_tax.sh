if [ $# -ne 2 ]; then echo "sh $0 blast.conn gene.length"; exit; fi
/home/lishenghui/bin/filter_blast -i $1 -o $1.f --qfile $2 --qper 70
perl /ifs1/ST_META/USER/lishenghui/bacteria/optBlast/Taxonomy/bin/AppendTax_by_Gi.pl $1.f /ifs1/ST_MD/USER/chenwn/database/taxonomy/20131211/names.dmp /ifs1/ST_MD/USER/chenwn/database/taxonomy/20131211/nodes.dmp /ifs1/ST_MD/USER/chenwn/database/taxonomy/20131211/gi_taxid_prot.dmp $1.f.taxo
perl -ne 'chomp;s/ /_/g;@s=split /\t/;@g=split /\|/,$s[13];print "$s[0]\t$g[-1]\t$s[2]\n";' < $1.f.taxo > $1.f.f
perl -e '%uniq; while(<>){chomp;@s=split /\t/;$a = "$s[0]\t$s[1]";$uniq{$a} = $s[2] unless $uniq{$a} > $s[2];} for(keys %uniq){print "$_\t$uniq{$_}\n";}' $1.f.f | awk -F "\t" '{print $1"\t"$3"\t"$2}' |/opt/blc/self-software/bin/msort -k n1,rn2 > $1.f.f.f
