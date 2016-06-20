package TestExpressiveUtils;

use base 'Exporter';

our @EXPORT_OK = qw(
    tests_pass_fail
    dump_events
);

our @EXPORT = @EXPORT_OK;

use Test2::API qw( intercept );
use Test::More;

sub tests_pass_fail {
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


sub dump_events {
    my $events = shift;

    diag scalar @{$events} . ' events';
    for my $event ( @{$events} ) {
        diag $event->summary;
    }
}

1;
