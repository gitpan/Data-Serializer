package Data::Serializer::Storable;
BEGIN { @Data::Serializer::Storable::ISA = qw(Data::Serializer) }


use strict;
use Storable;
use vars qw($VERSION @ISA @EXPORT @EXPORT_OK);

require Exporter;
require AutoLoader;

@ISA = qw(Exporter AutoLoader);
# Items to export into callers namespace by default. Note: do not export
# names by default without a very good reason. Use EXPORT_OK instead.
# Do not simply export all your public functions/methods/constants.
@EXPORT = qw(
	
);
$VERSION = '0.01';


# Preloaded methods go here.

# Autoload methods go after =cut, and are processed by the autosplit program.

1;
__END__
# Below is the stub of documentation for your module. You better edit it!

=head1 NAME

Data::Serializer::Storable - Creates bridge between Data::Serializer and Storable

=head1 SYNOPSIS

  use Data::Serializer::Storable;

=head1 DESCRIPTION

Module is used internally to Data::Serializer

=head1 AUTHOR

Neil Neely <neil@frii.net>

=head1 COPYRIGHT

  Copyright 2001 by Neil Neely.  All rights reserved.
  This program is free software; you can redistribute it
  and/or modify it under the same terms as Perl itself.

=head1 SEE ALSO

perl(1), Data::Serializer(3), Data::Dumper(3).

=cut
#
# Serialize a reference to supplied value
#
sub serialize {
    my $ret = Storable::freeze($_[1]);            # Does not care whether portable
    defined($ret) ? $ret : undef;
}

#
# Deserialize and de-reference
#
sub deserialize {
    my $ret = Storable::thaw($_[1]);            # Does not care whether portable
    defined($ret) ? $ret : undef;
}

#
# Change dump method when portability is requested
#
sub DumpMeth {
    my $self = shift;
    $self->{'_dumpsub_'} = 
      ($_[0] && $_[0] eq 'portable' ? \&Storable::nfreeze : \&Storable::freeze);
    $self->_attrib('dumpmeth', @_);
}

