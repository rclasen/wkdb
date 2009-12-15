package WkDB::Validate;
use warnings;
use strict;
use base 'MyValidate';
use Carp;

sub new {
	my( $proto, $a ) = @_;

	my $self = $proto->SUPER::new($a)
		or return;

	$self->{wk}->isa('WkDB')  or croak "missing WkDB handle";
	$self;
}

sub wk { $_[0]->{wk} }

sub HEARTRATE {
	return unless defined $_[1];
	return 'MAX' if $_[1] >= 300;
	return 'MIN' if $_[1] <= 0;
	return;
}

sub BODYTEMP {
	return unless defined $_[1];
	return 'MAX' if $_[1] >= 45;
	return 'MIN' if $_[1] <= 30;
	return;
}

sub BODYWEIGHT {
	return unless defined $_[1];
	return 'MAX' if $_[1] >= 500;
	return 'MIN' if $_[1] <= 0;
	return;
}

sub ATHLETE {
	my( $self, $id ) = @_;
	return unless defined $id;
	return if $self->wk->db->resultset('Athlete')->find($id);
	return 'NOTKNOWN';
}

1;
