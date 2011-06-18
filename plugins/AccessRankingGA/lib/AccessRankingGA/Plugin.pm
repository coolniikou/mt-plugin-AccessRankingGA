package AccessRankingGA::Plugin;
use strict;
use base qw(MT::Plugin);
use MT;
use MT::Util qw( start_end_day epoch2ts format_ts trim );
use XML::Simple;
use JSON;
use File::Basename qw( basename );
use Data::Dumper;

## DEBUC CODE
sub doLog {
    my ( $msg, $class ) = @_;
    return unless defined($msg);
    use MT::Log;
    my $log = MT::Log->new;
    $log->message($msg);
	$log->level(MT::Log::DEBUG());
	$log->class($class) if $class;
    $log->save or die $log->errstr;
}

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
    my $today = start_end_day( epoch2ts( $blog, $now ) );
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
        profileid =>
          $plugin->get_config_value( 'GA_profile_id', 'blog:' . $blog_id ),
        maxresult =>
          $plugin->get_config_value( 'GA_maxresult', 'blog:' . $blog_id ),
        ex_top =>
          $plugin->get_config_value( 'GA_exclude_top', 'blog:' . $blog_id ),
        ex_path => trim(
            $plugin->get_config_value( 'GA_exclude_path', 'blog:' . $blog_id )
        ),
        start => format_ts( '%Y-%m-%d', $ago,   $blog ),
        end   => format_ts( '%Y-%m-%d', $today, $blog ),
    };

    my $token  = &get_token($conf);
    my $data   = &get_data( $token, $conf );
    my $parser = XML::Simple->new( Forcearray => 1 );
    my $xml    = $parser->XMLin($data);

    my $json = to_json( $xml->{entry} );
    return $json;
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
        "https://www.google.com/analytics/feeds/data?"
      . "ids=ga%3A"
      . $conf->{profileid} . "&"
      . "dimensions=ga%3ApagePath%2Cga%3ApageTitle&"
      . "metrics=ga%3AuniquePageviews&"
      . "sort=-ga%3AuniquePageviews&"
      . "start-date="
      . $conf->{start} . "&"
      . "end-date="
      . $conf->{end} . "&"
      . "max-results="
      . $conf->{maxresult};
    if ( $conf->{ex_top} || $conf->{ex_path} && $conf->{ex_path} ne '' ) {
        $url .= "&filters=";
        $url .= "ga%3ApagePath!%3D%2F;ga%3ApagePath!%3D%2Findex.html;"
          if ( defined( $conf->{ex_top} ) );
        my @ex_paths = ( $conf->{ex_path} =~ /(\S+)/g );
        foreach my $exc (@ex_paths) {
            $url .= "ga%3ApagePath!~" . $exc . ";";
        }
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
