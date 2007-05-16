package Data::Serializer::Data::Taxi;
BEGIN { @Data::Serializer::Data::Taxi::ISA = qw(Data::Serializer) }


use strict;
use Data::Taxi;
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

Data::Serializer::Data::Taxi - Creates bridge between Data::Serializer and Data::Taxi

=head1 SYNOPSIS

  use Data::Serializer::Data::Taxi;

=head1 DESCRIPTION

Module is used internally to Data::Serializer

=head1 AUTHOR

Neil Neely <neil@neely.cx>

=head1 COPYRIGHT

  Copyright 2001 by Neil Neely.  All rights reserved.
  This program is free software; you can redistribute it
  and/or modify it under the same terms as Perl itself.

=head1 SEE ALSO

perl(1), Data::Serializer(3), Data::Taxi(3).

=cut

sub serialize {
    return Data::Taxi::freeze($_[1]);
}

sub deserialize {
    my ($obj) = Data::Taxi::thaw($_[1]);
    return $obj;
}
