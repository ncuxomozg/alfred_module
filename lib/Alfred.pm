package Alfred;

use strict;
use warnings;
use utf8;
use 5.010;

sub new {
    my $class  = shift;
    my %params = @_;
    
    $params{_data} = [];
    my $obj = bless \%params, $class;
    
    $obj->add( $params{items} ) if $params{items};

    return $obj;
}

sub add {
    my $self  = shift;
    my $items = shift;

    $self->_add_one( $items ) if ref $items eq 'HASH';

    if ( ref $items eq 'ARRAY' ) {
        $self->_add_one( $_ ) foreach @{ $items }; 
    };
}

sub xml {
    my $self = shift;

    my $xml = qq|<?xml version="1.0" encoding="UTF-8"?>\n\t<items>|;

    foreach my $item ( @{ $self->{_data} }) {
        my $valid = $item->{valid} ? 'yes' : 'no';
        map { $item->{$_} = $self->_xml_escape( $item->{$_} ) } keys %{ $item };
        $xml .= qq|
            <item uid='$item->{uid}' value='$valid' autocomplete='$item->{autocomplete}' arg='$item->{arg}'>
                <title>$item->{title}</title>
                <subtitle>$item->{subtitle}</subtitle>
                <icon>$item->{icon}</icon>
            </item>|;
    }

    $xml .= qq|\n\t</items>\n|;
    $xml =~ s/\t/    /g;

    return $xml;
}

sub json {
    # alfred v3.0 or higher only
    # ...
}

sub _get_data { return shift->{_data} };
sub _add_one {
    my $self = shift;
    my $item = shift;

    return unless $item;

    push @{ $self->{_data} }, {
        uid          => $item->{uid}          || '',
        valid        => $item->{valid}        || 1,
        title        => $item->{title}        || '',
        subtitle     => $item->{subtitle}     || '',
        icon         => $item->{icon}         || '',
        autocomplete => $item->{autocomplete} || '',
        arg          => $item->{arg}          || '',
    }; 
};

sub _validate {
    my $self = shift;
    my $item = shift;
}

sub _xml_escape {
    my $self = shift;
    my $string = shift;

    $string =~ s/\"/&quot;/g;
    $string =~ s/'/&apos;/g;
    $string =~ s/</&lt;/g;
    $string =~ s/>/&gt;/g;
    $string =~ s/&/&amp;/g;
    
    return $string;
}

1;
