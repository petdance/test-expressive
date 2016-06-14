#!perl -T
use 5.010;
use strict;
use warnings;
use Test::More;

plan tests => 1;

BEGIN {
    use_ok( 'Test::Expressive' ) || print "Bail out!\n";
}

diag( "Testing Test::Expressive $Test::Expressive::VERSION, Perl $], $^X" );
