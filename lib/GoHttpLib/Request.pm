package GoHttpLib::Request;

use Moose;
use Moose::Util::TypeConstraints;

subtype 'Headers' => 
    as 'HashRef';

coerce  'Headers' =>
    from 'Str'    =>
    via { 
      +{ 
          map { s/^\s+|\s+$//g; $_ }
           map { split /:/, $_ } split /\n/, $_[0] 
        }
    };

has headers => (
    is       => 'rw',
    isa      => 'Headers',
    required => 1,
    coerce   => 1
);

for my $s (qw <method url host body> ) {
    has $s => (
       is       => 'rw',
       isa      => 'Str',
       required => 1
    );
}

1;
