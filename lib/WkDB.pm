package WkDB;
use strict;
use warnings;
use base 'Class::Accessor::Fast';
use Carp;
use File::Spec;
use File::HomeDir;
use File::ShareDir;
use WkDB::Schema;



our %defaults_ro = (
	datadir	=> File::Spec->catfile(
		File::HomeDir->my_data, ".wkdb" ),
);

__PACKAGE__->mk_ro_accessors( keys %defaults_ro );

sub new {
	my( $proto, $a ) = @_;
	my $self = $proto->SUPER::new( {
		%defaults_ro, 
		( $a ? %$a : () ),
		db	=> undef,
	} );

	-d $self->datadir || mkdir $self->datadir
		or croak "mkdir: $!";

	$self;
}

sub dbfname {
	my $self = shift;
	File::Spec->catfile($self->datadir,'data.db');
}

sub schemadir {
	my $self = shift;
	File::Spec->catfile( File::ShareDir->module_dir(__PACKAGE__), 
		'schema-updates' );
}

sub backupdir {
	my $self = shift;
	File::Spec->catfile( $self->datadir, 'backup' );
}


sub _db_connect_do {
	my( $self, $fn ) = @_;

	WkDB::Schema->connect(
		'dbi:SQLite:'. $fn,
		'', '', {
			unicode	=> 1,
		}
	);
}

sub _db_connect {
	my $self = shift;

	my $fn = $self->dbfname;

	# TODO: version DB schema
	# WkDB::Schema->upgrade_directory( $self->schemadir );
	# WkDB::Schema->backup_directory( $self->backupdir );

	unless( -r $fn ){
		my $db = $self->_db_connect_do( $fn );
		$db->deploy;
	}

	$self->_db_connect_do( $fn );
}

sub db {
	my $self = shift;

	$self->{db} ||= $self->_db_connect;
}

1;
