#!/usr/bin/perl

use Data::Dumper;
use strict;
use LWP;
use Getopt::Std;
use Term::ANSIColor qw( colored );

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
  close $fh;
}

if ($listTasks) {
  my @files = <TASKS/*.tsk>;

  print colored('|---ID---| |-Start Date and Time--| |-Task Name-->', 'green on_blue'), "\n";
  foreach my $task (@files) {
    my $taskEpoch;
    ($taskEpoch) = $task =~ /\/(.*)\./;

    open(my $fh, '<:encoding(UTF-8)', $task)
      or die "Could not open file '$task' $!";

    my @taskContent = <$fh>;
    print $taskEpoch . " " . localtime($taskEpoch) . " " . $taskContent[0] . "\n";
  }
}
