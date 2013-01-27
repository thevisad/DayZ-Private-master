package DBIx::Transaction;

use 5.006;
use strict;
use warnings (FATAL => 'all');
use base q(DBI);
use DBI;
use DBIx::Transaction::db;
use DBIx::Transaction::st;

our $VERSION = '1.100';

1;
