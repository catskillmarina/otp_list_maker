#!/usr/bin/perl

use List::MoreUtils qw(uniq);

print "############# Grabbing Diceware lists if needed ###########\n\n";
system("sleep 2");
if (! -f "./diceware.wordlist.asc")
{
    `wget http://world.std.com/~reinhold/diceware.wordlist.asc`;
}
if (! -f "./beale.wordlist.asc")
{
    `wget http://world.std.com/~reinhold/beale.wordlist.asc`;
}

open($beale,"./beale.wordlist.asc");
open($diceware,"diceware.wordlist.asc");



print "#############     Cleaning Diceware lists       ###########\n\n";
system("sleep 2");
while(<$beale>)
{
    $line = $_;
    if ( $line =~ m/-----BEGIN PGP SIGNATURE-----/ )
    {
        last;
    }
    if ( $line !~ m/BEGIN PGP SIGNED MESSAGE/ )
    {
        if ( $line =~ m/\w\t(.+)$/ )
        {
            $word = $1;
            chomp $word;
            push (@random_words,$word);
        }
    }
}
while(<$diceware>)
{
    $line = $_;
    if ( $line =~ m/-----BEGIN PGP SIGNATURE-----/ )
    {
        last;
    }
    if ( $line !~ m/BEGIN PGP SIGNED MESSAGE/ )
    {
        if ( $line =~ m/\w\t(.+)$/ )
        {
            $word = $1;
            chomp $word;
            push (@random_words,$word);
        }
    }
}

close($beale);
close($diceware);

@randoms_words = uniq(sort(@random_words));

$word_count = scalar(@randoms_words);
print "######### There are $word_count words in this list ########\n\n";
system("sleep 1");
print "###### Generating random numbers to randomize words #######\n\n";

for($i=1; $i<=$word_count; $i++)
{
    my $random = `dd if=/dev/urandom bs=10 obs=10 count=1 status=none| base64 2>&1`;
    push (@randoms_number,$random);
    chomp (@randoms_number);
}

print @randoms_mumber;

foreach $random_word (@randoms_words)
{
    $random_number = pop(@randoms_number);
    $outstring = $random_number . " " . $random_word . "\n";
    push (@output, $outstring);
}

print "###############            Sorting output    ##############\n\n";
system("sleep 1");
@sorted_output = sort(@output);

$j=0;

open ($output, ">OUTPUT.txt");
foreach (@sorted_output)
{
    print $output $_;
    $j++;
    if($j==10)
    {
        print $output "\n\n";
        $j=0;
    }
}
close ($output);
print "############## Password file is in OUTPUT.txt #############\n\n";
