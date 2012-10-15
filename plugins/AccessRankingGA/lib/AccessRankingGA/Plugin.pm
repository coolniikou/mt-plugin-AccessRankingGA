package AccessRankingGA::Plugin;

use strict;
use base qw(MT::Plugin);
use MT;
use MT::Util qw( start_end_day epoch2ts format_ts trim );
use Encode;

sub _hdlr_analytic_tags {
    my ( $ctx, $args ) = @_;
    my $blog     = $ctx->stash('blog');
    my $blog_id  = $ctx->stash('blog_id');
    my $site_url = $blog->site_url;
    my $plugin   = MT->component('AccessRankingGA');
    my $span     = $args->{span};

    my $now = time;
    my $today = start_end_day( epoch2ts( $blog, $now ) );
    my $ago;
    if ($span) {
        $ago =
          start_end_day( epoch2ts( $blog, $now - ( 60 * 60 * 24 * $span ) ) );
    }
    else {
        $ago = start_end_day( epoch2ts( $blog, $now - ( 60 * 60 * 24 * 7 ) ) );
    }

    my $config = {
        user =>
          $plugin->get_config_value( 'GA_username', 'blog:' . $blog_id ),
        pass =>
          $plugin->get_config_value( 'GA_password', 'blog:' . $blog_id ),
        profileid =>
          $plugin->get_config_value( 'GA_profile_id', 'blog:' . $blog_id ),
        maxresult =>
          $plugin->get_config_value( 'GA_maxresult', 'blog:' . $blog_id ),
        exclude_top =>
          $plugin->get_config_value( 'GA_exclude_top', 'blog:' . $blog_id ),
        exclude_optional_path => trim(
           $plugin->get_config_value( 'GA_exclude_optional_path', 'blog:' . $blog_id )
        ),
        start => format_ts( '%Y-%m-%d', $ago,   $blog ),
        end   => format_ts( '%Y-%m-%d', $today, $blog ),
    };

    my $token = &get_token($config);
    my $data = &get_data( $token, $config );
    return $data if( MT->VERSION < 5 );

    $data = decode_utf8($data);
    return $data;
}

sub get_token {
    my $config   = shift;
    my $plugin   = MT->component('AccessRankingGA');
    my $ua =
      MT->new_ua( { agent => join( "/", $plugin->name, $plugin->version ) } );
    my $token_url = 'https://www.google.com/accounts/ClientLogin';
    my $tk_con    = {
        accountType => 'GOOGLE',
        Email       => $config->{user},
        Passwd      => $config->{pass},
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
     my ( $token, $config ) = @_;
     my $plugin   = MT->component('AccessRankingGA');
     my $ua =
       MT->new_ua( { agent => join( "/", $plugin->name, $plugin->version ) } );
     my $url =
         "https://www.googleapis.com/analytics/v3/data/ga"
       . "?ids=ga:"
       . $config->{profileid}
       . "&dimensions=ga:pagePath,ga:pageTitle"
       . "&metrics=ga:uniquePageviews"
       . "&sort=-ga:uniquePageviews"
       . "&start-date="
       . $config->{start}
       . "&end-date="
       . $config->{end}
       . "&max-results="
       . $config->{maxresult};
     ## optional exlude settings
     if ( $config->{exclude_top}
         || $config->{exclude_optional_path}
         && $config->{exclude_optional_path} ne '' )
     {
           $url .= "&filters=";
           my @exclude_paths =
                   ( $config->{exclude_optional_path} =~ /(\S+)/g );
           for ( @exclude_paths ) {
               $url .= "ga:pagePath!~". $_ . ";";
           }

           $url .= "ga:pagePath!~/%24;ga:pagePath!~/index.html%24"
                   if ( defined($config->{exclude_top}) );
     }

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
