#!perl

use strict;
use warnings;

use Test::More;

{
    package Foo::Bar::Baz;

    sub stuff { }
}

{
    local $@;
    my $ret = eval q[
        use namespace::alias 'Foo::Bar::Baz', 'MyAlias';
        for (;;) { return 1 }
        return 0;
    ];
    is $@, '',  'for (;;) { } compiles fine';
    is $ret, 1, 'for (;;) { } is executed properly';
}

done_testing;
