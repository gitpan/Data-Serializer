package Data::Serializer;

use strict;
use vars qw($VERSION @ISA @EXPORT @EXPORT_OK);

use Carp;
use IO::File;
require 5.004 ;
require Exporter;
require AutoLoader;

@ISA = qw(Exporter AutoLoader);
# Items to export into callers namespace by default. Note: do not export
# names by default without a very good reason. Use EXPORT_OK instead.
# Do not simply export all your public functions/methods/constants.

@EXPORT = qw( );
@EXPORT_OK = qw( );

$VERSION = '0.24';

# Preloaded methods go here.
{
  my %_internal;
  my %_fields = (
                  serializer => 'Data::Dumper',
                  digester   => 'SHA1',
                  cipher     => 'Blowfish',
                  encoding   => 'hex',
                  compressor => 'Compress::Zlib',
                  secret     => undef,
                  portable   => '1',
                  compress   => '0',
                  options    => {},
                 transient   => '0',
            serializer_token => '1',
                );
  sub new {
    my ($class, %args) = @_;
    my $dataref = {%_fields};
    foreach my $field (keys %_fields) {
      $dataref->{$field} = $args{$field} if defined $args{$field};
    }

    $dataref->{_key} = rand
      until $dataref->{_key} && !exists $_internal{$dataref->{_key}};

    $_internal{$dataref->{_key}} = $dataref;
    my $self = \$dataref->{_key};
    bless $self, $class;
    $self->transient(1) if (eval "require Tie::Transient");
    
    #load serializer module if it is defined
    return $self;
  }
  sub _serializer_obj {
    my $self = (shift);
    my $id = $$self;
    my $serializer;
    if (@_) {
      #if argument, then use it for serializing.
      $serializer = (shift);
    } else {
      $serializer = $_internal{$id}->{serializer};
    }
    $_internal{$id}->{serializer_obj} = {options => $self->options()};
    bless $_internal{$id}->{serializer_obj}, "Data::Serializer::$serializer";
  }
  sub serializer {
    my $self = (shift);
    my $id = $$self;
    my $return = $_internal{$id}->{serializer};
    if (@_) {
      $_internal{$id}->{serializer} = (shift);
    }
    return $return;
  }
  sub digester {
    my $self = (shift);
    my $id = $$self;
    my $return = $_internal{$id}->{digester};
    if (@_) {
      $_internal{$id}->{digester} = (shift);
    }
    return $return;
  }
  sub cipher {
    my $self = (shift);
    my $id = $$self;
    my $return = $_internal{$id}->{cipher};
    if (@_) {
      $_internal{$id}->{cipher} = (shift);
    }
    return $return;
  }
  sub compressor {
    my $self = (shift);
    my $id = $$self;
    my $return = $_internal{$id}->{compressor};
    if (@_) {
      $_internal{$id}->{compressor} = (shift);
    }
    return $return;
  }
  sub secret {
    my $self = (shift);
    my $id = $$self;
    my $return = $_internal{$id}->{secret};
    if (@_) {
      $_internal{$id}->{secret} = (shift);
    }
    return $return;
  }
  sub encoding {
    my $self = (shift);
    my $id = $$self;
    my $return = $_internal{$id}->{encoding};
    if (@_) {
      $_internal{$id}->{encoding} = (shift);
    }
    return $return;
  }
  sub transient {
    my $self = (shift);
    my $id = $$self;
    my $return = $_internal{$id}->{transient};
    if (@_) {
      $_internal{$id}->{transient} = (shift);
    }
    return $return;
  }
  sub portable {
    my $self = (shift);
    my $id = $$self;
    my $return = $_internal{$id}->{portable};
    if (@_) {
      $_internal{$id}->{portable} = (shift);
    }
    return $return;
  }
  sub options {
    my $self = (shift);
    my $id = $$self;
    my $return = $_internal{$id}->{options};
    if (@_) {
      $_internal{$id}->{options} = (shift);
    }
    return $return;
  }
  sub compress {
    my $self = (shift);
    my $id = $$self;
    my $return = $_internal{$id}->{compress};
    if (@_) {
      $_internal{$id}->{compress} = (shift);
    }
    return $return;
  }
  sub serializer_token {
    my $self = (shift);
    my $id = $$self;
    my $return = $_internal{$id}->{serializer_token};
    if (@_) {
      $_internal{$id}->{serializer_token} = (shift);
    }
    return $return;
  }
  sub _module_loader {
    my $self = (shift);
    my $id = $$self;
    my $module_name = (shift);
    return if (exists $_internal{$id}->{loaded_modules}->{$module_name});
    if (@_) {
      $module_name = (shift) . "::$module_name";
    }
    my $package = $module_name;
    $package =~ s|::|/|g;
    $package .= ".pm";
    eval { require $package };
    if ($@) {
      carp "Data::Serializer error: " . 
           "Please make sure $package is a properly installed package.\n";
      return undef;
    }
    $_internal{$id}->{loaded_modules}->{$module_name} = 1;
  }

}

