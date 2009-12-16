package WkDB::Jaufs;
use strict;
use warnings;
use base 'Jaufs';
use Carp;

sub new {
	my( $proto, $a ) = @_;

	my $self = $proto->SUPER::new($a)
		or return;

	$self->{wk}->isa('WkDB')  or croak "missing WkDB handle";
	$self;
}

sub wk { $_[0]->{wk} };

sub encode_athlete {
	$_[1]->id .": ". $_[1]->name;
}

sub decode_athlete {
	my( $self, $val ) = @_;

	my @q;
	if( $val =~ /^(\d+)(?::\s*\w+)?$/ ){
		@q = ( id => $1 );
	} else {
		@q = ( name => $val );
	}

	my $a = $self->wk->db->resultset('Athlete')->search({
		@q,
	})->first or return ( undef, 'NOTKNOWN' );

	$a;
}

1;
