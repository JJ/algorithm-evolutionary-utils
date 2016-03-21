#-*-cperl-*-

use Test::More;
use warnings;
use strict;

use lib qw( lib ../lib ../../lib  ); #Just in case we are testing it in-place

use Algorithm::Evolutionary::Utils 
  qw(entropy genotypic_entropy hamming consensus average decode_string 
     vector_compare random_bitstring random_number_array);

my @pop;
my $number_of_bits = 32;
my $population_size = 16;
my $last_bitstring = "0"x$number_of_bits;
for ( 0..$population_size ) {
  my $indi = random_bitstring( $number_of_bits, 1 );
  isnt( $indi->{'_str'}, $last_bitstring, "New random bitstring" );
  $last_bitstring = $indi->{'_str'};
  #Creates random individual
  $indi->{ _fitness} = rand ;
  
  push( @pop, $indi );
}

my $size = 3;
my $min = -10;
my $range = 20;
my @last_number_array = qw( 0 0 0 );
for ( 0..$population_size ) {
  my @random_number_array = random_number_array( $size, $min, $range );
  isnt( $random_number_array[0], $last_number_array[0], "New random number array" );
  @last_number_array = @random_number_array;
}

#test utils

ok( entropy( \@pop ) > 0, "Entropy" );
my @not_a_real_pop = @pop;
push @not_a_real_pop, { _str => random_bitstring($number_of_bits)};
ok( entropy( \@not_a_real_pop ) > 0, "Entropy 2" );
ok( genotypic_entropy( \@pop ) > 0, "Genotypic entropy");
ok( hamming( $pop[0]->{'_str'}, $pop[1]->{'_str'}) > 0, "Hamming" );
ok( length(consensus( \@pop )) > 1, "Consensus" );
ok( length(consensus( \@pop, 1 )) > 1, "Rough consensus" );
ok( average( \@pop ) > 0, "Average");
is( scalar( decode_string( $pop[0]->{'_str'}, 10, -1, 1 ) ), 1+ int($number_of_bits/10), "Decoding" );
my @vector_1 = qw( 1 1 1);
my @vector_2 = qw( 0 0 0);
is( vector_compare( \@vector_1, \@vector_2 ), 1, "Comparison 0" );
@vector_2 = qw( 0 0 1);
is( vector_compare( \@vector_1, \@vector_2 ), 1, "Comparison 1" );
@vector_2 = qw( 1 1 1);
is( vector_compare( \@vector_1, \@vector_2 ), 0 , "Comparing equal" );
@vector_2 = qw( 2 2 1);
is( vector_compare( \@vector_1, \@vector_2 ), -1, "Compare less" );

done_testing;

=head1 Copyright
  
  This file is released under the GPL. See the LICENSE file included in this distribution,
  or go to http://www.fsf.org/licenses/gpl.txt

  CVS Info: $Date: 2010/09/24 08:39:07 $ 
  $Header: /media/Backup/Repos/opeal/opeal/Algorithm-Evolutionary/t/0002-utils.t,v 3.1 2010/09/24 08:39:07 jmerelo Exp $ 
  $Author: jmerelo $ 
  $Revision: 3.1 $
  $Name $

=cut
