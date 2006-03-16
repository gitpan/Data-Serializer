package Data::Serializer::JSON::Syck;
BEGIN { @Data::Serializer::JSON::Syck::ISA = qw(Data::Serializer) }

use strict;
use JSON::Syck;
use vars qw($VERSION @ISA @EXPORT @EXPORT_OK);

require Exporter;
require AutoLoader;

@ISA = qw(Exporter AutoLoader);
@EXPORT = qw(
	
);
$VERSION = '0.01';

1;
__END__

=head1 NAME

Data::Serializer::JSON::Syck - Creates bridge between Data::Serializer and JSON::Syck

=head1 SYNOPSIS

  use Data::Serializer::JSON::Syck;

=head1 DESCRIPTION

Module is used internally to Data::Serializer

=head1 AUTHOR

Naoya Ito <naoya@bloghackers.net>

=head1 COPYRIGHT

  This program is free software; you can redistribute it
  and/or modify it under the same terms as Perl itself.

=head1 SEE ALSO

perl(1), Data::Serializer(3), JSON::Syck(3).

=cut

sub serialize {
    return JSON::Syck::Dump($_[1]);
}

sub deserialize {
    return JSON::Syck::Load($_[1]);
}
