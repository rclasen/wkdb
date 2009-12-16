package WkDB::Validate::Diary;
use strict;
use warnings;
use base 'WkDB::Validate';

our %profile = (
	athlete => [
		\&MyValidate::NON_BLANK,
		\&WkDB::Validate::ATHLETE,
	],
	day	=> [
		\&MyValidate::NON_BLANK,
	],
	hr	=> [
		\&WkDB::Validate::HEARTRATE,
	],
	temperature	=> [
		\&WkDB::Validate::BODYTEMP,
	],
	weight	=> [
		\&WkDB::Validate::BODYWEIGHT,
	],
	bodyfat	=> [
		\&MyValidate::PERCENT_ABS,
	],
);

sub new {
	my( $proto, $a ) = @_;

	$proto->SUPER::new({
		$a ? %$a : (),
		profile => {
			%profile,
			$a->{profile} ? %{$a->{profile}} : (),
		},
	});
}

1;
