use ExtUtils::MakeMaker;
# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.
WriteMakefile(
    'NAME'		=> 'Data::Serializer',
    'DISTNAME'		=> 'Data-Serializer',
    'VERSION_FROM'	=> 'lib/Data/Serializer.pm', # finds $VERSION
    'AUTHOR'		=> 'Neil Neely (neil@frii.net)',
    'PREREQ_PM'		=> 	{
	                 	  'Storable' => 0,
	                 	  'FreezeThaw' => 0,
	                 	  'Data::Dumper' => 0,
	                 	  'Data::Denter' => 0,
	                 	  'Compress::Zlib' => 0,
	                 	  'Crypt::CBC' => 0,
       	                	  'Digest'     => 0,
       	               		},
    'dist'      => {'COMPRESS'=>'gzip -9f', 'SUFFIX' => 'gz',
                    'ZIP'=>'/usr/bin/zip','ZIPFLAGS'=>'-rl'}

);
