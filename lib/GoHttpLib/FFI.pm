package GoHttpLib::FFI;

use strict;
use warnings;

use FFI::Platypus;
use GoHttpLib::Type::Request;
use base qw( Exporter );

our @EXPORT = qw( $ffi );

our $ffi = FFI::Platypus->new(api => 1);

#$ffi->lib('/home/prajith/dev/go/src/github.com/Prajithp/FFI-Platypus-Lang-Go/examples/GoHttpLib/blib/lib/auto/share/dist/GoHttpLib/lib/libgohttplib.so');
$ffi->bundle;

$ffi->type("record(GoHttpLib::Type::Request)" => 'Request');
$ffi->type('unsigned int' => 'ResponseWriterPtr');
$ffi->type('(ResponseWriterPtr, Request*)->void' => 'FunPtr' );

1;
