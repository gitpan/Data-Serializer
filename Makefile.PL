use ExtUtils::MakeMaker;
#
#Jump to end of file to see makefile created, first we want to dynamically
#build our tests
#
unless (-d "./t") {
  mkdir ("./t");
}

my %extensions;

foreach my $ext (qw (Crypt::CBC Compress::Zlib Tie::Transient)) {
  my $valid = (eval "require $ext") ? 1 : 0; 
  $extensions{$ext} = $valid;
  unless($valid) {
    my $template = build_skip_test($ext);  
    write_test($ext,$template);
  }
}

foreach my $serializer qw (Data::Dumper Data::Denter Storable FreezeThaw) {
  my $template;
  my $test_count;
  if (eval "require $serializer") {
    $template = build_test_start($serializer);  
    $test_count = 6;
    foreach my $ext (keys %extensions) {
      if ($extensions{$ext}) {
        my ($add,$count)= add_tests($ext);
        $template .= $add;
        $test_count += $count;
      }
    }
    $template =~ s/\@TESTCOUNT\@/$test_count/g;
  } else {
    $template = build_skip_test($serializer);  
  }
  write_test($serializer,$template);
}

sub write_test {
  my $serializer = (shift);
  my $code = (shift);
  $serializer =~ s#::#_#;
  open(FILE, "> t/$serializer.t") or die "Couldn't write t/$serializer.t: $!\n";
  print FILE $code;
  close(FILE);
}



sub build_skip_test {
  my $module = (shift);
  my $return = <<'ENDOFSKIPSTART';
my $module = @MODULE@;

BEGIN { $|=1; $^W=1; }

use strict;
use Test;

BEGIN { plan tests => 1 };
skip("$module not installed: skipping","$module not installed: skipping");

ENDOFSKIPSTART
  $return =~ s/\@MODULE\@/$module/g;
  return $return;
}

sub build_test_start {
  my $module = (shift);
  my $return = <<'ENDOFSTART';
my $module = @MODULE@;

BEGIN { $|=1; $^W=1; }

use strict;
use Test;

BEGIN { plan tests => @TESTCOUNT@ };

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


#
# start base tests
#

# Create a serializer object
ok my $obj = Data::Serializer->new(serializer=>$module),qr/Data::Serializer/, "Failed to create a Data::Serializer object";


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
# end base tests
#
ENDOFSTART
  $return =~ s/\@MODULE\@/$module/g;
  return $return;
}
sub add_tests {
  my $test = (shift);
  if ($test eq 'Crypt::CBC') {
    return build_encryption_test();
  } elsif ($test eq 'Compress::Zlib') {
    return build_compression_test();
  } elsif ($test eq 'Tie::Transient') {
    return build_transient_test();
  } else {
    die "Asked for undefined test type: $test\n";
  }
}
sub build_transient_test {
  my $return=<<'ENDOFTRANSIENT';

#
# start transient tests
#
{
use Tie::Transient::Hash;
my %transhash; 
tie %transhash,  q(Tie::Transient::Hash), q(alpha);
%transhash = %{$hashref};

my $frozen_hash = $obj->serialize(\%transhash);
my $thawed_hash = $obj->deserialize($frozen_hash);

ok($thawed_hash->{alpha},undef);
ok($thawed_hash->{beta},$transhash{beta});

#use Tie::Transient::Array;
#my @transarray; 
#tie @transarray,  q(Tie::Transient::Array), q(0);
#@transarray = @{$arrayref};
#
#my $frozen_array = $obj->serialize($arrayref);
#my $thawed_array = $obj->deserialize($frozen_array);
#
#ok(scalar(@{$thawed_array}),2);
#ok($thawed_array->[1],$transarray[2]);
}
#
# end transient tests
#
ENDOFTRANSIENT
  return ($return,2);
}
sub build_encryption_test {
  my $return=<<'ENDOFENCRYPTION';

#
# start encryption tests
#
{
$obj->secret('test');

my $encrypted = $obj->freeze($hashref);
ok $obj->thaw($encrypted)->{alpha}, $hashref->{alpha}, "Failed encryption test";

#disable encryption
$obj->secret(undef);
}
#
# end encryption tests
#
ENDOFENCRYPTION
  return ($return,1);
}
sub build_compression_test {
  my $return=<<'ENDOFCOMPRESSION';
#
# start compression tests
#
{
$obj->compress(1);
my $compressed = $obj->freeze($hashref);
ok $obj->thaw($compressed)->{alpha}, $hashref->{alpha}, "Failed compresseion test";

#disable compression
$obj->compress(0);

#disable portability  (default is to be portable)
$obj->portable(0);

my $unencoded = $obj->freeze($hashref);
ok $obj->thaw($unencoded)->{alpha}, $hashref->{alpha}, "Failed non-portable test";
}
#
# end compression tests
#
ENDOFCOMPRESSION
  return ($return,2);
}



# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.
#
WriteMakefile(
    'NAME'		=> 'Data::Serializer',
    'DISTNAME'		=> 'Data-Serializer',
    'VERSION_FROM'	=> 'lib/Data/Serializer.pm', # finds $VERSION
    'AUTHOR'		=> 'Neil Neely (neil@frii.net)',
    'PREREQ_PM'		=> 	{
#	                 	  'Storable' => 0,
#	                 	  'FreezeThaw' => 0,
	                 	  'Data::Dumper' => 2.08,
#	                 	  'Data::Denter' => 0,
#	                 	  'Compress::Zlib' => 0,
#	                 	  'Crypt::CBC' => 0,
#      	                	  'Digest'     => 0,
       	               		},
    'dist'      => {'COMPRESS'=>'gzip -9f', 'SUFFIX' => 'gz',
                    'ZIP'=>'/usr/bin/zip','ZIPFLAGS'=>'-rl'}

);
