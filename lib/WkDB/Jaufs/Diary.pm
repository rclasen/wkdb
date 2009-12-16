package WkDB::Jaufs::Diary;
use strict;
use warnings;
use DateTime;
use base 'WkDB::Jaufs';
use WkDB::Validate::Diary;

our %fields = (
	athlete => {
		encode	=> \&WkDB::Jaufs::encode_athlete,
		decode	=> \&WkDB::Jaufs::decode_athlete,
	},
	day => {
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
		encode	=> sub { sprintf('%.1f',$_[1]) },
		decode	=> \&Jaufs::decode_float,
	},
	weight => {
		encode	=> sub { sprintf('%.1f',$_[1]) },
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
	athlete
	day
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
	my( $class, $a ) = @_;

	my $valid = WkDB::Validate::Diary->new({
		wk => $a->{wk},
		profile => {
			action	=> [
				\&MyValidate::NON_BLANK,
			],
		},
	});

	$class->SUPER::new({
		$a ? %$a : (),
		order	=> \@order,
		fields	=> \%fields,
		width	=> $width,
		validator	=> $valid,
	});
}

1;
