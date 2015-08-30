package Mojolicious::Plugin::IP2Location;

# VERSION

use Mojo::Base 'Mojolicious::Plugin';
use Geo::IP2Location::Lite;

my %Province_Map = (
    'Alberta'                   => 'AB',
    'British Columbia'          => 'BC',
    'Manitoba'                  => 'MB',
    'New Brunswick'             => 'NB',
    'Newfoundland and Labrador' => 'NL',
    'Northwest Territories'     => 'NT',
    'Nova Scotia'               => 'NS',
    'Nunavut'                   => 'NU',
    'Ontario'                   => 'ON',
    'Prince Edward Island'      => 'PE',
    'Quebec'                    => 'QC',
    'Saskatchewan'              => 'SK',
    'Yukon Territory'           => 'YT',
);

sub register {
    my ($self, $app) = @_;

    state $geo_ip = Geo::IP2Location::Lite->open(
        $app->config('ip2location')
    );

    $app->helper(
        geoip_region=> sub {
            my $c = shift;

            my $is_debug_ip
            = $c->app->mode eq 'development' && $c->param('DEBUG_GEOIP');

            return $c->session('gip_r')
                if not $is_debug_ip and length $c->session('gip_r');

            my $ip = $is_debug_ip
                ? $c->param('DEBUG_GEOIP') : $c->tx->remote_address;

            $c->session(
                gip_r => $Province_Map{ $geo_ip->get_region( $ip ) } // '00'
            );
            return $c->session('gip_r');
        },
    );
}

1;

__END__

=encoding utf8

=for stopwords scalarref RULESETS rulesets subref ruleset

=head1 NAME

Mojolicious::Plugin::IP2Location - Mojolicious wrapper around Geo::IP2Location::Lite

=head1 SYNOPSIS

    #!/usr/bin/env perl

    use Mojolicious::Lite;

    plugin 'IP2Location';

=head1 DESCRIPTION

L<Mojolicious> plugin wrapper for L<Geo::IP2Location::Lite>

=for pod_spiffy start warning section

This module is released as is to support the release of another distro.
Proper docs and tests will follow soon. B<The interface will change.>

=for pod_spiffy end warning section

=head1 SEE ALSO

L<Geo::IP2Location::Lite>, L<Geo::IP2Location>,
L<http://lite.ip2location.com/database-ip-country-region-city>

=for pod_spiffy hr

=head1 REPOSITORY

=for pod_spiffy start github section

Fork this module on GitHub:
L<https://github.com/zoffixznet/Mojolicious-Plugin-IP2Location>

=for pod_spiffy end github section

=head1 BUGS

=for pod_spiffy start bugs section

To report bugs or request features, please use
L<https://github.com/zoffixznet/Mojolicious-Plugin-IP2Location/issues>

If you can't access GitHub, you can email your request
to C<bug-Mojolicious-Plugin-IP2Location at rt.cpan.org>

=for pod_spiffy end bugs section

=head1 AUTHOR

=for pod_spiffy start author section

=for pod_spiffy author ZOFFIX

=for pod_spiffy end author section

=head1 LICENSE

You can use and distribute this module under the same terms as Perl itself.
See the C<LICENSE> file included in this distribution for complete
details.

=cut