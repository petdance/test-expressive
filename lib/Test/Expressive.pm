package Test::Expressive;

use 5.010;
use strict;
use warnings;

use Test2::API qw( context );

use Test::More;
use Scalar::Util qw( looks_like_number );

=head1 NAME

Test::Expressive - Test functions that say what you really mean.

=head1 VERSION

Version 0.01

=cut

our $VERSION = '0.01';

use base 'Exporter';

our @EXPORT_OK = qw(
    is_number
    is_integer
    is_positive_integer
    is_nonnegative_integer
    cmp_integer_ok
    is_even
    is_odd

    bool_eq

    is_undef

    is_empty_array
    is_nonempty_array

    is_empty_hash
    is_nonempty_hash

    is_nonblank
    is_blank

    keys_exist_ok

    maybe_others_from_carp_asssert_more
);

our @EXPORT = @EXPORT_OK;

=head1 SYNOPSIS

    use Test::Expressive;

    my @array = get_widgets();
    is_even( scalar @a, '@array must have an even number of widgets' );

    is_empty_array( \@errors, 'Should have received no errors back' );

    is_nonempty_array( \@warnings, 'Got back at least one warning' );

=head1 WHY TEST::EXPRESSIVE?

Test::Expressive is designed to make your code more readable, based
on the idea that reading English is easier and less prone to
misinterpretation than reading Perl, and less prone to error by
reducing common cut & paste tasks.

Conside either of these two tests:

    ok( $x % 2 == 0 );
    is( $x % 2, 0 );

What are they doing?  They're testing that C<$x> is an even number.
It's a common expression that every programmer knows.  Most any programmer
will see that and think "Aha, it's testing to see if it's an even number."

Better still to make it explicitly clear, in English, what you're trying
to accomplish:

    is_even( $x );

Test::Expressive also does more stringent checking than the common quick
tests that we put in.  These tests will all pass.  You probably don't
want them to.

    for my $x ( undef, 'foo', {}, [] ) {
        ok( $x % 2 == 0 );
    }


Test::Expressive is based on the idea that the reader should be able to
tell as much from English as possible without having to decipher code.

=head1 EXPORT

All functions in this module are exported by default.

=head1 NUMERIC SUBROUTINES

=head1 is_number( $n [, $name ] )

Tests that 

=cut

sub is_number($;$) {
    local $Test::Builder::Level = $Test::Builder::Level + 1;

    my $n    = shift;
    my $name = shift;

    my $n_desc = $n // 'undef';

    return ok( looks_like_number( $n ), $name );
}

=head2 is_integer( $n [, $name ] )

Tests if C<$n> is an integer.

The following are integers:

    1
    -1
    +1
    0E0
    9E14
    -9E14

The following are not:

    string representations of integers
    1.
    1.0
    'abc'
    ''
    undef
    Any reference

=cut

sub is_integer($;$) {
    local $Test::Builder::Level = $Test::Builder::Level + 1;

    my $n    = shift;
    my $name = shift // '';

    return subtest "is_integer( $name )" => sub {
        ok( looks_like_number( $n ), 'is_integer needs a number' )
            and
        like( $n, qr/^[-+]?\d+(?:E\d+)?$/, "is_integer( $name )" );
    };
}


=head2 cmp_integer_ok( $got, $op, $expected [, $name ] )

Tests that both C<$got> and C<$expected> are valid integers, and match
the comparator C<$op>.

This is a strengthened version of C<cmp_ok>.  With normal C<cmp_ok>,
you can get back unexpected values that still match, such as:

    cmp_ok( '',    '==', 0 );       # Passes
    cmp_ok( undef, '==', 0 );       # Passes
    cmp_ok( 'abc', '==', 0 );       # Passes
    cmp_ok( 'abc', '==', 'xyz' );   # Passes

These will all throw various warnings if the C<warnings> pragma is on,
but the tests will still pass.

C<cmp_integer_ok> is more stringent and will catch accidental passes.

    cmp_integer_ok( '',    '==', 0 );   # Fails
    cmp_integer_ok( undef, '==', 0 );   # Fails

It also checks that your comparator is valid.

    cmp_integer_ok( 0,     'eq', 0 );   # Fails because 'eq' isn't valid for integers

=cut

my %valid_integer_op = map { $_ => 1 } qw( == != > >= < <= );

sub cmp_integer_ok($$$;$) {
    local $Test::Builder::Level = $Test::Builder::Level + 1;

    my $got      = shift;
    my $op       = shift;
    my $expected = shift;
    my $name     = shift // '';

    return subtest "cmp_integer_ok( $name )" => sub {
        ok( $valid_integer_op{ $op }, "$op is a valid integer operator" )
            and
        is_integer( $got )
            and
        is_integer( $expected )
            and
        cmp_ok( $got, $op, $expected );
    };
}


=head2 is_positive_integer( $n [, $name ] )

=cut

sub is_positive_integer($;$) {
    local $Test::Builder::Level = $Test::Builder::Level + 1;

    my $n    = shift;
    my $name = shift;

    return cmp_integer_ok( $n, '>', 0, $name );
}


=head2 is_nonnegative_integer( $n [, $name ] )

=cut

sub is_nonnegative_integer($;$) {
    local $Test::Builder::Level = $Test::Builder::Level + 1;

    my $n    = shift;
    my $name = shift;

    return cmp_integer_ok( $n, '>=', 0, $name );
}


=head2 is_even( $n [, $name ] )

Checks whether the number C<$n> is a nonnegative integer and is even or zero.

=cut

sub is_even($;$) {
    local $Test::Builder::Level = $Test::Builder::Level + 1;

    my $n   = shift;
    my $name = shift;

    return subtest "is_even( $name )" => sub {
        is_nonnegative_integer( $n )
            && ok( $n % 2 == 0, 'Is it divisible by two?' );
    };
}


=head2 is_odd( $n [, $name ] )

Checks whether the number C<$n> is a nonnegative integer and is odd.

=cut

sub is_odd($;$) {
    local $Test::Builder::Level = $Test::Builder::Level + 1;

    my $n   = shift;
    my $name = shift;

    return subtest "is_odd( $name )" => sub {
        is_nonnegative_integer( $n )
            && ok( $n % 2 == 0, 'Is it divisible by two?' );
    };
}


=head1 AUTHOR

Andy Lester, C<< <andy at petdance.com> >>

=head1 BUGS

Please report any bugs or feature requests to
C<bug-test-expressive at rt.cpan.org>,
or through the web interface at
L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Test-Expressive>.
I will be notified, and then you'll automatically be notified of progress
on your bug as I make changes.

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc Test::Expressive

You can also look for information at:

=over 4

=item * RT: CPAN's request tracker (report bugs here)

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=Test-Expressive>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/Test-Expressive>

=item * Search CPAN

L<http://search.cpan.org/dist/Test-Expressive/>

=back

=head1 ACKNOWLEDGEMENTS

None yet.

=head1 LICENSE AND COPYRIGHT

Copyright 2016 Andy Lester.

This program is free software; you can redistribute it and/or modify it
under the terms of the the Artistic License (2.0).

=cut

1; # End of Test::Expressive
