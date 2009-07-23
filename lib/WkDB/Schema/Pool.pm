package WkDB::Schema::Pool;
use warnings;
use strict;
use base 'WkDB::Base';

# - list of directories to scan for files

# TODO: GUI types for scaffold:
#  - type name the table provides
#  - per column used type

# :gui:table=pool,render=Pool
__PACKAGE__->my_init;
__PACKAGE__->table('pool');
__PACKAGE__->add_columns(
	# :gui:column=id,convert=Plain,render=Plain
	id	=> {
		data_type		=> 'integer',
		is_nullable		=> 0,
		is_auto_increment	=> 1,
		default_value		=> '',

	},
	# :gui:column=name,convert=Plain,render=Plain
	name	=> {
		data_type		=> 'varchar',
		is_nullable		=> 0,
		default_value		=> '',
	},
	# :gui:column=path,convert=Plain,render=Plain
	path	=> {
		data_type		=> 'varchar',
		is_nullable		=> 0,
		default_value		=> '',
	},
	# :gui:column=pattern,convert=Plain,render=Plain
	pattern	=> {
		data_type		=> 'varchar',
		is_nullable		=> 1,
	},
);
__PACKAGE__->set_primary_key('id');
__PACKAGE__->add_unique_constraint(['name']);
__PACKAGE__->has_many( 'files' => 'WkDB::Schema::File' );

sub sqlt_deploy_hook {
	my( $self, $sqlt ) = @_;

}

1;
