package Jaufs;

=pod

Jet Another User Friendly Serialisation

dump list of hashes to textfile.
read list of hashes from textfile.

=cut

use strict;
use warnings;
use DateTime;
use MyValidate;

sub new {
	my( $proto, $a ) = @_;

	$a ||= {};
	bless {
		order	=> [],
		fields	=> {},
		width	=> 15,
		validator	=> undef,
		%$a,
	}, ref $proto || $proto;
}

sub write {
	my( $self, $src, $list ) = @_;

	my( $fh, $close );
	if( ref $src ){
		$fh = $src;
	} else {
		open( $fh, '>', $src )
			or return;
		++$close;
	}


	my $w = $self->{width};
	foreach my $ent ( @$list ){
		foreach my $field ( @{$self->{order}} ){
			my $param = $self->{fields}{$field};

			my $val;
			if( ! defined $ent->{$field} ){
				$val = '';

			} elsif( $param->{encode} ){
				$val = $param->{encode}( $ent->{$field} )

			} else {
				$val = $ent->{$field};
			}

			if( $param->{multiline} ){
				print $fh $field,":--\n",
					$val ||'', "\n",
					"--:", $field, "\n";
			} else {
				printf $fh "%-${w}s%s\n",
					$field.':',
					$val||'';
			}
		}
		print $fh "\n";
	}

	$self->write_footer( $fh );

	if( $close ){
		close( $fh ) or return;
	}

	1;
}

sub write_header {
	my( $self, $fh ) = @_;
	# for overloading
}

sub write_footer {
	my( $self, $fh ) = @_;
	# for overloading
}

sub setfield {
	my( $self, $ent, $field, $val ) = @_;

	my $param = $self->{fields}{$field};
	$val =~ s/^\s+//s;
	$val =~ s/\s+$//ms;

	if( $val eq '' ) {
		$ent->{$field} = undef;

	} elsif( $param->{decode} ){
		$ent->{$field} = $param->{decode}( $val );
		if( ! defined $ent->{$field} ){
			print STDERR "line $.: failed to decode $field\n";
			return;
		}
		#print $field, " decoded as ", $ent->{$field},"\n";

	} else {
		$ent->{$field} = $val;

	}

	1;
}

sub finish {
	my( $self, $ent ) = @_;

	# TODO: translate errors to something human friendly
	if( $self->{validator} ){
		my $res = $self->{validator}->check( $ent );
		return 1 unless $res->has_error;

		foreach my $f ( @{$res->error} ){
			my $msgf = $f ? "field $f"
				: "cross validation";
			print STDERR "line $.: invalid data for $msgf: ",
				join(" ", @{$res->error($f)}), "\n";
		}

		return;
	}

	1;
}

sub read {
	my( $self, $src ) = @_;

	my( $fh, $close );
	if( ref $src ){
		$fh = $src;
	} else {
		open( $fh, '<', $src )
			or return;
		++$close;
	}

	my @list;

	my $field;
	my $val;
	my $ent;

	my $err;

	while( defined( my $line = <$fh> ) ){
		if( $field && ($line =~ /^--:.*/) ){
			$self->setfield( $ent, $field, $val )
				or $err++;
			$field = undef;
			$val = undef;

		} elsif( $field ){
			$val .= $line;

		} elsif( $line =~ /^\s*#/ ){
			# comment, do nothing

		} elsif( my( $f, $v ) = $line =~ /^\s*(\w+)\s*:\s*(.*)\s*$/ ){
			if( ! exists $self->{fields}{lc $f} ){
				print STDERR "line $.: unknown field: $f\n";
				$err++;
			}
			my $param = $self->{fields}{lc $f};

			$ent ||= {};

			if( $param->{multiline} ){
				$field = lc $f;
				$val = '';

			} else {
				$self->setfield( $ent, lc $f, $v )
					or $err++;
			}

		} elsif( $ent && $line =~ /^\s*$/ ){
			$self->finish( $ent )
				or $err++;

			push @list, $ent if $ent;
			$ent = undef;
		}
	}

	if( $field ){
		$self->setfield( $ent, $field, $val )
			or $err++;
	}

	if( $ent ){
		$self->finish( $ent )
			or $err++;

		push @list, $ent;
	}

	return if $err;

	close( $fh ) if $close;
	return \@list;
}

sub decode_action {
	$_[0] =~ /^\s*(skip|delete|save)\s*$/i
		or return;

	return lc $1;
}

sub encode_date { $_[0]->ymd };
sub decode_date {
	$_[0] =~ /^\s*(\d+)-(\d+)-(\d+)\s*$/
		or return;

	DateTime->new(
		year	=> $1,
		month	=> $2,
		day	=> $3,
		time_zone	=> 'local',
	);
}

sub encode_hours {
	my $m = int($_[0] / 60);
	my $h = int($m / 60); $m %= 60;
	sprintf('%d:%02d', $h, $m );
}

sub decode_hours {
	$_[0] =~ /^(\d+)(?::(\d\d))?$/
		or return;

	$1 * 3600 + ($2 || 0) * 60;
}

sub decode_int {
	$_[0] =~ /^([+-]?\d+)$/
		or return;
	$1;
}

sub decode_uint {
	$_[0] =~ /^(\d+)$/
		or return;
	$1;
}

sub decode_float {
	$_[0] =~ /^([+-]?\d+(?:\.\d+)?)$/
		or return;
	$1;
}

1;
