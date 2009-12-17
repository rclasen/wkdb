package MyValidate;
use strict;
use warnings;

# TODO: pod

=pod

validata $data hash against $profile

 my $result = MyValidate->check( {
 	email	=> 'foo@example.org',
	surname	=> 'John Doe',
 }, {
 	email	=> [ \&MyValidate::EMAIL ],

	surname	=> [ sub {
		return if $_[1] =~ /^\w+$/;
		return 'SURNAME';
	}, ],

	# cross validate fields:
	''	=> [ sub {
		my( $res, $data ) = @_;
		return if defined $data->{email} 
			|| defined $data->{name};
		return 'ANY';
	}, ],
 });

check Multiple data sets:

 my $validator = MyValidate->new({
 	profile => $profile,
 });
 my $result1 = $validator->check( $data1 );
 my $result2 = $validator->check( $data2 );

tries to be compatible with FormValidator::Simple::Result

=cut

# TODO: split result into seperate ::Result package

sub new {
	my( $proto, $a ) = @_;
	my $self = bless {
		profile	=> {},
		ref $proto ? %$proto : (), # allow cloning
		$a ? %$a : (),
		errors	=> {},
		data => {},
	}, ref $proto || $proto;
}

sub check {
	my( $proto, $data, $a ) = @_;

	my $self = $proto->new( $a );
	my $profile = $self->{profile};
	$self->{data} = $data;

	foreach my $f ( keys %$profile ){
		next if $f eq '';

		my $v = exists $data->{$f} ? $data->{$f} : undef;
		$self->_check_field( $profile, $f, $v );
	}

	# cross_validate when individual fields were ok:
	if( ! %{$self->{errors}} && exists $profile->{''} ){
		$self->_check_field( $profile, '', $data );
	}

	$self;
}

sub _check_field {
	my( $self, $profile, $field, $data ) = @_;

	foreach my $check ( @{$profile->{$field}} ){
		my @err = &$check( $self, $data );
		push @{$self->{errors}{$field}}, @err if @err;
	}
}

sub invalid {
	return [ keys %{$_[0]->{errors}} ] if @_ == 1;

	return unless exists $_[0]->{errors}{$_[1]};
	$_[0]->{errors}{$_[1]};
}

sub missing {
	my $self = shift;

	if( @_ ){
		return unless exists $self->{errors}{$_[1]};
		return grep { $_ eq 'NON_BLANK' } @{ $self->{errors}{$_[1]}};
	} else {
		my @fields;
		foreach my $f ( keys %{$self->{errors}} ){
			foreach my $e ( @{ $self->{errors}{$f}} ){
				next unless $f eq 'NON_BLANK';
				push @fields, $f;
				last;
			}
		}
		return \@fields;
	}
}

sub error { shift->invalid( @_ ) }

sub valid {
	my( $self, $field ) = @_;
	if( @_ ){
		return unless exists $self->{profile}{$field};
		return undef unless exists $self->{data}{$field};
		return $self->{data}{$field};
	} else {
		my @fields;
		foreach my $f ( keys %{$self->{profile}} ){
			next if $self->{errors}{$f};
			push @fields, $f;
		}
		return \@fields;
	}
}

sub has_invalid { scalar %{$_[0]->{errors}} }
sub has_missing { scalar @{$_[0]->missing} };
sub has_error { shift->has_invalid( @_ ) }
sub success { ! shift->has_error( @_ ) }

sub NON_BLANK {
	return if $_[1];
	return 'NON_BLANK';
}

sub EMAIL {
	return unless defined $_[1];
	return if $_[1] =~ /^[\w.]+@\w[\w.]*\w$/;
	return 'EMAIL';
}

sub PERCENT_ABS {
	return unless defined $_[1];
	return 'MAX' if $_[1] > 45;
	return 'MIN' if $_[1] < 0;
	return;
}


1;
