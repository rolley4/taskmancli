#!/usr/bin/perl

use Data::Dumper;
use strict;
use LWP;
use Getopt::Std;
use Term::ANSIColor qw( colored );

my %opts;
getopts('hvadle:D:', \%opts);

my $help        = $opts{'h'};
my $verbose     = $opts{'v'};
my $addTasks    = $opts{'a'};
my $details     = $opts{'d'};
my $listTasks   = $opts{'l'};
my $editTasks   = $opts{'e'};
my $taskDir     = $opts{'D'};

# -D should be an alias
if ($taskDir) {
  $taskDir = $taskDir . '/TASKS/';
} else {
  $taskDir = 'TASKS/';
}

sub syntax {
  # Disaply Syntax and Exit
  #TODO
  my $syntax = "Usage $0 something";
  print $syntax;
  exit;
}

# ADD NEW TASKS
if ($addTasks) {
  my $taskHash = time();
  my $filename = $taskDir . $taskHash .  '.tsk';
  open(my $fh, '>', $filename)
    or die "Could not open file '$filename' $!";
  print $fh "TASK:TASK TITLE\n" . "TASKSTART:" . (localtime($taskHash)) . "\n" . "TASKEND:" . (localtime($taskHash+86400)) . "\n" . "NOTES:";
  close $fh;
  system('nano', $filename);
}

# ADD NEW TASKS
if ($editTasks) {
  my $filename = $taskDir . $editTasks .  '.tsk';
  system('nano', $filename);
}

# LIST TASKS
if ($listTasks) {
  my @files = <$taskDir*.tsk>;

  my $colorToggle = 0;
  print colored('|---ID----| |---Start Date and Time--| |--_-End Date and Time---| |--------Task----------->', 'white on_blue'), "\n";
  #print colored('|---ID---| |-Start Date and Time--| |-Task Name-->', 'white on_blue'), "\n";
  foreach my $task (@files) {
    my ($taskEpoch) = $task =~ /TASKS\/(.*)\./;
    my $taskContent;
    my $taskItemStart;
    my $taskItemEnd;
    my @taskNotes;

    open(my $fh, '<', $task)
      or die "Could not open file '$task' $!";

    while (my $row = <$fh>) {
      if ($row =~ /^TASK\:.*/) {
        chomp $row;
        $row =~ s/^TASK\://;
        $taskContent = $row;
      } elsif ($row =~ /^TASKSTART\:.*/) {
        chomp $row;
        $row =~ s/^TASKSTART\://;
        $taskItemStart = $row;
      } elsif ($row =~ /^TASKEND\:.*/) {
        chomp $row;
        $row =~ s/^TASKEND\://;
        $taskItemEnd = $row;
      } elsif ($row =~ /^NOTES\:.*/) {
        chomp $row;
        $row =~ s/^NOTES\://;
        push @taskNotes, $row;
      } else {
        chomp $row;
        push @taskNotes, $row;
      }
    }

    my $listColor;
    if ($colorToggle) {
      $colorToggle = 0;
      $listColor = 'green';
    } else {
      $colorToggle = 1;
      $listColor = 'blue';
    }

    print colored($taskEpoch, $listColor) . "| |" . colored($taskItemStart, $listColor) . "| |" . colored($taskItemEnd, 'red') . "| |" . colored($taskContent, $listColor) . "\n";

    if ($details) {
      foreach (@taskNotes) {
        print "\t", colored($_, 'cyan') . "\n";
      }
    }

  }
}
