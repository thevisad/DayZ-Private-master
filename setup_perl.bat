@echo off
cd util\DBIx-Transaction-1.100
perl Makefile.PL
gmake
gmake install
cd ..\DBIx-Migration-Directories-0.11
perl Makefile.PL
gmake
gmake install
cd ..\File-DirCompare-0.6
perl Makefile.PL
gmake
gmake install
cd ..\Net-GitHub-0.50
perl Makefile.PL
gmake
gmake install
cd ..\..
cpan File::Basename::Object Text::Diff Text::Patch Config::IniFiles
