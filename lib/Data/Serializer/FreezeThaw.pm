package Data::Serializer::FreezeThaw;
BEGIN { @Data::Serializer::FreezeThaw::ISA = qw(Data::Serializer) }


use strict;
use FreezeThaw;
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

Data::Serializer::FreezeThaw - Creates bridge between Data::Serializer and FreezeThaw

=head1 SYNOPSIS

  use Data::Serializer::FreezeThaw;

=head1 DESCRIPTION

Module is used internally to Data::Serializer

=head1 AUTHOR

Neil Neely <neil@neely.cx>

=head1 COPYRIGHT

  Copyright 2001 by Neil Neely.  All rights reserved.
  This program is free software; you can redistribute it
  and/or modify it under the same terms as Perl itself.

=head1 SEE ALSO

perl(1), Data::Serializer(3), FreezeThaw(3).

=cut

sub serialize {
    return FreezeThaw::freeze($_[1]);
}

sub deserialize {
    my ($obj) = FreezeThaw::thaw($_[1]);
    return $obj;
}
