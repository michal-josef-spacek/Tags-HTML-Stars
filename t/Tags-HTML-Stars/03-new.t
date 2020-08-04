use strict;
use warnings;

use English;
use Error::Pure::Utils qw(clean);
use Tags::HTML::Stars;
use Tags::Output::Raw;
use Test::More 'tests' => 3;
use Test::NoWarnings;

# Test.
my $obj = Tags::HTML::Stars->new(
	'tags' => Tags::Output::Raw->new,
);
isa_ok($obj, 'Tags::HTML::Stars');

# Test.
eval {
	Tags::HTML::Stars->new;
};
is(
	$EVAL_ERROR,
	"Parameter 'tags' must be a 'Tags::Output::*' class.\n",
	"Missing required parameter 'tags'.",
);
clean();
