#!/usr/bin/perl

my $testFile = $ARGV[0];
my $normalizeScript = $ARGV[1];
my $normalizeRules = $ARGV[2];

open FH, '<', $testFile or die $!;

my $failed = 0;
my $i = 0;
while (<FH>) {
    chomp;

    my @test = split /\t/, $_;

    my $result = `echo "$test[0]" | perl $normalizeScript $normalizeRules`;
    chomp $result;

    my $sep = "   ";
    if ($i >= 10) {
        $sep = "  ";
    }
    print "TEST[" . $i++ . "]$sep";
    if ($result eq $test[1]) {
        print "OK   $test[0]\t$result\n";
    } else {
        $failed++;
        print "FAIL $test[0] - expected: `$test[1]`, got: `$result`\n";
    }

}

if ($failed > 0) {
    exit 1;
}

exit 0;
