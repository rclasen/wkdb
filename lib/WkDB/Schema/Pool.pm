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
	name	=> {
		data_type		=> 'varchar',
		is_nullable		=> 0,
		default_value		=> '',
	},
	path	=> {
		data_type		=> 'varchar',
		is_nullable		=> 0,
		default_value		=> '',
	},
	pattern	=> {
		data_type		=> 'varchar',
		is_nullable		=> 1,
	},
	# TODO: add optional file_type
);
__PACKAGE__->set_primary_key('id');
__PACKAGE__->add_unique_constraint(['name']);
__PACKAGE__->has_many( 'files' => 'WkDB::Schema::File' );

sub sqlt_deploy_hook {
	my( $self, $sqlt ) = @_;

}

1;
