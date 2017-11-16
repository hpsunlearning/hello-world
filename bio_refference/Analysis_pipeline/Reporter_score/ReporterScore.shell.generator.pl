use strict;
use Cwd;
use Getopt::Std;
sub usage{
	print STDERR <<USAGE;
	Vision 1 2014-1-6
	Usage: perl $0 -p <profile> -c <config> -o <output> -l <color.config> -t <color.pallete>
	Options
	-p <c>:  KO profile
	-c <c>:  config file. 2 columns, no head, same order as profile. 
	-o <c>:  output shell file
	-l    :  color.config
	-t    :  color.pallete, default 0:green, 1:red, 0/1 as in the config file.
USAGE
}
our ($opt_p,$opt_c,$opt_o,$opt_l,$opt_t);
getopts("p:c:o:l:t:");
unless($opt_p && $opt_c && $opt_o){
	usage;
	exit;
}
my $out_sh=$opt_o;
$out_sh=$opt_o.".sh" unless $opt_o=~/\.sh\z/; 

open SHELL,"/ifs1/ST_META/USER/zhangdy/Meta_pipeline/Analysis_pipeline/Reporter_score/ReporterScore.sh" or die "/ifs1/ST_META/USER/zhangdy/Meta_pipeline/Analysis_pipeline/Reporter_score/ReporterScore.sh not found.\n";
open OUT, ">$out_sh" or die;

my $profile=$opt_p;
my $config=$opt_c;
my $color_config="/ifs1/ST_META/USER/zhangdy/Meta_pipeline/Analysis_pipeline/Reporter_score/color.config";
my $color_pallete="/ifs1/ST_META/USER/zhangdy/Meta_pipeline/Analysis_pipeline/Reporter_score/color.pallete.ctrl0.case1";

$profile=getcwd."/".$opt_p unless $opt_p=~/\A\//;
$config=getcwd."/".$opt_c unless $opt_c=~/\A\//;
if (defined $opt_l){$color_config=$opt_l;$color_config=getcwd."/".$opt_l unless $opt_l=~/\A\//;}
if (defined $opt_t){$color_pallete=$opt_t;$color_pallete=getcwd."/".$opt_t unless $opt_t=~/\A\//;;}
while (<SHELL>){
	chomp;
	s/kegg\.prof\.normalize/$profile/g;
	s/config\.file/$config/g;
	s/color\.config/$color_config/g;
	s/color\.pallete/$color_pallete/g;
	print OUT $_,"\n";
}
close SHELL;
close OUT;
