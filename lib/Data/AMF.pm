package Data::AMF;
use 5.008001;
use strict;
use warnings;

our $VERSION = '0.03';

use base 'Class::Accessor::Fast';

use Data::AMF::Parser;
use Data::AMF::Formatter;

__PACKAGE__->mk_accessors(qw(version parser formatter));

sub new {
    my ($class, %args) = @_;

    $args{version}   ||= 0;
    $args{parser}    ||= Data::AMF::Parser->new(version => $args{version});
    $args{formatter} ||= Data::AMF::Formatter->new(version => $args{version});

    $class->SUPER::new(\%args);
}

sub serialize {
    my $self = shift;
    $self->formatter->format(@_);
}

sub deserialize {
    my $self = shift;
    $self->parser->parse(@_);
}

=head1 NAME

Data::AMF - serialize / deserialize AMF data

=head1 SYNOPSIS

    use Data::AMF;
    
    my $amf0 = Data::AMF->new( version => 0 );
    my $amf3 = Data::AMF->new( version => 3 );
    
    # AMF0 to Perl Object
    my $obj = $amf0->deserialize($data);
    
    # Perl Object to AMF0
    my $data = $amf0->serialize($obj);

=head1 DESCRIPTION

This module is (de)serializer for Adobe's AMF (Action Message Format).
Data::AMF is core module and it recognize only AMF data, not AMF packet. If you want to read/write AMF Packet, see Data::AMF::Packet instead.

=head1 SEE ALSO

L<Data::AMF::Packet>, L<Catalyst::Controller::FlashRemoting>

=head1 NOTICE

Data::AMF is currently in a very early alpha development stage.
The current version is not support AMF3, and application interface is still fluid.

=head1 METHOD

=head2 new(%option)

Create Data::AMF object.

Option parameters are:

=over

=item version

Target AMF version.

It should be 0 or 3. (default 0 for AMF0)

=back

=head2 serialize($obj)

Serialize perl object ($obj) to AMF, and return the AMF data.

=head2 deserialize($amf)

Deserialize AMF data to perl object, and return the perl object.

=head1 AUTHOR

Daisuke Murase <typester@cpan.org>

=head1 COPYRIGHT

This program is free software; you can redistribute
it and/or modify it under the same terms as Perl itself.

The full text of the license can be found in the
LICENSE file included with this module.

=cut

1;
