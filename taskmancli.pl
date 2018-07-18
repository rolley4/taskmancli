#!/usr/bin/perl

use Data::Dumper;
use strict;
use LWP;
use Getopt::Std;
use Term::ANSIColor qw( colored );

my %opts;
getopts('hvadl', \%opts);

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
  print $fh "TASK:TASK TITLE\n" . "TASKSTART:" . (localtime($taskHash)) . "\n" . "TASKEND:" . (localtime($taskHash+864000)) . "\n" . "NOTES:";
  close $fh;
  system('pico', $filename);
}

if ($listTasks) {
  my @files = <TASKS/*.tsk>;

  my $colorToggle = 0;
  print colored('|---ID---| |-Start Date and Time--| |-Task Name-->', 'white on_blue'), "\n";
  #print colored('|---ID---| |-Start Date and Time--| |-Task Name-->', 'white on_blue'), "\n";
  foreach my $task (@files) {
    my $taskEpoch;
    ($taskEpoch) = $task =~ /\/(.*)\./;

    open(my $fh, '<:encoding(UTF-8)', $task)
      or die "Could not open file '$task' $!";

    my $listColor;
    if ($colorToggle) {
      $colorToggle = 0;
      $listColor = 'green';
    } else {
      $colorToggle = 1;
      $listColor = 'blue';
    }
    my @taskContent = <$fh>;
    chomp($taskContent[0]);
    my $taskDetailOut = $taskEpoch . " " . localtime($taskEpoch) . " " . $taskContent[0];
    print colored($taskDetailOut, $listColor) . "\n";
  }
}
