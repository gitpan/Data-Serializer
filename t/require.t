# -*- mode: perl -*-
# ============================================================================


BEGIN { $|=1; $^W=1; }

use strict;
use Test;

BEGIN { plan tests => 9 };

# Exporter.pm
eval { require Exporter; };
ok($@, '', 'Required module Exporter missing');

# AutoLoader.pm
eval { require AutoLoader; };
ok($@, '', 'Required module AutoLoader missing');

# Data::Dumper.pm
eval { require Data::Dumper; };
ok($@, '', 'Required module Data::Dumper missing');

# Data::Denter.pm
eval { require Data::Denter; };
ok($@, '', 'Required module Data::Denter missing');


# Storable.pm
eval { require Storable; };
ok($@, '', 'Required module Storable missing');

# FreezeThaw.pm
eval { require FreezeThaw; };
ok($@, '', 'Required module FreezeThaw missing');

# Digest.pm
eval { require Digest; };
ok($@, '', 'Required module Digest missing');

# Crypt::CBC.pm
eval { require Crypt::CBC; };
ok($@, '', 'Required module Crypt::CBC missing');

# Compress::Zlib.pm
eval { require Compress::Zlib; };
ok($@, '', 'Required module Compress::Zlib missing');

# ============================================================================
