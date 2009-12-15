package WkDB::Schema::Diary;
use strict;
use warnings;
use base 'WkDB::Base';

__PACKAGE__->my_init;
__PACKAGE__->table("diary");
__PACKAGE__->add_columns(
	"id"	=> {
		data_type		=> "integer",
		default_value		=> '',
		is_auto_increment	=> 1,
		is_nullable		=> 0,
	},
	athlete	=> { # athlete.id
		data_type		=> 'integer',
		is_nullable		=> 0,
		default_value		=> '',
	},
	"day"	=> { # date
		data_type		=> "date",
		default_value		=> undef,
		is_nullable		=> 0,
	},
	"hr"	=> { # n/min
		data_type		=> "integer",
		default_value		=> undef,
		is_nullable		=> 1,
	},
	"weight" => { # kg
		data_type		=> "float",
		default_value		=> undef,
		is_nullable		=> 1,
	},
	"sleep"	=> { # seconds
		data_type		=> "integer",
		default_value		=> undef,
		is_nullable		=> 1,
	},
	"temperature"	=> { # °C
		data_type		=> "float",
		default_value		=> undef,
		is_nullable		=> 1,
	},
	"bodyfat"	=> { # percent
		data_type		=> "integer",
		default_value		=> undef,
		is_nullable		=> 1,
	},
	"notes"	=> { # multi-line text
		data_type		=> "text",
		default_value		=> undef,
		is_nullable		=> 1,
	},
	t_created => { # row creation timestamp
		data_type		=> 'datetime',
		default_value		=> '',
		set_on_create		=> 1,
	},
	t_updated => { # row update timestamp
		data_type		=> 'datetime',
		default_value		=> '',
		set_on_create		=> 1,
		set_on_update		=> 1,
	},
);
__PACKAGE__->set_primary_key("id");
__PACKAGE__->add_unique_constraint(['athlete', 'day']);
__PACKAGE__->belongs_to( 'athlete' => 'WkDB::Schema::Athlete' );

sub sqlt_deploy_hook {
	my( $self, $sqlt ) = @_;

}

1;