#END of public functions, all following functions are for internal use only



# Autoload methods go after =cut, and are processed by the autosplit program.
1;
__END__
#Documentation follows

=head1 NAME

Data::Serializer:: - Modules that serialize data structures

=head1 SYNOPSIS

  use Data::Serializer;
  
  $obj = Data::Serializer->new();

  $obj = Data::Serializer->new(
                          serializer => 'Storable',
                          digester   => 'MD5',
                          cipher     => 'DES',
                          secret     => 'my secret',
                          compress   => 1,
                        );

  $serialized = $obj->serialize({a => [1,2,3],b => 5});
  $deserialized = $obj->deserialize($serialized);
  print "$deserialized->{b}\n";

=head1 DESCRIPTION

Provides a unified interface to the various serializing modules
currently available.  Adds the functionality of both compression
and encryption. 

=head1 EXAMPLES

=over 4

=item  Please see L<Data::Serializer::Cookbook(3)>

=head1 METHODS

=over 4

=item B<new> - constructor

  $obj = Data::Serializer->new();


  $obj = Data::Serializer->new(
                         serializer => 'Data::Dumper',
                         digester   => 'SHA1',
                         cipher     => 'Blowfish',
                         secret     => undef,
                         portable   => '1',
                         compress   => '0',
                   serializer_token => '1',
                           options  => {},
                        );


B<new> is the constructor object for Data::Serializer objects.  

=over 4

=item

The default I<serializer> is C<Data::Dumper>

=item

The default I<digester> is C<SHA1>

=item

The default I<cipher> is C<Blowfish>

=item

The default I<secret> is C<undef>

=item

The default I<portable> is C<1>

=item

The default I<encoding> is C<hex>

=item

The default I<compress> is C<0>

=item

The default I<serializer_token> is C<1>

=item

The default I<options> is C<{}> (pass nothing on to serializer)

=back

=item B<serialize> - serialize reference

  $serialized = $obj->serialize({a => [1,2,3],b => 5});

Serializes the reference specified.  

Will compress if compress is a true value.

Will encrypt if secret is defined.

=item B<deserialize> - deserialize reference

  $deserialized = $obj->deserialize($serialized);

Reverses the process of serialization and returns a copy 
of the original serialized reference.

=item B<freeze> - synonym for serialize

  $serialized = $obj->freeze({a => [1,2,3],b => 5});

=item B<thaw> - synonym for deserialize

  $deserialized = $obj->thaw($serialized);

=item B<raw_serialize> - serialize reference in raw form

  $serialized = $obj->raw_serialize({a => [1,2,3],b => 5});

This is a straight pass through to the underlying serializer,
nothing else is done. (no encoding, encryption, compression, etc)

=item B<raw_deserialize> - deserialize reference in raw form

  $deserialized = $obj->raw_deserialize($serialized);

This is a straight pass through to the underlying serializer,
nothing else is done. (no encoding, encryption, compression, etc)

=item B<secret> - specify secret for use with encryption

  $obj->secret('mysecret');

Changes setting of secret for the Data::Serializer object.  Can also be set
in the constructor.  If specified than the object will utilize encryption.

=item B<portable> - encodes/decodes serialized data

Uses B<encoding> method to ascii armor serialized data

Aids in the portability of serialized data. 

=item B<compress> - compression of data

Compresses serialized data.  Default is not to use it.  Will compress if set to a true value
  $obj->compress(1);


=item B<serializer> - change the serializer

