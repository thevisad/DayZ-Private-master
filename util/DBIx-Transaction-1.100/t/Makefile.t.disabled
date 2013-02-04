#!perl

use Test::More qw(no_plan);
use Test::CPANpm;
use Config;

sub save_env { return { map { exists $ENV{$_} ? ($_ => $ENV{$_}) : () } @_ }; }

sub restore_env {
    my $old = shift;
    while(my $v = shift) {
        if(exists $old->{$v}) {
            $ENV{$v} = $old->{$v};
        } else {
            delete $ENV{$v};
        }
    }
}

our @VARS = qw(PERL_MM_USE_DEFAULT AUTOMATED_TESTING);

my $env = save_env(@VARS);

$ENV{PERL_MM_USE_DEFAULT} = 1;

$ENV{AUTOMATED_TESTING} = 0;

unless(cpan_depends_ok(
    ['Test::CPANpm', 'DBI'],
    'Dont depend on DBD::SQLite2 for testing by default'
)) {
    diag('Seting AUTOMATED_TESTING to 0 FAILED!');
    
    my %diag = (
        q{$^X}                  =>      $^X,
        PERL5OPT                =>      $ENV{PERL5OPT},
        AUTOMATED_TESTING       =>      $ENV{AUTOMATED_TESTING},
    );
        
    use Data::Dumper;
    diag(Data::Dumper->Dump([\%diag]));
}

$ENV{AUTOMATED_TESTING} = 1;

cpan_depends_ok(
    ['Test::CPANpm', 'DBI', 'DBD::SQLite2' ],
    "Depend on DBD::SQLite2 when AUTOMATED_TESTING is set"
);

restore_env($env, @VARS);
