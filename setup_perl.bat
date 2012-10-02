@echo off
cd util\DBIx-Transaction-1.100
perl Makefile.PL
dmake
dmake install
cd ..\DBIx-Migration-Directories-0.11
perl Makefile.PL
dmake
dmake install
cd ..\File-DirCompare-0.6
perl Makefile.PL
dmake
dmake install
cd ..\..
cpan File::Basename::Object Text::Diff Text::Patch
