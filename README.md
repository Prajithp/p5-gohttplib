# p5-gohttplib

Shared library that exposes Go's `net/http.Server` with externally-bindable handlers. Originally developed by shazow(https://github.com/shazow/gohttplib).

## Getting Started

Requirements:

- Go 1.5 or newer.
- C example: make, gcc
- Perl, Forked version of FFI::Platypus(https://github.com/Prajithp/FFI-Platypus), Moose

### Installation

```
perl Makefile.PL
make && make install 
```

### Example: 
```
#!/usr/bin/perl

use GoHttpLib;

my $app   = GoHttpLib->new();
my $route = $app->route;

$route->add('GET', '/test', sub {
    my ($c) = @_;
    $c->res->write("test");
});

$route->add('GET', '/', sub {
    my ($c) = @_;

    $c->res->set_header("content-type", "application/json");
    $c->res->write(encode_json({ ww => 1 }));
});

$app->run();
```


