use ExtUtils::MakeMaker;

# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.
#
WriteMakefile(
    'NAME'		=> 'Data::Serializer',
    'DISTNAME'		=> 'Data-Serializer',
    'VERSION_FROM'	=> 'lib/Data/Serializer.pm', # finds $VERSION
    'AUTHOR'		=> 'Neil Neely (neil@frii.net)',
    'PREREQ_PM'		=> 	{
	                 	  'Digest::SHA1' => 0,
	                 	  'Data::Dumper' => 2.08,
       	               		},
    'dist'      => {'COMPRESS'=>'gzip -9f', 'SUFFIX' => 'gz',
                    'ZIP'=>'/usr/bin/zip','ZIPFLAGS'=>'-rl'}

);
