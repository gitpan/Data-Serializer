package Data::Serializer::YAML::Syck;
BEGIN { @Data::Serializer::YAML::Syck::ISA = qw(Data::Serializer) }

use strict;
use YAML::Syck;
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

Data::Serializer::YAML::Syck - Creates bridge between Data::Serializer and YAML::Syck

=head1 SYNOPSIS

  use Data::Serializer::YAML::Syck;

=head1 DESCRIPTION

Module is used internally to Data::Serializer

=head1 AUTHOR

Naoya Ito <naoya@bloghackers.net>

=head1 COPYRIGHT

  This program is free software; you can redistribute it
  and/or modify it under the same terms as Perl itself.

=head1 SEE ALSO

perl(1), Data::Serializer(3), YAML::Syck(3).

=cut

sub serialize {
    return YAML::Syck::Dump($_[1]);
}

sub deserialize {
    return YAML::Syck::Load($_[1]);
}
