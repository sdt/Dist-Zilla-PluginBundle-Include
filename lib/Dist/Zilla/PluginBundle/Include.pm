use strict;
use warnings;
package Dist::Zilla::PluginBundle::Include;
# ABSTRACT: Use an external ini file as a plugin bundle.

use Moose;
with 'Dist::Zilla::Role::PluginBundle::Easy';

use Config::MVP::Reader::INI;
use namespace::autoclean;

sub configure {
    my ($self) = @_;

    use Data::Dumper::Concise;
    use feature 'say';
    say STDERR Dumper($self);

    my $ini = Config::INI::Reader->new->read_file($self->payload->{file});
    say STDERR Dumper($ini);

    for my $name (keys %{ $ini }) {
        my $config = $ini->{$name};

        if ($name =~ s/^@//) {
            $self->add_bundle($name => $config);
        }
        else {
            $self->add_plugins( [ $name => $config ] );
        }

    }

    $self->add_plugins(qw( Readme ));
    $self->add_plugins(qw( License ));
    say STDERR Dumper($self);
}

__PACKAGE__->meta->make_immutable;
1;
