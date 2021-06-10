package GoHttpLib::Controller;

use Moose;
use Moose::Util::TypeConstraints;

use GoHttpLib::Response;
use GoHttpLib::Request;

subtype 'Response' =>  
    as 'Object';

coerce  'Response' => 
    from 'Any'     => 
    via { GoHttpLib::Response->new(writter => $_[0]) };

subtype 'Request' => 
    as 'Object';

has app => (
    is       => 'ro',
    isa      => 'GoHttpLib',
    weak_ref => 1,
    required => 1,
);

has res => (
    is       => 'ro',
    isa      => 'Response',
    coerce   => 1,
    required => 1,
);

has req => (
    is       => 'ro',
    isa      => 'Object',
    required => 1,
);

1;
