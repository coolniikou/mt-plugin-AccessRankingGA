package AccessRankingGA::Plugin;

use strict;
use base qw(MT::Plugin);
use MT;
use MT::Util qw( start_end_day epoch2ts format_ts trim );
use Encode;

sub plugin {
    return MT->component('AccessRankingGA');
}

sub _hdlr_analytic_tags {
    my ( $ctx, $args ) = @_;
    my $blog     = $ctx->stash('blog');
    my $blog_id  = $ctx->stash('blog_id');
    my $site_url = $blog->site_url;
    my $plugin   = plugin();
    my $span     = $args->{span};

    my $now = time;
    my $today = start_end_day( epoch2ts( $blog, $now ) ) - 1;
    my $ago;
    if ($span) {
        $ago =
          start_end_day( epoch2ts( $blog, $now - ( 60 * 60 * 24 * $span ) ) );
    }
    else {
        $ago = start_end_day( epoch2ts( $blog, $now - ( 60 * 60 * 24 * 7 ) ) );
    }

    my $conf = {
        user => $plugin->get_config_value( 'GA_username', 'blog:' . $blog_id ),
        pass => $plugin->get_config_value( 'GA_password', 'blog:' . $blog_id ),
        api_key =>
          $plugin->get_config_value( 'GA_api_key', 'blog:' . $blog_id ),
        profileid =>
          $plugin->get_config_value( 'GA_profile_id', 'blog:' . $blog_id ),
        maxresult =>
          $plugin->get_config_value( 'GA_maxresult', 'blog:' . $blog_id ),
        ),
        start => format_ts( '%Y-%m-%d', $ago,   $blog ),
        end   => format_ts( '%Y-%m-%d', $today, $blog ),
    };

    my $token = &get_token($conf);
    my $data = &get_data( $token, $conf );
    return $data if ( MT->VERSION < 5 );

    $data = decode_utf8($data);
    return $data;
}

sub get_token {
    my $conf   = shift;
    my $plugin = plugin();
    my $token;
    my $ua =
      MT->new_ua( { agent => join( "/", $plugin->name, $plugin->version ) } );
    my $token_url = 'https://www.google.com/accounts/ClientLogin';
    my $tk_con    = {
        accountType => 'GOOGLE',
        Email       => $conf->{user},
        Passwd      => $conf->{pass},
        service     => 'analytics',
        source      => 'companyName-applicationName-versionID',
    };
    my $res = $ua->post( $token_url, Content => $tk_con );
    if ( $res->is_success ) {

        if ( $res->content =~ /Auth\=(.+)/i ) {
            return $1;
        }
    }
    else {
        MT->log(
            {
                message => $plugin->translate('as_token_error')
                  . $res->status_line,
                class => 'system',
                level => MT::Log::ERROR(),
            }
        );
        die $plugin->translate('as_token_error') . $res->status_line;
    }
}

sub get_data {
    my ( $token, $conf ) = @_;
    my $plugin = plugin();
    my $ua =
      MT->new_ua( { agent => join( "/", $plugin->name, $plugin->version ) } );
    my $url =
        "https://www.googleapis.com/analytics/v3/data/ga?"
      . "ids=ga:"
      . $conf->{profileid} . "&"
      . "dimensions=ga:pagePath,ga:pageTitle&"
      . "metrics=ga:uniquePageviews&"
      . "sort=-ga:uniquePageviews&"
      . "start-date="
      . $conf->{start} . "&"
      . "end-date="
      . $conf->{end} . "&"
      . "max-results="
      . $conf->{maxresult};

    my @headers = ( Authorization => "GoogleLogin Auth=$token" );
    my $res = $ua->get( $url, @headers );
    if ( $res->is_success ) {
        return $res->content;
    }
    else {
        MT->log(
            {
                message => $plugin->translate('as_contents_error')
                  . $res->status_line,
                class => 'system',
                level => MT::Log::ERROR(),
            }
        );
        die $plugin->translate('as_contents_error') . $res->status_line;
    }
}

1;
