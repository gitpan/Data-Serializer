package Data::Serializer::XML::Simple;
BEGIN { @Data::Serializer::XML::Simple::ISA = qw(Data::Serializer) }


use strict;
use XML::Simple qw(); 
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

Data::Serializer::XML::Simple - Creates bridge between Data::Serializer and XML::Simple

=head1 SYNOPSIS

  use Data::Serializer::XML::Simple;

=head1 DESCRIPTION

Module is used internally to Data::Serializer

The only option currently supported is B<dtd>.  This just calls the dtd method of XML::Simple
prior to serializing the data.   See XML::Simple(3) for details.

=head1 AUTHOR
 
Neil Neely <neil@frii.net>
    
=head1 COPYRIGHT
 
  Copyright 2004 by Neil Neely.  All rights reserved.
  This program is free software; you can redistribute it
  and/or modify it under the same terms as Perl itself.
  
=head1 SEE ALSO

perl(1), Data::Serializer(3), XML::Simple(3).

=cut

sub serialize {
    my $self = (shift);
    my $xml = XML::Simple->new(keyattr => [ 'name']);
    return $xml->XMLout( (shift) );
}

sub deserialize {
    my $xml = XML::Simple->new(keyattr => [ 'name']);
    return $xml->XMLin($_[1]);
}

