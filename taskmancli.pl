#!/usr/bin/perl

use Data::Dumper;
use strict;
use LWP;
use Getopt::Std;

my %opts;
getopts('hva:dl', \%opts);

my $help        = $opts{'h'};
my $verbose     = $opts{'v'};
my $addTasks    = $opts{'a'};
my $dueDate     = $opts{'d'};
my $listTasks   = $opts{'l'};

sub syntax {
  # Disaply Syntax and Exit
  #TODO
  my $syntax = "Usage $0 something";
  print $syntax;
  exit;
}

if ($addTasks) {
  my $taskHash = time();
  my $filename = 'TASKS/' . $taskHash .  '.tsk';
  open(my $fh, '>', $filename)
    or die "Could not open file '$filename' $!";

  print $fh "$addTasks";
}

if ($listTasks) {
  my @files = <TASKS/*.tsk>;

  foreach my $task (@files) {
    print $task . "\n";
  }
}
