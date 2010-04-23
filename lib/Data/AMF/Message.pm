package Data::AMF::Message;

use strict;
use warnings;

use base 'Class::Accessor::Fast';
use Scalar::Util qw/blessed/

__PACAKGE__->mk_accessors(qw(target_uri response_uri value source version))

sub result {
    my ($self, $obj) = @_;

    my $class = blessed $self;

    $class->new(
        target_uri   => $self->response_uri . '/onResult',
        response_uri => '',
        value        => $obj,
        version      => $self->version,
    );
}

sub error {
    my ($self, $obj) = @_;

    my $class = blessed $self;

    $class->new(
        target_uri   => $self->response_uri . '/onStatus',
        response_uri => '',
        value        => $obj,
        version      => $self->version,
    );
}

=head1 NAME

Data::AMF::Message - AMF Message class

=head1 SYNOPSIS

    use Data::AMF::Packet;
    
    # get message
    my $packet   = Data::AMF::Packet->deserialize($amf_packet);
    my $messages = $packet->messages;
    
    # do something about it
    my $first_request = $messages->[0];
    
    # and return response
    my $response = $first_request->result($perl_object_you_want_to_return);

=head1 DESCRIPTION

Data::AMF::Message is an object class for AMF Packet Message.

=head1 SEE ALSO

L<Data::AMF::Packet>, L<Catalyst::Controller::FlashRemoting>

=head1 METHODS

=head2 new

Create new Data::AMF::Message object.

=head2 result($result)

Return normal response AMF Message object against current request of AMF Message.

=head2 error($error)

Return error response AMF Message object against current request of AMF Message.

=head1 AUTHOR

Daisuke Murase <typester@cpan.org>

=head1 COPYRIGHT

This program is free software; you can redistribute
it and/or modify it under the same terms as Perl itself.

The full text of the license can be found in the
LICENSE file included with this module.

=cut

1;

