package GoHttpLib::Route;

use GoHttpLib::FFI qw < $ffi >;
use Moose;
use Syntax::Keyword::Try;
use feature 'state';


use FFI::Platypus::Closure;
use GoHttpLib::Controller;
use GoHttpLib::Request;

our $_handlers = [];
$ffi->attach(HandleFunc  => ['string', 'FunPtr'] => 'void' );

has app => (
    is       => 'ro',
    isa      => 'GoHttpLib',
    required => 1,
    weak_ref => 1
); 

sub add {
    my ($self, $method, $path, $code_ref) = @_;
    
    my $callback = sub {
        my ($w, $r) = @_;
        
        my $request = GoHttpLib::Request->new(
            method  => $r->Method,
            body    => $r->Body,
            url     => $r->URL,
            headers => $r->Headers,
            host    => $r->Host,
        );

        my $c = GoHttpLib::Controller->new( app => $self->app, res => $w, req => $request );
        try {
            $code_ref->($c);
        }   
        catch {
            my $e = $@;
            warn $e;
            $c->res->status(500);
            $c->res->write("Internal Server Error");
        };  
    };  
    
    my $handler = FFI::Platypus::Closure->new( sub { $callback->(@_); });
    my $handler_ptr = $ffi->cast('FunPtr' => 'opaque', $handler);
    
    HandleFunc($path, $handler_ptr);
    push @$_handlers, $handler;
}   


1;
