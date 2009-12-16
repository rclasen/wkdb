package WkDB::Schema::Pool;
use warnings;
use strict;
use base 'WkDB::Base';

# - list of directories to scan for files

__PACKAGE__->my_init;
__PACKAGE__->table('pool');
__PACKAGE__->add_columns(
	id	=> {
		data_type		=> 'integer',
		is_nullable		=> 0,
		is_auto_increment	=> 1,
		default_value		=> '',

	},
	name	=> { # non-white-space name
		data_type		=> 'varchar',
		is_nullable		=> 0,
		default_value		=> '',
	},
	path	=> { # pool's top directory
		data_type		=> 'varchar',
		is_nullable		=> 0,
		default_value		=> '',
	},
	pattern	=> { # perl regexp
		data_type		=> 'varchar',
		is_nullable		=> 1,
	},
	wktype	=> { # workout file type, overrides autodection
		data_type		=> 'varchar',
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
__PACKAGE__->add_unique_constraint(['name']);
__PACKAGE__->has_many( 'files' => 'WkDB::Schema::File' );

sub get_timestamp {
	scalar time;
}

sub sqlt_deploy_hook {
	my( $self, $sqlt ) = @_;

}

1;
