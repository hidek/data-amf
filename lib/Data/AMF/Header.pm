package Data::AMF::Header;
use Moose;

has name => (
    is       => 'rw',
    isa      => 'Str',
    required => 1,
);

has must_understand => (
    is       => 'rw',
    isa      => 'Int',
    required => 1,
);

has length => (
    is       => 'rw',
    isa      => 'Int',
    required => 1,
);

has value => (
    is => 'rw',
);

has version => (
    is  => 'rw',
    isa => 'Int',
);

=head1 NAME

Data::AMF::Header - AMF message header

=head1 AUTHOR

Daisuke Murase <typester@cpan.org>

=head1 COPYRIGHT

This program is free software; you can redistribute
it and/or modify it under the same terms as Perl itself.

The full text of the license can be found in the
LICENSE file included with this module.

=cut

1;


