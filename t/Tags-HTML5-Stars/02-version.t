use strict;
use warnings;

use Tags::HTML5::Stars;
use Test::More 'tests' => 2;
use Test::NoWarnings;

# Test.
is($Tags::HTML5::Stars::VERSION, 0.01, 'Version.');
