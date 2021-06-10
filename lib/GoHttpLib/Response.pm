package GoHttpLib::Response;

use GoHttpLib::FFI qw < $ffi >;
use Moose;

$ffi->attach(ResponseWriter_Write => ['ResponseWriterPtr', 'string', 'int'] => 'int');
$ffi->attach(ResponseWriter_WriteHeader => ['ResponseWriterPtr', 'int'] => 'void');
$ffi->attach(ResponseWriter_SetHeader => ['ResponseWriterPtr', 'string', 'string'] => 'void');

has writter => (
    is       => 'ro',
    isa      => 'Int',
    required => 1
);

sub write {
    my ($self, $body) = @_;
    my $n = ResponseWriter_Write($self->writter, $body, length($body));  
}   

sub set_header {
    my ($self, $key, $value) = @_;

    ResponseWriter_SetHeader($self->writter, $key, $value);
}

sub status {
    my ($self, $code) = @_;
    $code //= 200;
    ResponseWriter_WriteHeader($self->writter, $code);
}   


1;

