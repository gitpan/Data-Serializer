package Data::Serializer::Raw;

use warnings;
use strict;
use vars qw($VERSION);
use Carp;

$VERSION = '0.01';

#Global cache of modules we've loaded
my %_MODULES;

my %_fields = (
                serializer => 'Data::Dumper',
                options    => {},
              );
sub new {
        my ($class, %args) = @_;
        my $dataref = {%_fields};
        foreach my $field (keys %_fields) {
                $dataref->{$field} = $args{$field} if exists $args{$field};
        }
        my $self = $dataref;
        bless $self, $class;

	#initialize serializer
	$self->_serializer_obj();

        return $self;
}

sub serializer {
        my $self = (shift);
        my $return = $self->{serializer};
        if (@_) {
                $self->{serializer} = (shift);
		#reinitialize serializer object
		$self->_serializer_obj(1);
        }
        return $return;
}

sub options {
        my $self = (shift);
        my $return = $self->{options};
        if (@_) {
                $self->{options} = (shift);
		#reinitialize serializer object
		$self->_serializer_obj(1);
        }
        return $return;
}

sub _module_loader {
        my $self = (shift);
        my $module_name = (shift);
        return if (exists $_MODULES{$module_name});
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
        $_MODULES{$module_name} = 1;
}

sub _serializer_obj {
        my $self = (shift);
	#if anything is passed in remove previous obj so we will regenerate it
	if (@_) {
		delete $self->{serializer_obj};
	}
	#Return cached serializer object if it exists
	return $self->{serializer_obj} if (exists $self->{serializer_obj});

	my $method = $self->{serializer};
	$self->_module_loader($method,"Data::Serializer");    #load in serializer module if necessary

  	$self->{serializer_obj}->{options} = $self->{options};
	bless $self->{serializer_obj}, "Data::Serializer::$method";
}

sub serialize {
  my $self = (shift);
  my @input = @_;

  return $self->_serializer_obj->serialize(@input);
}


sub deserialize {
  my $self = (shift);
  my $input = (shift);

  return $self->_serializer_obj->deserialize($input);
}

1;
__END__

=pod

=head1 NAME
                
Data::Serializer::Raw - Provides unified raw interface to perl serializers
                
=head1 SYNOPSIS
                
  use Data::Serializer::Raw;
                
  $obj = Data::Serializer::Raw->new();
                
  $obj = Data::Serializer::Raw->new(serializer => 'Storable');

  $serialized = $obj->serialize({a => [1,2,3],b => 5});
  $deserialized = $obj->deserialize($serialized);

  print "$deserialized->{b}\n";

=head1 DESCRIPTION

Provides a unified interface to the various serializing modules
currently available.  

This is a straight pass through to the underlying serializer,
nothing else is done. (no encoding, encryption, compression, etc)
    
=head1 EXAMPLES

=over 4

=item  Please see L<Data::Serializer::Cookbook(3)>

=back

=head1 METHODS

=over 4

=item B<new> - constructor

  $obj = Data::Serializer::Raw->new();


  $obj = Data::Serializer::Raw->new(
                         serializer => 'Data::Dumper',
                           options  => {},
                        );


B<new> is the constructor object for Data::Serializer::Raw objects.

=over 4

=item

The default I<serializer> is C<Data::Dumper>

=item

The default I<options> is C<{}> (pass nothing on to serializer)

=back

=item B<serialize> - serialize reference
        
  $serialized = $obj->serialize({a => [1,2,3],b => 5});
                
This is a straight pass through to the underlying serializer,
nothing else is done. (no encoding, encryption, compression, etc)

=item B<deserialize> - deserialize reference

  $deserialized = $obj->deserialize($serialized);
        
This is a straight pass through to the underlying serializer,
nothing else is done. (no encoding, encryption, compression, etc)


=item B<options> - pass options through to underlying serializer

Currently is only supported by Config::General, and XML::Dumper.

  my $obj = Data::Serializer::Raw->new(serializer => 'Config::General',
                                  options    => {
                                             -LowerCaseNames       => 1,
                                             -UseApacheInclude     => 1,
                                             -MergeDuplicateBlocks => 1,
                                             -AutoTrue             => 1,
                                             -InterPolateVars      => 1
                                                },
                                              ) or die "$!\n";

  or

  my $obj = Data::Serializer::Raw->new(serializer => 'XML::Dumper',
                                  options    => { dtd => 1, }
                                  ) or die "$!\n";

=back

=head1 AUTHOR

Neil Neely <F<neil@neely.cx>>.

http://neil-neely.blogspot.com/

=head1 BUGS

Please report all bugs here:

http://rt.cpan.org/Public/Dist/Display.html?Name=Data-Serializer


=head1 COPYRIGHT AND LICENSE

Copyright (c) 2011 Neil Neely.  All rights reserved.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.8.2 or,
at your option, any later version of Perl 5 you may have available.


See http://www.perl.com/language/misc/Artistic.html

=head1 ACKNOWLEDGEMENTS

Peter Makholm took the time to profile Data::Serializer(3) and pointed out the value
of having a very lean implementation that minimized overhead and just used the raw underlying serializers.

=head1 SEE ALSO

perl(1), Data::Serializer(3).

=cut

