@echo off
cd util\DBIx-Transaction-1.100
perl Makefile.PL
dmake
dmake install
cpan -f -i DBIx::Migration::Directories
cd ..\..