Currently have 8 supported serializers: Storable, FreezeThaw, Data::Denter, Config::General, YAML, 
PHP::Serialization,  XML::Dumper, and Data::Dumper.

Default is to use Data::Dumper.

Each serializer has its own caveat's about usage especially when dealing with
cyclical data structures or CODE references.  Please see the appropriate
documentation in those modules for further information.

=item B<cipher> - change the cipher method

Utilizes Crypt::CBC and can support any cipher method that it supports.

=item B<digester> - change digesting method

Uses Digest so can support any digesting method that it supports.  Digesting
function is used internally by the encryption routine as part of data verification.

=item B<encoding> - change encoding method

Encodes data structure in ascii friendly manner.  Currently the only valid options
are hex, or b64. 

The b64 option uses Base64 encoding provided by MIME::Base64, but strips out newlines.

=item B<serializer_token> - add usage hint to data

Data::Serializer prepends a token that identifies what was used to process its data.
This is used internally to allow runtime determination of how to extract Serialized
data.   Disabling this feature is not recommended.

=item B<options> - pass options through to underlying serializer

Currently is only supported by Config::General, and XML::Dumper.  

  my $obj = Data::Serializer->new(serializer => 'Config::General',
                                  options    => {
                                             -LowerCaseNames       => 1,
                                             -UseApacheInclude     => 1,
                                             -MergeDuplicateBlocks => 1,
                                             -AutoTrue             => 1,
                                             -InterPolateVars      => 1
                                                },
                                              ) or die "$!\n";

  or

  my $obj = Data::Serializer->new(serializer => 'XML::Dumper',
                                  options    => { dtd => 1, }
                                  ) or die "$!\n";

=item B<store> - serialize data and write it to a file (or file handle)

  $obj->store({a => [1,2,3],b => 5},$file, [$mode, $perm]);

  or 

  $obj->store({a => [1,2,3],b => 5},$fh);


Serializes the reference specified using the B<serialize> method
and writes it out to the specified file or filehandle.  

If a file path is specified you may specify an optional mode and permission as the
next two arguments.  See L<IO::File> for examples.

Trips an exception if it is unable to write to the specified file.

=item B<retrieve> - read data from file (or file handle) and return it after deserialization 

  my $ref = $obj->retrieve($file);

  or 

  my $ref = $obj->retrieve($fh);

Reads first line of supplied file or filehandle and returns it deserialized.

=back

=head1 TRANSIENCE 

Data::Serializer is aware of Tie::Transient.  What this means is that you use
Tie::Transient as normal, and when your object is serialized, the transient 
components will be automatically removed for you.

Tie::Transient is not on CPAN, and doesn't look like it ever will be.  With
the advent of attributes from 5.8 this feature should probably be deprecated
anyway.

If you would like to use Tie::Transient you can download it directly 
from Brian's site here:  http://www.maz.org/perl/Tie-Transient-0.05.tar.gz

With perl attributes in 5.8, this should probably be deprecated.  

=head1 AUTHOR

Neil Neely <F<neil@frii.net>>.

Feature requests are certainly welcome. 

=head1 COPYRIGHT

Copyright (c) 2001-2004 Neil Neely.  All rights reserved.

This program is free software; you can redistribute it
and/or modify it under the same terms as Perl itself.

=head1 ACKNOWLEDGEMENTS 

Gurusamy Sarathy and Raphael Manfredi for writing MLDBM,
the module which inspired the creation of Data::Serializer.

And thanks to all of you who have provided the feedback 
that has improved this module over the years.

In particular I'd like to thank Florian Helmberger, for the 
numerous suggestions and bug fixes.

=head1 DEDICATION

This module is dedicated to my beautiful wife Erica, 
because a woman of such quality deserves a dedication.

=head1 SEE ALSO

=over 4

=item  L<Data::Dumper(3)>

=item  L<Data::Denter(3)>

=item L<Storable(3)>

=item L<FreezeThaw(3)>

=item L<Config::General(3)>

=item L<YAML(3)>

=item L<PHP::Serialization(3)>

=item L<XML::Dumper(3)>

=item L<Compress::Zlib(3)>

=item L<Digest(3)>

=item L<Crypt(3)>

=item L<MIME::Base64(3)>

