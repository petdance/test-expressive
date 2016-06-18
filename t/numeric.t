#!perl -T

use strict;
use warnings;

use Test::More tests => 4;

use Test2::API qw( intercept );

use Test::Expressive;

#    cmp_integer_ok
#    is_even
#    is_odd


subtest is_number => sub {
    my %passers = (
        'zero'           => 0,
        'one'            => 1,
        'negative one'   => -1,
        'two point'      => 2.,
        'two point zero' => 2.0,
        '0E0'            => 0E0,
        'sqrt(2)'        => sqrt(2),
        'six million'    => 6_000_000,
    );

    my %failers = (
        'noisy punctuation' => '=1',
        'sign at the end'   => '1-',
        'letters'           => 'abc',
        'empty string'      => '',
        'undef'             => undef,
        'arrayref'          => [],
        'hashref'           => {},
    );

    _tests_pass_fail( \&is_number, \%passers, \%failers );
};


subtest is_integer => sub {
    my %passers = (
        'zero'                 => 0,
        'one'                  => 1,
        'negative one'         => -1,
        '0 but true'           => 0E0,
        'postive exponential'  => 9E14,
        'negative exponential' => -9E14,
    );

    my %failers = (
        'decimal'           => '1.',
        'decimal.0'         => '1.0',
        'noisy punctuation' => '=1',
        'sign at the end'   => '1-',
        'letters'           => 'abc',
        'empty string'      => '',
        'undef'             => undef,
        'arrayref'          => [],
        'hashref'           => {},
    );

    _tests_pass_fail( \&is_integer, \%passers, \%failers );
};


subtest is_positive_integer => sub {
    my %passers = (
        'one'          => 1,
        'big exponent' => 9E14,
    );

    my %failers = (
        'zero'              => 0,
        'negative 1'        => -1,
        '0E0'               => 0E0,
        'decimal'           => '1.',
        'decimal.0'         => '1.0',
        'decimal.999999'    => '1.999999',
        'noisy punctuation' => '=1',
        'sign at the end'   => '1-',
        'letters'           => 'abc',
        'empty string'      => '',
        'undef'             => undef,
        'arrayref'          => [],
        'hashref'           => {},
    );

    _tests_pass_fail( \&is_positive_integer, \%passers, \%failers );
};


subtest is_nonnegative_integer => sub {
    my %passers = (
        'zero'          => 0,
        'zero but true' => 0E0,
        'one'           => 1,
        'six million'   => 6_000_000,
        'big exponent'  => 9E14,
    );

    my %failers = (
        'negative 1'        => -1,
        'decimal'           => '1.',
        'decimal.0'         => '1.0',
        'noisy punctuation' => '=1',
        'sign at the end'   => '1-',
        'letters'           => 'abc',
        'empty string'      => '',
        'undef'             => undef,
        'arrayref'          => [],
        'hashref'           => {},
    );

    _tests_pass_fail( \&is_nonnegative_integer, \%passers, \%failers );
};

done_testing();

exit 0;


sub _tests_pass_fail {
    local $Test::Builder::Level = $Test::Builder::Level + 1;

    my $sub     = shift;
    my $passers = shift;
    my $failers = shift;

    while ( my ($desc,$val) = each %{$passers} ) {
        my $events = intercept { $sub->( $val ) };
        my $fails_somewhere = grep { $_->causes_fail } @{$events};
        ok( !$fails_somewhere, "Should pass: $desc" );
    }

    while ( my ($desc,$val) = each %{$failers} ) {
        my $events = intercept { $sub->( $val ) };
        my $fails_somewhere = grep { $_->causes_fail } @{$events};
        ok( $fails_somewhere, "Should fail: $desc" );
    }
}


sub _dump_events {
    my $events = shift;

    diag scalar @{$events} . ' events';
    for my $event ( @{$events} ) {
        diag $event->summary;
    }
}
