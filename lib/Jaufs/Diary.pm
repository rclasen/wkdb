package Jaufs::Diary;
use strict;
use warnings;
use DateTime;
use base 'Jaufs';
use WkDB::Validate::Diary;

our %fields = (
	date => {
		encode	=> \&Jaufs::encode_date,
		decode	=> \&Jaufs::decode_date,
	},
	sleep => {
		encode	=> \&Jaufs::encode_hours,
		decode	=> \&Jaufs::decode_hours,
	},
	hr => {
		decode	=> \&Jaufs::decode_uint,
	},
	temperature => {
		encode	=> sub { sprintf('%.1f',$_[0]) },
		decode	=> \&Jaufs::decode_float,
	},
	weight => {
		encode	=> sub { sprintf('%.1f',$_[0]) },
		decode	=> \&Jaufs::decode_float,
	},
	bodyfat => {
		decode	=> \&Jaufs::decode_uint,
	},
	notes => {
		multiline	=> 1,
	},
	action => {
		decode	=> \&Jaufs::decode_action,
	},
);

our @order = qw(
	date
	sleep
	hr
	temperature
	weight
	bodyfat
	notes
	action
);

our $width = 13;

sub new {
	my( $class ) = @_;

	$class->SUPER::new({
		order	=> \@order,
		fields	=> \%fields,
		width	=> $width,
		validator	=> WkDB::Validate::Diary->new( {
			action	=> [
				\&MyValidate::NON_BLANK,
			],
		}),
	});
}

1;