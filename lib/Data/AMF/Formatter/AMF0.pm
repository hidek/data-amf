package Data::AMF::Formatter::AMF0;
use Moose;

require bytes;
use Scalar::Util qw/looks_like_number/;
use Data::AMF::IO;

has 'io' => (
    is      => 'rw',
    isa     => 'Data::AMF::IO',
    lazy    => 1,
    default => sub {
        Data::AMF::IO->new( data => q[] );
    },
);

sub format {
    my ($self, $obj) = @_;
    $self = $self->new unless blessed $self;

    if (my $pkg = blessed $obj) {
        $self->format_typed_object($obj);
    }
    elsif (my $ref = ref($obj)) {
        if ($ref eq 'ARRAY') {
            $self->format_strict_array($obj);
        }
        elsif ($ref eq 'HASH') {
            $self->format_object($obj);
        }
        else {
            confess qq[cannot format "$ref" object];
        }
    }
    else {
        if (looks_like_number($obj)) {
            $self->format_number($obj);
        }
        else {
            $self->format_string($obj);
        }
    }

    $self->io->data;
}

sub format_number {
    my ($self, $obj) = @_;
    $self->io->write_u8(0x00);
    $self->io->write_double($obj);
}

sub format_string {
    my ($self, $obj) = @_;
    $self->io->write_u8(0x02);
    $self->io->write_utf8($obj);
}

sub format_strict_array {
    my ($self, $obj) = @_;
    my @array = @{ $obj };

    $self->io->write_u8(0x0a);

    $self->io->write_u32( scalar @array );
    for my $v (@array) {
        $self->format($v);
    }
}

sub format_object {
    my ($self, $obj) = @_;

    $self->io->write_u8(0x03);

    for my $key (keys %$obj) {
        my $len = bytes::length($key);
        $self->io->write_u16($len);
        $self->io->write($key);
        $self->format($obj->{$key});
    }
    $self->io->write_u8(0x09);      # object-end marker
}

sub format_typed_object {
    my ($self, $obj) = @_;

    $self->io->write_u8(0x10);

    my $class = blessed $obj;
    $self->io->write_utf8($class);

    $self->format_object($obj);
}

1;

