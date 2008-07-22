package Data::AMF::Packet;
use Moose;

require bytes;
use Data::AMF::Parser;
use Data::AMF::Formatter;
use Data::AMF::IO;

use Data::AMF::Header;
use Data::AMF::Message;

has version => (
    is      => 'rw',
    isa     => 'Int',
    lazy    => 1,
    default => sub { 0 },
);

has headers => (
    is      => 'rw',
    isa     => 'ArrayRef',
    lazy    => 1,
    default => sub { [] },
);

has messages => (
    is      => 'rw',
    isa     => 'ArrayRef',
    lazy    => 1,
    default => sub { [] },
);

__PACKAGE__->meta->make_immutable;

sub deserialize {
    my ($class, $data) = @_;

    my $io = Data::AMF::IO->new( data => $data );

    my $ver           = $io->read_u16;
    my $header_count  = $io->read_u16;
    my $message_count = $io->read_u16;

    my $parser = Data::AMF::Parser->new( version => $ver );

    my @headers;
    for my $i (1 .. $header_count) {
        my $name  = $io->read_utf8;
        my $must  = $io->read_u32;
        my $len   = $io->read_u32;
        my $value = $parser->parse_one($io);

        push @headers, Data::AMF::Header->new(
            name            => $name,
            must_understand => $must,
            length          => $len,
            value           => $value,
            version         => $ver,
        );
    }

    my @messages;
    for my $i (1 .. $message_count) {
        my $target_uri   = $io->read_utf8;
        my $response_uri = $io->read_utf8;
        my $len          = $io->read_u32;

        my $data    = $io->read($len);
        my ($value) = $parser->parse($data);

        push @messages, Data::AMF::Message->new(
            target_uri   => $target_uri,
            response_uri => $response_uri,
            length       => $len,
            value        => $value,
            version      => $ver,
        );
    }

    Data::AMF::Packet->new(
        version  => $ver,
        headers  => \@headers,
        messages => \@messages,
    );
}

sub serialize {
    my $self = shift;

    my $io = Data::AMF::IO->new( data => q[] );

    $io->write_u16( $self->version );
    $io->write_u16( scalar @{ $self->headers } );
    $io->write_u16( scalar @{ $self->messages } );

    for my $header (@{ $self->headers }) {
        $io->write_utf8( $header->name );
        $io->write_u32( $header->must_understand );

        my $data = Data::AMF::Formatter->new( version => $self->version )->format( $header->value );
        $io->write_u32( bytes::length($data) );
        $io->write($data);
    }

    for my $message (@{ $self->messages }) {
        $io->write_utf8( $message->target_uri );
        $io->write_utf8( $message->response_uri );

        my $data = Data::AMF::Formatter->new( version => $self->version )->format( $message->value );
        $io->write_u32( bytes::length($data) );
        $io->write($data);
    }

    $io->data;
}

=head1 NAME

Data::AMF::Packet - serialize / deserialize AMF message packet

=head1 SYNOPSIS

use Data::AMF::Packet

my $packet = Data::AMF::Packet->deserialize($data);
my $data   = $packet->serialize;

=head1 DESCRIPTION

=head1 METHODS

=head2 serialize

=head2 deserialize

=head1 AUTHOR

Daisuke Murase <typester@cpan.org>

=head1 COPYRIGHT

This program is free software; you can redistribute
it and/or modify it under the same terms as Perl itself.

The full text of the license can be found in the
LICENSE file included with this module.

=cut

1;

