#!/usr/bin/perl

use strict;
use warnings;

binmode(STDIN, ":utf8");
binmode(STDOUT, ":utf8");

my $rulesFile = $ARGV[0];

my @rules = ();

open(my $fh, '<:encoding(UTF-8)', $rulesFile)
    or die "Could not open file '$rulesFile' $!";
while (<$fh>) {
    chomp;
    if ($_ =~ /^\s*$/) { next; } #empty line
    if ($_ =~ /^#/) { next; } #comment

    my @cells = split /\t/;
    my $rule = {
        regex => $cells[0],
        replace => $cells[1]
    };
    push @rules, $rule;
}
close $fh;

while (<STDIN>) {
    chomp;
    my $string = $_;
    for (@rules) {
        if ($_->{replace} =~ /\$/) {
            my $replace = '"' . $_->{replace} . '"';
            $string =~ s/$_->{regex}/$replace/igee;
            next;
        }
        $string =~ s/$_->{regex}/$_->{replace}/ig;
    }
    print $string . "\n";
}
