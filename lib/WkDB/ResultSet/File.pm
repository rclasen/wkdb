package WkDB::ResultSet::File;
use warnings;
use strict;
use base 'DBIx::Class::ResultSet';

sub search_overlapping_files {
	my( $self, $where ) = @_;

	my $rs = $self->search( $where, {
		order_by	=> [qw/ start /],
	} );

	my @result;

	my( $r1, $r2 );
	my $overlapping = [];

	while( defined( my $f = $rs->next)){
		my( $f1, $f2 ) = ( $f->start, $f->end );

		# overlapping with last?
		if( !defined( $r1 ) || !defined($r2) 
			|| ! ( ($r2 < $f1) || ($f2 < $r1) ) ){

			if( !defined($r1) || $f1 < $r1 ){
				$r1 = $f1;
			}

			if( !defined($r2) || $f2 > $r2 ){
				$r2 = $f2;
			}

		# ... no, not overlapping, start new
		} else {
			push @result, $overlapping;
			$overlapping = [];
			($r1, $r2) = ( $f1, $f2 );

		}

		push @$overlapping, $f;
	}
	push @result, $overlapping if @$overlapping;

	return \@result;
}



1;
