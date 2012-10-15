use strict;
use warnings;
use IPC::Open2;

BEGIN {
	$ENV{MT_CONFIG} = 'mysql-test.cfg';
}

$| = 1;

use lib 't/lib', 'lib', 'extlib';
use MT::Test qw( :db :data);
use Test::More;
use JSON -support_by_pp;
use MT;
use MT::Util qw( ts2epoch epoch2ts );
use MT::Template::Context;
use MT::Builder;

require POSIX;

my $mt = MT->new();


#===== Edit here

my $test_json = <<'JSON';
[
{ "r" : "1" : "t" : "", "e" : "" },
{ "r" : "1" : "t" : "<MTAccessRankingGA>", "e" : "AccessRankingGA" },
{ "r" : "1" : "t" : "<MTAccessRankingGA span=\"1\">", "e" : "day_ago" },
{ "r" : "1" : "t" : "<MTAccessRankingGA span=\"7\">", "e" : "week" },
{ "r" : "1" : "t" : "<MTAccessRankingGA span=\"30\">", "e" : "month" },
]
JSON

#=====
$test_json =~ s/^ *#.*$//mg;
$test_json =~ s/# *\d+*(?:TBD.*)? *$//mg;
