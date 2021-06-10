package GoHttpLib::Type::Request; 

use FFI::Platypus::Record;

record_layout_1(
   'string rw' => 'Method',
   'string rw' => 'Host',
   'string rw' => 'URL',
   'string rw' => 'Body',
   'string rw' => 'Headers'
);

1;
