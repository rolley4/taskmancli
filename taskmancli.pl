#/usr/bin/perl

use strict;
use Getopt::Std;

my %opts;
getopts('hval', \%opts);

my $help      = $opts{'h'};
my $verbose   = $opts{'v'};
my $addTasks  = $opts{'a'};

sub syntax{
  # Disaply Syntax and Exit
  #TODO
  my $sysntax = "Usage $0 something"
  print $sysntax;
  exit;
}

print ""$help $verbose $addTasks";
