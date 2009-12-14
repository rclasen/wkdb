package WkDB::Base;
use strict;
use warnings;
use base 'DBIx::Class';

sub my_init {
	my( $self ) = shift;

	$self->load_components(qw/
		TimeStamp
		InflateColumn::DateTime
		PK::Auto
		Core
	/);
}

1;
