use strict;
use warnings;

package namespace::alias;

use 5.008008;
use XSLoader;
use Class::MOP;
use B::Hooks::OP::Check;
use B::Hooks::EndOfScope;

our $VERSION = '0.01';

XSLoader::load(__PACKAGE__, $VERSION);

sub import {
    my ($class, $package, $alias) = @_;

    Class::MOP::load_class($package);

    ($alias) = $package =~ /(?:::|')(\w+)$/
        unless defined $alias;

    my $file = (caller)[1];

    my $hook = $class->setup($file => sub {
        my ($str) = @_;

        if ($str =~ s/^$alias\b/$package/) {
            return $str;
        }

        return;
    });

    on_scope_end {
        $class->teardown($hook);
    };
}

1;

__END__

=head1 NAME

namespace::alias - Foo

=head1 SYNOPSIS

  use namespace::alias 'My::Company::Namespace::Customer';

  # plain aliasing of a namespace
  my $cust = Customer->new;            # My::Company::Namespace::Customer->new

  # namespaces relative to the alias
  my $pref = Customer::Preferred->new; # My::Company::Namespace::Customer::Preferred->new

  # getting the expansion of an alias
  my $customer_class = Customer;

  # also works for packages relative to the alias
  my $preferred_class = Customer::Preferred;

  # calling a function in an aliased namespace
  Customer::some_func()

=head1 SEE ALSO

=over 4

=item L<aliased>

=back

=head1 AUTHOR

Florian Ragwitz E<lt>rafl@debian.orgE<gt>

With contributions from:

=over 4

=item Robert 'phaylon' Sedlacek E<lt>rs@474.atE<gt>

=item Steffen Schwigon E<lt>ss5@renormalist.netE<gt>

=back

=head1 COPYRIGHT AND LICENSE

Copyright (c) 2009  Florian Ragwitz

Licensed under the same terms as perl itself.

=cut