=item L<IO::File(3)>

=item L<Tie::Transient(3)>

=back

=cut

sub _serialize {
  my $self = (shift);
  my @input = @{(shift)};#original @_
  my $method = (shift);
  $self->_module_loader($method,"Data::Serializer");	#load in serializer module if necessary
  my $serializer_obj = $self->_serializer_obj($method);
  return $serializer_obj->serialize(@input);
}
sub _compress {
  my $self = (shift);
  $self->_module_loader($self->compressor);	
  return Compress::Zlib::compress((shift));
}
sub _decompress {
  my $self = (shift);
  $self->_module_loader($self->compressor);	
  return Compress::Zlib::uncompress((shift));
}

sub _create_token {
  my $self = (shift);
  return '^' . join('|', @_) . '^';
}
sub _get_token {
  my $self = (shift);
  my $line = (shift);
  my ($token) =  $line =~ /\^([^\^]+?)\^/;
  return $token;
}
sub _extract_token {
  my $self = (shift);
  my $token = (shift);
  return split('\|',$token);
}
sub _remove_token {
  my $self = (shift);
  my $line = (shift);
  $line =~ s/\^[^\^]+?\^//;
  return $line;
}
sub _deserialize {
  my $self = (shift);
  my $input = (shift);
  my $method = (shift);
  $self->_module_loader($method,"Data::Serializer");	#load in serializer module if necessary
  my $serializer_obj = $self->_serializer_obj($method);
  $serializer_obj->deserialize($input);
}

sub _encrypt {
  my $self = (shift);
  my $value = (shift);
  my $cipher = (shift);
  my $digester = (shift);
  my $secret = $self->secret;
  croak "Cannot encrypt: No secret provided!" unless defined $secret;
  $self->_module_loader('Crypt::CBC');	
  my $digest = $self->_endigest($value,$digester);
  my $cipher_obj = Crypt::CBC->new($secret,$cipher);
  return $cipher_obj->encrypt($digest);
}
sub _decrypt {
  my $self = (shift);
  my $input = (shift);
  my $cipher = (shift);
  my $digester = (shift);
  my $secret = $self->secret;
  croak "Cannot encrypt: No secret provided!" unless defined $secret;
  $self->_module_loader('Crypt::CBC');	
  my $cipher_obj = Crypt::CBC->new($secret,$cipher);
  my $digest = $cipher_obj->decrypt($input);
  return $self->_dedigest($digest,$digester);
}
sub _endigest {
  my $self = (shift);
  my $input = (shift);
  my $digester = (shift);
  $self->_module_loader('Digest');	
  my $digest = $self->_get_digest($input,$digester);
  return "$digest=$input";
}
sub _dedigest {
  my $self = (shift);
  my $input = (shift);
  my $digester = (shift);
  $self->_module_loader('Digest');	
  my ($old_digest) = $input =~ /^([^=]+?)=/;
  return undef unless (defined $old_digest);
  $input =~ s/^$old_digest=//;
  my $new_digest = $self->_get_digest($input,$digester);
  return undef unless ($new_digest eq $old_digest);
  return $input;
}
sub _get_digest {
  my $self = (shift);
  my $input = (shift);
  my $digester = (shift);
  my $ctx = Digest->$digester();
  $ctx->add($input);
  return $ctx->hexdigest;
}
sub _enhex {
  my $self = (shift);
  return join('',unpack 'H*',(shift));
}
sub _dehex {
  my $self = (shift);
  return (pack'H*',(shift));
}

sub _enb64 {
  my $self = (shift);
  $self->_module_loader('MIME::Base64');	
  my $b64 = MIME::Base64::encode_base64( (shift), '' );
  return $b64;
}


sub _deb64 {
  my $self = (shift);
  $self->_module_loader('MIME::Base64');	
  return MIME::Base64::decode_base64( (shift) );
}

# do all 3 stages
sub freeze { (shift)->serialize(@_); }
sub thaw { (shift)->deserialize(@_); }

