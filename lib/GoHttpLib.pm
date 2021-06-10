package GoHttpLib;

use GoHttpLib::FFI;
use GoHttpLib::Route;

use Moose;
use feature qw< say >;

$ffi->attach(ListenAndServe  => ['string'] => 'void' );

has route =>(
    is      => 'rw',
    isa     => 'GoHttpLib::Route',
    default => sub { GoHttpLib::Route->new(app => $_[0]) }, 
);

sub run {
    my ($self, $host, $port)  = @_;
    $host //= "0.0.0.0";
    $port //= "5000";

    ListenAndServe($host .':'. $port);
}


1;
