package Data::Serializer::Data::Denter;
BEGIN { @Data::Serializer::Data::Denter::ISA = qw(Data::Serializer) }


use strict;

use Carp;
use Data::Denter;

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

Data::Serializer::Data::Denter - Creates bridge between Data::Serializer and Data::Denter

=head1 SYNOPSIS

  use Data::Serializer::Data::Denter;

=head1 DESCRIPTION

Module is used internally to Data::Serializer 

=head1 AUTHOR

Neil Neely <neil@neely.cx>

=head1 COPYRIGHT

  Copyright 2002 by Neil Neely.  All rights reserved.
  This program is free software; you can redistribute it
  and/or modify it under the same terms as Perl itself.

=head1 SEE ALSO

perl(1), Data::Serializer(3), Data::Denter(3).

=cut

#
# Create a Data::Denter serializer object.
#

sub serialize {
  my $self = shift;
  my ($val) = @_;
  return undef unless defined $val;
  return $val unless ref($val);
  return Data::Denter::Indent($val);
}


sub deserialize {
  my $self = shift;
  my ($val) = @_;
  return undef unless defined $val;
  return Data::Denter::Undent($val);
}

