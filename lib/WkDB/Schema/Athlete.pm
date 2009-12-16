package WkDB::Schema::Athlete;
use strict;
use warnings;
use base 'WkDB::Base';

__PACKAGE__->my_init;
__PACKAGE__->table("athlete");
__PACKAGE__->add_columns(
	"id"	=> {
		data_type		=> "integer",
		default_value		=> '',
		is_auto_increment	=> 1,
		is_nullable		=> 0,
	},
	name	=> {
		data_type		=> 'varchar',
		is_nullable		=> 0,
		default_value		=> '',
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
__PACKAGE__->set_primary_key("id");
__PACKAGE__->add_unique_constraint(['name']);
__PACKAGE__->has_many( 'diary' => 'WkDB::Schema::Diary' );

sub get_timestamp {
	scalar time;
}

sub sqlt_deploy_hook {
	my( $self, $sqlt ) = @_;

}

1;

