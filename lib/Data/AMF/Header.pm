package Data::AMF::Header;

use strict;
use warnings;

use base 'Class::Accessor::Fast';

__PACKAGE__->mk_accessors(qw/name must_understand value version/);

=head1 NAME

Data::AMF::Header - AMF message header

=head1 ACCESSORS

=head2 name

=head2 must_understand

=head2 value

=head2 version

=head1 AUTHOR

Daisuke Murase <typester@cpan.org>

=head1 COPYRIGHT

This program is free software; you can redistribute
it and/or modify it under the same terms as Perl itself.

The full text of the license can be found in the
LICENSE file included with this module.

=cut

1;


