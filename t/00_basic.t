#!/usr/bin/perl

use strict;
use warnings;
use 5.010;
use lib 'lib/';
use Data::Dumper;

use Test::More;
use Test::XML;

BEGIN { use_ok "Alfred"; };

our $my_custom_data = [
    {
        uid          => 10,
        valid        => 1,
        title        => 'My new Item',
        subtitle     => 'Subtitle here',
        icon         => 'http://somelink',
        autocomplete => 'link',
        arg          => 'argument'
    }
];

my $alfred = Alfred->new( items => $my_custom_data );

subtest 'Create basic items' => sub {
    ok ( $alfred->isa('Alfred'), 'success: Is a Alfred object, btw' );
    is_deeply( $alfred->_get_data(), $my_custom_data, 'success: same data sctruct here');
};

subtest 'Get XML result' => sub {
    my $xml = $alfred->xml;
    is_well_formed_xml( $xml, 'success: valid xml' );
};

done_testing();

