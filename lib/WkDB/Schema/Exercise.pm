package WkDB::Schema::Exercise;
use warnings;
use strict;
use base 'WkDB::Base';

# - Exercise ... multiple files... multiple applications (endure, ttborg, ...)

__PACKAGE__->my_init;
__PACKAGE__->table('exercise');
__PACKAGE__->add_columns(
	id	=> {
		data_type		=> 'integer',
		is_nullable		=> 0,
		is_auto_increment	=> 1,
		default_value		=> '',

	},
	athlete	=> { # athlete.id
		data_type		=> 'integer',
		is_nullable		=> 0,
		default_value		=> '',
	},
	endure	=> { # endure.id
		data_type		=> 'integer',
		is_nullable		=> 1,
	},
	ttborg	=> { # ttborg.id
		data_type		=> 'integer',
		is_nullable		=> 1,
	},
	sent	=> { # mail was sent
		data_type		=> 'boolean',
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
__PACKAGE__->belongs_to( 'athlete' => 'WkDB::Schema::Athlete' );
__PACKAGE__->has_many( 'files' => 'WkDB::Schema::File' );

sub get_timestamp {
	scalar time;
}

1;
