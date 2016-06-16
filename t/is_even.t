#!perl -T

use strict;
use warnings;

use Test::More tests => 3;

use Test2::API qw( intercept );

use Test::Expressive;

#my $events = intercept {
#    is_even( 2, 'pass' );
#    is_even( 1, 'fail' );
#};
#use Data::Dumper;
#warn Dumper( $events );

is_even( 0, '0 is even' );
is_even( 2, '2 is even' );
is_even( 10238423408530452, 'big long even number is even' );

done_testing();

exit 0;
