use lib "./t";             # to pick up a ExtUtils::TBone

use Data::Serializer; 

use ExtUtils::TBone;

my $T = typical ExtUtils::TBone;                 # standard log

my %testrefs = (

   simplehash    => { alpha => 1,
	   	     beta  => 2 },

   simplearray   => [qw ( one two three ) ],

   complexarray  => ['one', {alpha => 1, beta => 2},['bob','dole']],

   complexhash   => {
			apple  => [qw ( one two three ) ],
			orange => { alpha => 1, beta  => 2 },
			pear   => { 
				chain => {
					hippie => 'smelly', 
					donkey => 'worship',
					 }, 
				monkey => 3,
			 	  },
		 },
	);

	
my %serializers = (
			'Data::Dumper'	=> {
						simplearray  => 1,
						complexarray => 2,
						simplehash   => 1,
						complexhash  => 3,
					   },
			'Data::Denter'	=> {
						simplearray  => 1,
						complexarray => 2,
						simplehash   => 1,
						complexhash  => 3,
					   },
			'Storable'	=> {
						simplearray  => 1,
						complexarray => 2,
						simplehash   => 1,
						complexhash  => 3,
					   },
			'FreezeThaw'	=> {
						simplearray  => 1,
						complexarray => 2,
						simplehash   => 1,
						complexhash  => 3,
					   },
			'Config::General' => {
						simplearray  => 0,
						complexarray => 0,
						simplehash   => 1,
						complexhash  => 3,
					   },
			'YAML'	=> {
						simplearray  => 1,
						complexarray => 2,
						simplehash   => 1,
						complexhash  => 3,
					   },
		  );
my %features = (
		'encryption' 	 => [qw (Crypt::CBC Crypt::Blowfish)],
		'compression' 	 => [qw (Compress::Zlib)],
		'encoding' 	 => [qw (MIME::Base64)],
		);

my @serializers;
foreach my $serializer (keys %serializers) {
	if (eval "require $serializer") {
		$T->msg("Found serializer $serializer");  
		push(@serializers, $serializer);
	}
}


$T->msg("No serializers found!!") unless (@serializers);

         
my @features;
FEATURE:
while (my ($feature,$ref) =  each %features) {
	foreach my $module (@{$ref}) {
		next FEATURE unless (eval "require $module"); 
        }
	$T->msg("Found feature $feature");  
	push(@features, $feature);
}
my @feature_combos;
push(@feature_combos, "non-portable encryption") if (grep {/^encryption$/} @features);
push(@feature_combos, "non-portable compression") if (grep {/^compression$/} @features);
if (grep {/^encryption$/} @features && grep {/^compression$/} @features) {
  push(@feature_combos, "encryption compression");
  push(@feature_combos, "non-portable encryption compression");
} 
push(@feature_combos, "encryption encoding") if (grep {/^encryption$/} @features && grep {/^encoding$/} @features);
push(@feature_combos, "encoding compression") if (grep {/^encoding$/} @features && grep {/^compression$/} @features);
push(@feature_combos, "encoding encryption compression") if (grep {/^encoding$/} @features && grep {/^encryption$/} @features && grep {/^compression$/} @features);

my %tests;
my $testcount;
foreach my $serializer (@serializers) {
	while (my ($test,$value) = each %{$serializers{$serializer}}) {
		next unless $value;
		#add basic test
		$testcount += $value;
		$tests{$serializer}->{$test}->{basic} = $value;
		#add non-portable test
		$testcount += $value;
		$tests{$serializer}->{$test}->{'non-portable'} = $value;
		foreach my $feature (@features) {
			$testcount += $value;
			$tests{$serializer}->{$test}->{$feature} = $value;
		}
		foreach my $feature_combo (@feature_combos) {
			$testcount += $value;
			$tests{$serializer}->{$test}->{$feature_combo} = $value;
		}
        }
}
$T->begin($testcount);
$T->msg("Here come the tests");  # message for the log

foreach my $serializer (keys %tests) {
	foreach my $test (keys %{$tests{$serializer}}) {
		foreach my $features (keys %{$tests{$serializer}->{$test}}) {
                  run_test($serializer,$test,$features);
		}
	}
}
sub run_test {
	my ($serializer,$test,$features) = @_;
	$T->msg("Test $serializer $test $features");  # message for the log
	my $obj = Data::Serializer->new(serializer=>$serializer);
	#basic encryption compression 
        foreach my $feature (split(" ", $features)) {
   		if ($feature eq 'basic') {
			#do nothing special
		} elsif ($feature eq 'non-portable') {
			#make sure we work without ascii armoring
			$obj->portable(0);
		} elsif ($feature eq 'encryption') {
			#setup a secret so we use encryption on this run
			$obj->secret('test');
		} elsif ($feature eq 'compression') {
			# use compression (Compress::Zlib)
			$obj->compress(1);
		} elsif ($feature eq 'encoding') {
			# test alternate encoding
			$obj->encoding('b64');
		}
	}
	my $frozen = $obj->serialize($testrefs{$test});
	my $thawed = $obj->deserialize($frozen);
	if ($test eq 'simplearray') {
		$T->ok_eq($testrefs{$test}->[0], $thawed->[0],'array');
	} elsif ($test eq 'complexarray') {
		$T->ok_eq($testrefs{$test}->[2]->[0], $thawed->[2]->[0],'array of arrays');
		$T->ok_eqnum($testrefs{$test}->[1]->{alpha}, $thawed->[1]->{alpha},'array of hashes');
	} elsif ($test eq 'simplehash') {
		$T->ok_eqnum($testrefs{$test}->{alpha}, $thawed->{alpha},'hash');
	} elsif ($test eq 'complexhash') {
		$T->ok_eq($testrefs{$test}->{apple}->[1], $thawed->{apple}->[1],'hash of arrays');
		$T->ok_eqnum($testrefs{$test}->{orange}->{alpha}, $thawed->{orange}->{alpha},'hash of hashes');
		$T->ok_eq($testrefs{$test}->{pear}->{chain}->{hippie}, $thawed->{pear}->{chain}->{hippie},'hash of hash of hashes');
	}
}
