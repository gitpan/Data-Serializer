package Data::Serializer::YAML;
BEGIN { @Data::Serializer::YAML::ISA = qw(Data::Serializer) }


use strict;
use YAML;
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

Data::Serializer::YAML - Creates bridge between Data::Serializer and YAML

=head1 SYNOPSIS

  use Data::Serializer::YAML;

=head1 DESCRIPTION

Module is used internally to Data::Serializer

=head1 AUTHOR

Florian Helmberger <fh@laudatio.com>

=head1 COPYRIGHT

  Copyright 2002 by Florian Helmberger.  All rights reserved.
  This program is free software; you can redistribute it
  and/or modify it under the same terms as Perl itself.

=head1 SEE ALSO

perl(1), Data::Serializer(3), YAML(3).

=cut

sub serialize {
    return Dump($_[1]);
}

sub deserialize {
    return Load($_[1]);
}
