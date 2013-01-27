#!/usr/bin/perl

use 5.006;
use strict;
use warnings;
use lib 'lib';
use DBIx::Migration::Directories::Build;

my $build = DBIx::Migration::Directories::Build->new(
    module_name         => 'DBIx::Migration::Directories',
    license             => 'perl',
    requires            => {
        'DBIx::Transaction'         => '0.005',
        'Pod::Usage'                => '1',
        'DBI'                       => '1.41',
        'File::Basename::Object'    => '0.01',
    },
    build_requires      => {
        'Data::Dumper'      => '2.10',
        'Module::Build'     => '0.27_03',
    },
    create_makefile_pl  => 'passthrough',
    auto_features       => {
        mysql   => {
            description => 'MySQL Support',
            requires    => {
                'DBD::mysql'    =>  '1.1211'
            }
        },
    },
    script_files        => [ 'bin/migrate-database-schema' ],
    add_to_cleanup      => [ 'test_db' ],
);

$build->autotest_with({
    'DBD::SQLite2'  =>  '0.33'
});
    
$build->create_build_script;
