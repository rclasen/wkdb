package WkDB::Schema::File;
use warnings;
use strict;
use base 'WkDB::Base';
use WkDB::ResultSet::File;
use Workout;

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

	start	=> { # start time (epoch)
		data_type		=> 'integer',
		is_nullable		=> 0,
		default_value		=> '',
	},
	duration => { # seconds
		data_type		=> 'integer',
		is_nullable		=> 0,
		default_value		=> '',
	},
	ignore	=> { # ignore when searching for exercises?
		data_type		=> 'boolean',
		is_nullable		=> 0,
		default_value		=> 0,
	},
	converted	=> { # file is result of conversion from other format
		data_type		=> 'boolean',
		is_nullable		=> 0,
		default_value		=> 0,
	},
	exercise => { # endure exercise.id
		data_type		=> 'integer',
		is_nullable		=> 1,
	},
	t_created => { # row creation timestamp
		data_type		=> 'integer',
		default_value		=> '',
		set_on_create		=> 1,
	},
	t_updated => { # row update timestamp
		data_type		=> 'integer',
		default_value		=> '',
		set_on_create		=> 1,
		set_on_update		=> 1,
	},
);
__PACKAGE__->set_primary_key('id');
__PACKAGE__->add_unique_constraint(['pool', 'path']);
__PACKAGE__->belongs_to( 'pool' => 'WkDB::Schema::Pool' );
__PACKAGE__->belongs_to( 'exercise' => 'WkDB::Schema::Exercise' );
__PACKAGE__->has_many( 'exercise_files' => 'WkDB::Schema::File', {
	'foreign.exercise' => 'self.exercise',
}, {
	cascade_delete	=> 0,
	cascade_copy	=> 0,
});

sub get_timestamp {
	scalar time;
}

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

		$self->duration( $end - $start );

		return $end;
	}

	$start + $self->duration;
}

sub workout {
	my $self = shift;

	if( my $ftype = $self->pool->wktype ){
		unshift @_, ftype => $ftype;
	}

	Workout::file_read( $self->path_abs, @_ );
}

sub sqlt_deploy_hook {
	my( $self, $sqlt ) = @_;

}

1;
