# -*- mode: perl -*-
# ============================================================================

my $serializer = 'Storable';

BEGIN { $|=1; $^W=1; }

use strict;
use Test;

BEGIN { plan tests => 9 };

my $hashref = { alpha => 1,
		beta  => 2 };

my $arrayref = [qw ( one two three ) ];

my $complexref = {
			apple  => [qw ( one two three ) ],
                        orange => { alpha => 1, beta  => 2 },
			pear   => { chain => {hippie => 'smelly', donkey => 'worship'}, monkey => 3 },
		 };
# Load the socket module
use Data::Serializer; 

# Create a serializer object
ok my $obj = Data::Serializer->new(serializer=>$serializer),qr/Data::Serializer/, "Failed to create a Data::Serializer object";


#test hashref
my $frozen_hash = $obj->serialize($hashref);
my $thawed_hash = $obj->deserialize($frozen_hash);
ok $thawed_hash->{alpha}, $hashref->{alpha}, "Failed to deserialize a hash reference";

#test arrayref
my $frozen_array = $obj->serialize($arrayref);
my $thawed_array = $obj->deserialize($frozen_array);
ok $thawed_array->[1], $arrayref->[1], "Failed to deserialize a array reference";

#test complexref
my $frozen_complex = $obj->serialize($complexref);
my $thawed_complex = $obj->deserialize($frozen_complex);

ok $thawed_complex->{apple}->[1], $complexref->{apple}->[1], "Failed to deserialize a complex reference (hash of arrays)";
ok $thawed_complex->{orange}->{alpha}, $complexref->{orange}->{alpha}, "Failed to deserialize a complex reference (hash of hashes)";
ok $thawed_complex->{pear}->{chain}->{hippie}, $complexref->{pear}->{chain}->{hippie}, "Failed to deserialize a complex reference (hash of hashes)";

#
# test encryption
#
$obj->secret('test');

my $encrypted = $obj->freeze($hashref);
ok $obj->thaw($encrypted)->{alpha}, $hashref->{alpha}, "Failed encryption test";

#disable encryption
$obj->secret(undef);

#enable compression
$obj->compress(1);
my $compressed = $obj->freeze($hashref);
ok $obj->thaw($compressed)->{alpha}, $hashref->{alpha}, "Failed compresseion test";

#disable compression
$obj->compress(0);

#disable portability  (default is to be portable)
$obj->portable(0);

my $unencoded = $obj->freeze($hashref);
ok $obj->thaw($unencoded)->{alpha}, $hashref->{alpha}, "Failed non-portable test";

# ============================================================================
