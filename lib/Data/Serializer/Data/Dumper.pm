package Data::Serializer::Data::Dumper;
BEGIN { @Data::Serializer::Data::Dumper::ISA = qw(Data::Serializer) }


use strict;
use Carp;
use Data::Dumper '2.08';                # Backward compatibility

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

Data::Serializer::Data::Dumper - Creates bridge between Data::Serializer and Data::Dumper

=head1 SYNOPSIS

  use Data::Serializer::Data::Dumper;

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
# Create a Data::Dumper serializer object.
#

#
# Serialize $val if it is a reference, or if it does begin with our magic
# key string, since then at retrieval time we expect a Data::Dumper string.
# Otherwise, return the scalar value.
#
sub serialize {
    my $self = shift;
    my ($val) = @_;
    return undef unless defined $val;
    return $val unless ref($val);
    local $Data::Dumper::Indent = 0;
    local $Data::Dumper::Purity = 1;
    local $Data::Dumper::Terse = 1;
    return Data::Dumper::Dumper($val);
}


#
# If the value is undefined or does not begin with our magic key string,
# return it as-is. Otherwise, we need to recover the underlying data structure.
#
sub deserialize {
    my $self = shift;
    my ($val) = @_;
    return undef unless defined $val;
    my $M = "";
#    ($val) = $val =~ /^(.*)$/s if $self->{'removetaint'};
    # Disambiguate hashref (perl may treat it as a block)
    my $N = eval($val =~ /^\{/ ? '+'.$val : $val);
    return $M ? $M : $N unless $@;
    carp "Data::Serializer error: $@\twhile evaluating:\n $val";
}

# avoid used only once warnings
{
    local $Data::Dumper::Terse;
}
