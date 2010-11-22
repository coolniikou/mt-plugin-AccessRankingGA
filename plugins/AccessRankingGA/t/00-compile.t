#!/usr/bin/perl

use strict;
use lib  qw( t/lib lib extlib );
use warnings;
use MT;
use Test::More tests => 5;
use MT::Test;

ok(MT->component ('AccessRankingGA'), "AccessRankingGA plugin loaded correctry");

require_ok('AccessRankingGA::L10N');
require_ok('AccessRankingGA::L10N::ja');
require_ok('AccessRankingGA::L10N::en_us');
require_ok('AccessRankingGA::Plugin');

1;
