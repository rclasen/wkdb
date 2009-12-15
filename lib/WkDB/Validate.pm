package WkDB::Validate;
use warnings;
use strict;
use base 'MyValidate';

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

1;
