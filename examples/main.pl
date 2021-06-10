package Request;

use FFI::Platypus::Record;


record_layout_1(
   'string rw' => 'Method',
   'string rw' => 'Host',
   'string rw' => 'URL',
   'string rw' => 'Body',
   'string rw' => 'Headers'
);

package main;


use FFI::Platypus;
use Cpanel::JSON::XS;

my $ffi = FFI::Platypus->new( api => 1);

$ffi->lib('./blib/lib/auto/share/dist/GoHttpLib/lib/libgohttplib.so');


$ffi->type("record(Request)" => 'Request');
$ffi->type('unsigned int' => 'ResponseWriterPtr');
$ffi->type('opaque' => 'Request_t');

$ffi->type('(ResponseWriterPtr, Request*)->void' => 'FunPtr' );

$ffi->attach(ListenAndServe  => ['string'] => 'void' );

$ffi->attach(HandleFunc  => ['string', 'FunPtr'] => 'void' );
$ffi->attach(Call_HandleFunc => ['ResponseWriterPtr', 'Request*', 'FunPtr'] => 'void');

$ffi->attach(ResponseWriter_Write => ['ResponseWriterPtr', 'string', 'int'] => 'int');
$ffi->attach(ResponseWriter_WriteHeader => ['ResponseWriterPtr', 'int'] => 'void');
$ffi->attach(ResponseWriter_SetHeader => ['ResponseWriterPtr', 'string', 'string'] => 'void');

use Cpanel::JSON::XS;


my $xxx = $ffi->closure(sub {
    my ($w, $r) = @_;
    my $body = "xxxxxx";
    my $n = ResponseWriter_Write($w, $body, length($body));
});
my $index = $ffi->closure(sub {
    my ($w, $r) = @_;
    my $s = {"x" => "x"};
    my $body = encode_json($s);

    ResponseWriter_SetHeader($w, "Content-Type", "application/json");
    my $n = ResponseWriter_Write($w, $body, length($body));
});


my $r = Request->new(
  Method   => 'GET',
  Host     => 'google.com',
  URL      => '/',
  Body     => 'Hellow World',
  Headers  => 'x=x'
);

HandleFunc("/z", $xxx);
HandleFunc("/", $index);
ListenAndServe("0.0.0.0:5000");
