package WkDB;
use strict;
use warnings;
use base 'Class::Accessor::Fast';
use Carp;
use File::Spec;
use File::HomeDir;
use File::ShareDir;
use Data::Dumper;
use WkDB::Schema;

our $VERSION = '0.06';

=head1 NAME

WkDB - Workout Database. Maintains overview of your Workout files.

=head1 SYNOPSIS

 my $wdb = WkDB->new;
 $files = $wkdb->db->resultset('File');

=head1 DESCRIPTION

WkDB is a DBIx::Class::Schema. It's intended to keep track of all your
workouts.

=cut

# TODO: split DB into seperate files, use SQL "ATTACH" to open

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

sub cfgname {
	my $self = shift;
	File::Spec->catfile($self->datadir,'config');
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

sub _cfg_read {
	my $self = shift;

	my $fn = $self->cfgname;
	open( my $fh, "<", $fn )
		or return {};

	my %cfg;

	while( defined( my $line = <$fh> ) ){
		next if $line =~ /^#/;
		next if $line =~ /^\s*$/;
		$line =~ /^(\w+)="(.*)"\s*$/
			or croak "config $fn, line $.: syntax error";

		$cfg{$1} = $2;
	}

	close $fh;

	return \%cfg;
}


# TODO: config defaults

sub config {
	my $self = shift;
	$self->{config} ||= $self->_cfg_read;

	return $self->{config}{$_[0]}
		if @_ && exists $self->{config}{$_[0]};

	$self->{config};
}


sub _db_connect_do {
	my( $self, $fn ) = @_;

	WkDB::Schema->connect(
		'dbi:SQLite:'. $fn,
		'', '', {
			unicode	=> 1,
			# TODO: in recent versions 'unicode' is renamed:
			sqlite_unicode	=> 1,
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

=head1 SEE ALSO

WkDB::Schema::*, Workout, WkGUI, wkfile, wkfind

=head1 AUTHOR

Rainer Clasen

=cut

