package Test::Expressive;

use 5.010;
use strict;
use warnings;

use Test2::API qw( context );

=head1 NAME

Test::Expressive - Helper functions for writing tests that say what you really mean.

=head1 VERSION

Version 0.01

=cut

our $VERSION = '0.01';

use base 'Exporter';

our @EXPORT_OK = qw(
    is_even
);

our @EXPORT = @EXPORT_OK;



=head1 SYNOPSIS

    use Test::Expressive;

    my @array = get_widgets();
    is_even( scalar @a, '@array must have an even number of widgets' );

    is_empty_array( \@errors, 'Should have received no errors back' );

    is_nonempty_array( \@warnings, 'Got back at least one warning' );

=head1 WHY TEST::EXPRESSIVE?

Test::Expressive is designed to make your code more readable, based on the
idea that reading English is easier and less prone to misinterpretation
than reading Perl, and less prone to error by reducing common cut &
paste tasks.

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

=cut

=head1 SUBROUTINES

=head2 is_even( $n [, $name ] )

Checks whether the number C<$n> is a nonnegative integer and is even or zero.

=cut

use Test::More;
sub is_even($;$) {
    local $Test::Builder::Level = $Test::Builder::Level + 1;

    my $n   = shift;
    my $name = shift;

    return subtest "is_even( $name )" => sub {
        like( $n, qr/^\d+$/, 'Is it looking like an integer?' );
        cmp_ok( $n, '>=', 0, 'Is it non-negative?' );
        is( $n % 2, 0, 'Is it divisible by two?' );
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

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/Test-Expressive>

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
