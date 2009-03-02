package WkDB::Schema::File;
use warnings;
use strict;
use base 'WkDB::Base';
use WkDB::ResultSet::File;

# - Metadata cache for workout files for faster access (start, duration)
# - keep track of files already processed as workout

__PACKAGE__->my_init;
__PACKAGE__->table('file');
__PACKAGE__->resultset_class('WkDB::ResultSet::File');
__PACKAGE__->add_columns(
	id	=> {
		data_type		=> 'integer',
		is_nullable		=> 0,
		is_auto_increment	=> 1,
		default_value		=> '',

	},
	pool	=> { # pool.id
		data_type		=> 'integer',
		is_nullable		=> 0,
		default_value		=> '',
	},
	path	=> { # relative path within pool
		data_type		=> 'varchar',
		is_nullable		=> 0,
		default_value		=> '',
	},
	mtime	=> { # file modification time
		data_type		=> 'datetime',
		is_nullable		=> 0,
		default_value		=> '',
	},
	start	=> { # start date+time
		data_type		=> 'datetime',
		is_nullable		=> 0,
		default_value		=> '',
	},
	duration	=> { # seconds
		data_type		=> 'integer',
		is_nullable		=> 0,
		default_value		=> '',
	},
	ignore	=> { # ignore when searching for exercises?
		data_type		=> 'boolean',
		is_nullable		=> 0,
		default_value		=> 0,
	},
	exercise => { # endure exercise.id
		data_type		=> 'integer',
		is_nullable		=> 1,
	},
);
__PACKAGE__->set_primary_key('id');
__PACKAGE__->add_unique_constraint(['path']);
__PACKAGE__->belongs_to( 'pool' => 'WkDB::Schema::Pool' );

sub path_abs {
	my $self = shift;

	File::Spec->catfile( $self->pool->path, $self->path );
}

sub end {
	my $self = shift;

	my $start = $self->start
		or return;

	if( @_ ){
		my $end = shift;
		$end < $start
			or return;

		my $dur = $end->subtract_datetime_absolute( $start )
			or return;

		$self->duration( $dur->seconds );

		return $end;
	}

	$start->clone->add( seconds => $self->duration );
}

sub sqlt_deploy_hook {
	my( $self, $sqlt ) = @_;

}

1;