sub serialize {
  my $self = (shift);
  my ($serializer,$cipher,$digester,$encoding,$compressor) = ('','','','','');

  #we always serialize no matter what.

  #define serializer for token
  $serializer = $self->serializer;
  &Tie::Transient::hide_transients() if ($self->transient());
  my $value = $self->_serialize(\@_,$serializer);
  &Tie::Transient::show_transients() if ($self->transient());

  if ($self->compress) {
    $compressor = $self->compressor;
    $value = $self->_compress($value);
  }

  if (defined $self->secret) {
    #define digester for token
    $digester = $self->digester;
    #define cipher for token
    $cipher = $self->cipher;
    $value = $self->_encrypt($value,$cipher,$digester);
  }
  if ($self->portable) {
    $encoding = $self->encoding;
    $value = $self->_encode($value);
  }
  my $token = $self->_create_token($serializer,$cipher, $digester,$encoding,$compressor);
  if ($self->serializer_token) {
    $value = $token . $value;
  }
  return $value;
}

sub store {
  my $self = (shift);
  my $data = (shift);
  my $file_or_fh = (shift);

  if (ref($file_or_fh)) {
    #it is a file handle so print straight to it
    print $file_or_fh $self->serialize($data), "\n";
    #We didn't open the filehandle, so we shouldn't close it.
  } else {
    #it is a file, so open it
    my ($mode,$perm) = @_;
    unless (defined $mode) {
      $mode = O_CREAT|O_WRONLY;
    }
    unless (defined $perm) {
      $perm = 0600;
    }
    my $fh = new IO::File $file_or_fh, $mode,$perm || croak "Cannot write to $file_or_fh: $!";
    print $fh $self->serialize($data), "\n";
    $fh->close();
  }
}

sub retrieve {
  my $self = (shift);
  my $file_or_fh = (shift);
  if (ref($file_or_fh)) {
    #it is a file handle so read straight from it
    my $input = <$file_or_fh>;
    chomp($input);
    return $self->deserialize($input);
    #We didn't open the filehandle, so we shouldn't close it.
  } else {
    my $fh = new IO::File; 
    $fh->open($file_or_fh, O_RDONLY) ||  croak "Cannot read from $file_or_fh: $!";
    my $input = <$fh>;
    chomp($input);
    $fh->close;
    return $self->deserialize($input);
  }
}

sub raw_serialize {
  my $self = (shift);
  my $serializer = $self->serializer;
  return $self->_serialize(\@_,$serializer);
  return $value;
}

sub _encode {
  my $self = (shift);
  my $value = (shift);
  $encoding = $self->encoding;
  if ($encoding eq 'hex') {
    return $self->_enhex($value);
  } elsif ($encoding eq 'b64') {
    return $self->_enb64($value);
  } else {
    croak "Unknown encoding method $encoding\n";
  }
}

sub _decode {
  my $self = (shift);
  my $value = (shift);
  my $encoding = (shift);
  if ($encoding eq 'hex') {
    return $self->_dehex($value);
  } elsif ($encoding eq 'b64') {
    return $self->_deb64($value);
  } elsif ($encoding !~ /\S/) {
    #quietly ignore empty encoding
    return $value;
  } else {
    croak "Unknown encoding method $encoding\n";
  }
}

sub raw_deserialize {
  my $self = (shift);
  my $serializer = $self->serializer;
  return $self->_deserialize((shift),$serializer);
}

sub deserialize {
  my $self = (shift);
  my $value = (shift);
  my $token = $self->_get_token($value);
  my ($serializer,$cipher, $digester,$encoding, $compressor); 
  if (defined $token) {
    ($serializer,$cipher, $digester,$encoding, $compressor) = $self->_extract_token($token); 
    $value = $self->_remove_token($value);
  } else {
    $serializer = $self->serializer;
    $cipher = $self->cipher;
    $digester = $self->digester;
    $compressor = $self->compressor;
    if (defined $self->portable) {
      $encoding = $self->encoding;
    }
  }
  if (defined $encoding) {
    $value = $self->_decode($value,$encoding);
  } 
  if (defined $self->secret) {
    $value = $self->_decrypt($value,$cipher,$digester);
  }
  if (defined $compressor) {
    $value = $self->_decompress($value);
  }
  #we always deserialize no matter what.
  &Tie::Transient::show_transients() if ($self->transient());
  my @return = $self->_deserialize($value,$serializer);
  &Tie::Transient::hide_transients() if ($self->transient());
  return wantarray ? @return : $return[0];
}

