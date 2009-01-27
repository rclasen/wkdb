use 5.008008;
use ExtUtils::MakeMaker;
# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.
WriteMakefile(
    NAME              => 'WkDB',
    VERSION      => '0.01',
    PREREQ_PM         => {
	    'Workout'	=> undef,
	    'File::Spec'	=> undef,
	    'File::HomeDir'	=> undef,
	    'File::ShareDir'	=> undef,
	    'Class::Accessor::Fast'	=> undef,
	    'DBD::SQLite'	=> undef,
	    'DBIx::Class'	=> undef,
	    'DateTime'		=> undef,
    }, # e.g., Module::Name => 1.1
    'EXE_FILES'       => [qw(
    	wkfile
	wkfind
	wkexercise
	wksend
    )],
    ($] >= 5.005 ?     ## Add these new keywords supported since 5.005
      (ABSTRACT_FROM  => 'lib/WkDB.pm', # retrieve abstract from module
       AUTHOR         => 'Rainer Clasen') : ()),
	# Un-comment this if you add C files to link with later:
    # OBJECT            => '$(O_FILES)', # link all the C files too
);
