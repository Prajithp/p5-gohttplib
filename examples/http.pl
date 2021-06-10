#!/usr/bin/perl

use GoHttpLib;
use Cpanel::JSON::XS;
use Data::Dumper;

my $app = GoHttpLib->new();

my $route = $app->route;

$route->add('GET', '/xx', sub {
    my ($c) = @_;
    $c->res->write("xxxxx");
});

$route->add('HEAD', '/', sub {
    my ($c) = @_;

    warn Dumper $c->req; 
    $c->res->set_header("content-type", "application/json");
    $c->res->write(encode_json({ x => 1}));
});

$app->run();
