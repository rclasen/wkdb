package WkDB::Schema;
use strict;
use warnings;
use base 'DBIx::Class::Schema';
use Carp;

our $VERSION = '0.01';

__PACKAGE__->load_classes();

#sub sqlt_deploy_hook {
#	my( $self, $sqlt ) = @_;
#}

# TODO: version DB schema
#__PACKAGE__->load_components(qw/
#	+DBIx::Class::Schema::Versioned
#/);

sub update {
	croak "update not supported";
}

sub backup {
	croak "backup not supported";
}


1;
