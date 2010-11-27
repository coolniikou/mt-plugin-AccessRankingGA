package AccessRankingGA::Plugin;
use strict;
use base qw(MT::Plugin);
use MT;
use MT::Util qw( start_end_day epoch2ts format_ts trim );
use XML::Simple;
use JSON;
use Data::Dumper;

## DEBUC CODE
sub doLog {
    my ($msg) = @_;
    return unless defined($msg);
    use MT::Log;
    my $log = MT::Log->new;
    $log->message($msg);
    $log->save or die $log->errstr;
}

sub plugin {
    return MT->component('AccessRankingGA');
}

## function tag
sub _hdlr_analytic_tags {
    my ( $ctx, $args ) = @_;
    my $blog    = $ctx->stash('blog');
    my $blog_id = $ctx->stash('blog_id');
    my $plugin  = plugin();
    my $span    = $args->{span};
    my $conf    = &get_conf($blog_id);
    my $date    = &get_date( $blog, $span );
    my $token   = &get_token($conf);

    my $data = &get_data( $token, $conf, $date );
    my $parser = XML::Simple->new( Forcearray => 1 );
    my $xml    = $parser->XMLin($data);
    my $json   = to_json( $xml->{entry} );

#output character encoding
#my $enc = MT::I18N::guess_encoding($json);  ## deal with your situation that character encoding
#my $json = MT::I18N::encode_text($json, $enc, 'utf-8');

    return $json;
}

sub get_conf {
    my $blog_id = shift;
    my $plugin  = plugin();

    #	my @ex_paths = ($ex_path =~ /(\S+)/g);
    #	foreach my $exc (@ex_paths) {
    #		doLog($exc);
    #	}
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
    };
    return $conf;
}

sub get_date {
    my ( $blog, $span ) = @_;
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
    my $date = {
        start => format_ts( '%Y-%m-%d', $ago,   $blog ),
        end   => format_ts( '%Y-%m-%d', $today, $blog ),
    };
    return $date;
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
    my ( $token, $conf, $date ) = @_;
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
      . $date->{start} . "&"
      . "end-date="
      . $date->{end} . "&"
      . "max-results="
      . $conf->{maxresult};

#$url .= "&filters=ga%3ApagePath!%3D%2F" if ($ex_top);  #;gd%3ApagePath!~css&" ## add filter option, if would like to exclude TOP Page's data
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
